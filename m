Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:55096 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbHXMbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 08:31:07 -0400
From: "Norbert Auge" <nauge@digitaldevices.de>
To: "'Anton Tinchev'" <atl@unixsol.org>, <linux-media@vger.kernel.org>
Cc: "'Georgi Chorbadzhiyski'" <gf@unixsol.org>,
	"'Marian Zahariev'" <marian@unixsol.org>
References: <55D73692.3040708@unixsol.org>
In-Reply-To: <55D73692.3040708@unixsol.org>
Subject: AW: Bugs reporting
Date: Mon, 24 Aug 2015 14:26:51 +0200
Message-ID: <01b001d0de68$27eb6e10$77c24a30$@digitaldevices.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anton,
the driver for STV0910 does not support ToneBurst (=minidiseqc).
If it is essential for you we can address this in our driver development

best regards
Dieter

-----Ursprüngliche Nachricht-----
Von: Anton Tinchev [mailto:atl@unixsol.org] 
Gesendet: Freitag, 21. August 2015 16:33
An: Norbert Auge; linux-media@vger.kernel.org
Cc: Georgi Chorbadzhiyski; Marian Zahariev
Betreff: Bugs reporting

Hi,
can you point me where is usually reported the bugs with the cards firmware and/or drivers.
The combination is Cine S2 v6.5 with Duoflex S2 V4.

The miniDiSEqC (AB) is not working on the Duoflex S2 V4. Is not board fault, same behavior have all cards i tested - about 20 Duoflex and 8 Cine modules.
For the protocol i tested:

Cine S2 v6.5 + Duoflex S2 V4:
  - ports 0 and 1 (Ports on Cine card) - miniDiSEqC is working
  - ports 0 and 1 (Ports on Cine card) - DiSEqC is working
  - ports 2 and up (Ports on Duflex cards) -   DiSEqC is working
  - ports 2 and up (Ports on Duflex cards) -   miniDiSEqC is NOT WORKING

Cine S2 v6.2 + Duoflex S2 older versions:
  - all ports - both Cine and Duoflex  - miniDiSEqC is working
  - all ports - both Cine and Duoflex - DiSEqC is working


Cine S2 v6.5 + Duoflex S2 older version:
  - Not tested, will test soon

Cine S2 v6.2 + Duoflex S2 V4:
  - Not tested, will test when purchase next batch.


Also there is tons of errors on i2c bus to Duoflex S2 V4 tabs.



This was tested with latest drivers, also was tested with stock drivers with several kernel versions from 3.18.11 to 4.2 rc2 - same behavior

