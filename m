Return-path: <linux-media-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:37767 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbZH3QXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 12:23:17 -0400
Received: from p57aea4bd.dip0.t-ipconnect.de ([87.174.164.189] helo=delta.localnet)
	by jessica.hrz.tu-chemnitz.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jens.reimann@s2003.tu-chemnitz.de>)
	id 1MhmIw-0005Tm-8Y
	for linux-media@vger.kernel.org; Sun, 30 Aug 2009 17:26:54 +0200
From: Jens Reimann <jens.reimann@s2003.tu-chemnitz.de>
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV-HVR 900 R2 (DRX 3973D)
Date: Sun, 30 Aug 2009 17:26:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908301726.52296.jens.reimann@s2003.tu-chemnitz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
it's again about the second revision of  WinTV-HVR 900. I'm know about the 
problems and conflicts with this device and the developers of the driver. I'm 
still using the driver from Markus Rechberger (www.mcentral.de) but he stopped 
development and there is only support up to Linux kernel 2.6.28. 
I would like to see support for DVB-T for this device in the linuxtv tree. As 
much as I understood, the problem is initializing the drx3973d chip with 
proper data, but there are no specs available. I own one of these devices and 
willing to help debugging. I even have the programming skills to do 
investigations. But, are there any hints where to start? For example there are 
parameters for this device in the tree of Markus. May be these parameters can 
be used (even if not understood) to get the device working.

Thanks
Jens
