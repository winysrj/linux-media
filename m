Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:60880 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZHBPWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2009 11:22:51 -0400
Received: from [127.0.0.2] (helo=juli-workstation.localnet)
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <julian@jusst.de>)
	id 1MXctd-0003zi-Pz
	for linux-media@vger.kernel.org; Sun, 02 Aug 2009 17:22:49 +0200
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org
Subject: Re: stb0899 i2c communication broken after suspend
Date: Sun, 2 Aug 2009 17:22:48 +0200
References: <4A731F5D.7000904@jusst.de>
In-Reply-To: <4A731F5D.7000904@jusst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908021722.48840.julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 31. Juli 2009 18:44:13 schrieb Julian Scheel:
> I made an interesting observation with the stb0899 drivers. If the
> system was in suspend to ram state (no matter if dvb modules were
> unloaded before or not) the i2c communication of stb0899 driver and
> chipset seems to be somewhat broken. Tuning to dvb-s channels still
> works as expected, but tuning to dvb-s2 channels is completely broken.
> The system log shows this error on the first tuning approach:
> stb0899_write_s2reg ERR (1), Device=[0xf3fc], Base Address=[0x00000460],
> Offset=[0xf34c], Data=[0x00000000], status=-121

I actually played around a bit more and figured out, that after a reload of 
the i2c_core module the s2 channels start working again after suspend. But as 
this module is needed by many others (like nvidia, so X server has to be 
stopped to unload it), it can't be simply reloaded.
Now the question is whether the issue is in i2c_core itself or in the way that 
stb0899-drivers use i2c_core. Especially I am wondering why only the s2 
channels fail, isn't for the dvb-s2 channels i2c communication used as well?

-Julian
