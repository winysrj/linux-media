Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:52582 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbbHUOhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 10:37:55 -0400
Message-ID: <55D73692.3040708@unixsol.org>
Date: Fri, 21 Aug 2015 17:32:50 +0300
From: Anton Tinchev <atl@unixsol.org>
MIME-Version: 1.0
To: Norbert Auge <nauge@digitaldevices.de>, linux-media@vger.kernel.org
CC: Georgi Chorbadzhiyski <gf@unixsol.org>,
	Marian Zahariev <marian@unixsol.org>
Subject: Bugs reporting
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
can you point me where is usually reported the bugs with the cards firmware and/or drivers.
The combination is Cine S2 v6.5 with Duoflex S2 V4.

The miniDiSEqC (AB) is not working on the Duoflex S2 V4. Is not board fault, same behavior have
all cards i tested - about 20 Duoflex and 8 Cine modules.
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



This was tested with latest drivers, also was tested with stock drivers with several
kernel versions from 3.18.11 to 4.2 rc2 - same behavior
