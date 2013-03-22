Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42933 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161040Ab3CVRcP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 13:32:15 -0400
Received: from dyn3-82-128-189-172.psoas.suomi.net ([82.128.189.172] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UJ5p7-00032K-86
	for linux-media@vger.kernel.org; Fri, 22 Mar 2013 19:32:13 +0200
Message-ID: <514C9579.5040309@iki.fi>
Date: Fri, 22 Mar 2013 19:31:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Fwd: [SE-2011-01] PoC code for digital SAT TV research released
References: <514B0B81.2090408@security-explorations.com>
In-Reply-To: <514B0B81.2090408@security-explorations.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could be interesting reading for DTV hackers!

regards
Antti


-------- Original Message --------
Subject: [SE-2011-01] PoC code for digital SAT TV research released
Date: Thu, 21 Mar 2013 14:30:41 +0100
From: Security Explorations <contact@security-explorations.com>
To: full-disclosure@lists.grok.org.uk, bugtraq@securityfocus.com


Hello All,

Last year, we disclosed information pertaining to security issues
discovered as a result of our digital satellite TV research [1].

It's been over a year and we haven't received [2] information with
respect to the status and impact of the vulnerabilities found in:
- digital satellite TV set-top-boxes produced by Advanced Digital
   Broadcast [3],
- DVB / MPEG chipsets manufactured by STMicroelectronics [4].

We haven't received important information from Conax AS [5] either.

This in particular concerns a final security level assigned by the
company to set-top boxes and secure DVB chipsets evaluated as part
of Conax security / evaluation process. Conax "rigorous evaluation
and testing regime" [6] missed serious security vulnerabilities
potentially affecting 540 millions [7] of DVB / MPEG chipsets.

Today, a new digital satellite TV platform starts in Poland. It is
called NC+ [8] and it is apparently based on equipment / technology
coming from several vendors, which were affected by security issues
found as part of SE-2011-01 project.

We take the above as a perfect opportunity to verify whether these
vendors had learned anything from the results of our 1.5 years long
research. We assume that they have and that in particular:
- all of security issues discovered as part of our SE-2011-01 project
   have been properly resolved,
- new equipment is considerably harder to hack or use for any SAT TV
   piracy purposes.

We decided to release our Proof of Concept code developed as part of
SE-2011-01 project [9]. Its source code is is available for download
from the following location:

http://www.security-explorations.com/en/SE-2011-01-details.html

We believe that the security community and professionals involved in
a development of digital satellite TV ecosystems should benefit the
most from the release of our Proof of Concept code.

Thank you.

Best Regards,
Adam Gowdiak

---------------------------------------------
Security Explorations
http://www.security-explorations.com
"We bring security research to the new level"
---------------------------------------------

References:
[1] SE-2011-01 Security weaknesses in a digital satellite TV platform
     http://www.security-explorations.com/en/SE-2011-01.html
[2] SE-2011-01 Vendors status
     http://www.security-explorations.com/en/SE-2011-01-status.html
[3] Advanced Digital Broadcast
     http://www.adbglobal.com
[4] STMicroelectronics
     http://www.st.com
[5] Conax AS
     http://www.conax.com
[6] Conax Security Evaluation Scheme

http://www.conax.com/products-solutions/advanced-security-features/security-evaluation-scheme/
[7] Multimedia Convergence & ACCI Sector Overview, Philippe Lambinet,
STMicroelectronics

http://www.st.com/internet/com/CORPORATE_RESOURCES/COMPANY/COMPANY_PRESENTATION/5_mult_conv_acci_lambinet.pdf
[8] NC+ Digital Satellite TV Plaform
     http://ncplus.pl/
[9] SE-2011-01 Proof of Concept Code (technical information)
     http://www.security-explorations.com/en/SE-2011-01-poc.html


