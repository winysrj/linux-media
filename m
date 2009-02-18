Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34607 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZBRTgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 14:36:07 -0500
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 75043FAABD53
	for <linux-media@vger.kernel.org>; Wed, 18 Feb 2009 20:36:06 +0100 (CET)
Received: from [91.5.30.216] (helo=tom-nb)
	by smtp06.web.de with esmtp (WEB.DE 4.110 #277)
	id 1LZsDG-0007Gm-00
	for linux-media@vger.kernel.org; Wed, 18 Feb 2009 20:36:06 +0100
To: linux-media@vger.kernel.org
Subject: DVB-S(2) USB Adapter Problems
Content-Disposition: inline
From: "t-erdmann@web.de" <t-erdmann@web.de>
Date: Wed, 18 Feb 2009 21:35:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902182135.56863.t-erdmann@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List,
i switched to MSI Media Center Platform which can only hold one PCI Card about 
a year ago. The built in card is a PCI TT3200 and i added an USB DVB-S2 
TT3600 externaly. 
I used multiproto and multiproto_plus but got no stable data stream for TT3600 
USB adapter. 
Always distortions and broken TS data stream messages out of VDR. 
I switched cables between PCI and USB adapters and saw that the problem is 
always in the USB, PCI card always functions properly.
I switched to S2 API on the Liplianin tree. 
The data stream corruptions continued.
So i bought a TeeVi 650 USB DVB-S2 adapter. 
It uses a different driver and different firmware but same problems with data 
stream corruptions. 
At least i tested the newest 2.6.29-rc5 kernel with built in S2 drivers - with 
the same result, only USB adapter delivers corrupted data.
So i want to ask if anyone uses a USB DVB-S(2) adapter without problems and 
what software configuration is used.

My setup: 
Athlon X2 5000+
4GB DDR2
750GB + 1TB SATA
TT3200 PCI DVB-S2
TeeVi 650 USB DVB-S2

VDR 1.7.0 with xine plugin patched similar to VDR -Wiki
liplianin DVB-S2 repository
ffmpeg out of CVS
xine-lib 1.2
