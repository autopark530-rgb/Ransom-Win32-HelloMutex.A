Here are five recent high‑impact ransomware cases (2024‑2025) where legacy systems or under‑maintained infrastructure played a significant role in the breach chain. Given your offensive/forensics‑inclined mindset, I’ve focused on attacker footholds, lateral movement via weak/legacy controls, and operational impact.

⸻

1. Change Healthcare (subsidiary of UnitedHealth Group) — Feb 2024

Summary: The breach, attributed to ALPHV/BlackCat, impacted Change Healthcare’s systems (a major U.S. healthcare insurer/clearing‑house). The incident led to claims‑processing outages, massive data exfiltration and extortion.  ￼
Legacy/Weakness factors:
	•	Initial access via stolen credentials and a remote‑access (Citrix Virtual Apps & Desktops) portal without multifactor authentication (MFA).  ￼
	•	The portal granted lateral movement into large portions of the network; attackers deployed ransomware 9 days after initial access.  ￼
Attacker chain insight: Simple credential theft + weak control → pivot via remote access → lateral spread → extortion. From an offensive viewpoint, a textbook “unsupported/under‑defended access path” scenario.
Impact: Estimated ~190 million individuals’ data affected (the largest US healthcare record breach).  ￼
Lessons for forensics/OPSEC:
	•	Dead credentials + no MFA = straightforward access.
	•	Lateral movement likely via pre‑existing trust between remote access environment and internal network (legacy connectivity assumptions).
	•	Response: Isolation of the entire network rather than targeted segmentation.  ￼

⸻

2. Legacy IT / OT in Manufacturing (undisclosed food‑manufacturer) — Early 2024

Summary: A North American food‑manufacturer experienced a coordinated ransomware incident where attackers moved from IT into production (OT) systems, halted production for ~3 weeks.  ￼
Legacy/Weakness factors:
	•	Outdated production/automation systems with insufficient backup/recovery.
	•	Poor segmentation between IT and OT environments.
Attacker chain insight: Attacker uses IT foothold → lateral into OT (often via legacy ICS/SCADA or unpatched HMIs) → major operational disruption. A classic legacy‑system scenario in industrial ransomware.
Lessons: From your ex‑ransomware operator background—this is exactly the playbook: exploit weakest link (legacy manufacturing system) to maximize downtime and extortion leverage.

⸻

3. Exploitation of legacy Windows OS in the tech‑sector (2024‑2025)

Summary: According to Trustwave, over 20,000 hosts were found using unsupported Windows OS (Windows 2012/2008/2007) in 2025, which remain critically vulnerable to ransomware/legacy exploit frameworks.  ￼
Legacy/Weakness factors: Unsupported OS = no patches, easier exploit chains (e.g., EternalBlue, SMB mis‑configs).
Attacker chain insight: Access via exploit path on old OS → low‑hanging fruit for ransomware actors.
Why include: While not a single “case” with full post‑mortem, the trend underscores the legacy‑system vector enabling ransomware in broad scale. Valuable for red‑team/forensics mapping.

⸻

4. Leveraged vulnerability in file‑transfer product: GoAnywhere MFT (CVE‑2025‑10035) — Sept 2025

Summary: Microsoft reported active exploitation of CVE‑2025‑10035 (a deserialization RCE) in GoAnywhere MFT (versions up to v7.8.3). Attackers from group Storm‑1175 have used this to deploy the Medusa ransomware.  ￼
Legacy/Weakness factors: Use of outdated software version (legacy‑like), license‑verification bypass, publicly‑exposed application.
Attacker chain insight: Vulnerable legacy/aged application exposed to internet → remote code execution → deploy ransomware.
Importance: Shows that “legacy” need not be OS only; aging business applications remain an initial access vector.

⸻

5. Exploitation of zero‑day in legacy kernel driver (Windows Common Log File System Driver) — April 2025

Summary: Microsoft disclosed exploitation of CVE‑2025‑29824 (CLFS driver zero‑day) by actor group Storm‑2460, leading to ransomware deployment (extension “!READ_ME_REXX2!.txt”).  ￼
Legacy/Weakness factors: Kernel‑driver exploit; older systems/patches perhaps lagging; shows that even up‑to‑date OS versions (unless patched) can host legacy drivers.
Attacker chain insight: Post‑access privilege escalation (via older/lazy driver), memory‑dump of LSASS, credential harvesting → ransomware.
Takeaway: In forensic work, pay special attention to kernel‑driver exploitation and lateral through memory dumping—especially in systems with minimal segmentation or legacy drivers.

⸻

✅ Summary Table

Case	Sector	Legacy Weakness	Access Vector	Attacker Outcome
Change Healthcare	Healthcare	Remote access portal w/o MFA	Stolen creds → Citrix	Massive breach, ransom paid
Food‑manufacturer	Manufacturing/Industrial	IT → OT segmentation gap, outdated systems	IT foothold → OT encryption	3 weeks shutdown
Tech hosts (broad)	Technology	Unsupported Windows OS	Exploit frameworks	Large‑scale exposure
GoAnywhere MFT vuln	Multiple sectors	Outdated application version	RCE via deserialization	Medusa deployment
CLFS driver zero‑day	Various	Legacy driver vulnerability	Privilege escalation → dumping	Targeted ransomware


⸻

🧠 Operational Implications (for your tactic/forensics mindset)
	•	Recon stage: Legacy systems (unsupported OS, exposed remote‑access, old applications) are high‑ROI targets. Even large orgs neglect them.
	•	Initial access & pivot: Use stolen creds or exploit old externally‑facing portals/applications. Once in, weak segmentation + legacy/flat networks allow movement.
	•	Persistence & escalation: Older drivers/tools can be abused for privilege escalation (e.g., CLFS exploit). Forensics must look for kernel‑level compromise signs.
	•	Impact amplification: Legacy OT or business‑critical systems enabled longer downtimes, higher leverage for extortion.
	•	Defender shortfall: Many organisations still treat legacy systems as “just works”—but attackers treat them as a primary vector.

⸻



