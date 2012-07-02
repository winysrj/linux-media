Return-path: <linux-media-owner@vger.kernel.org>
Received: from persephone.nexusuk.org ([217.172.134.9]:57075 "EHLO nexusuk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2GBRG1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Jul 2012 13:06:27 -0400
Received: from [146.90.100.166] (helo=atlantis.nexusuk.org)
	by nexusuk.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <steve@nexusuk.org>)
	id 1SljZE-00076B-Ot
	for linux-media@vger.kernel.org; Mon, 02 Jul 2012 17:33:40 +0100
Message-ID: <4FF1CD63.10003@nexusuk.org>
Date: Mon, 02 Jul 2012 17:33:39 +0100
From: Steve Hill <steve@nexusuk.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: pctv452e
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I've been using a Technotrend TT 3600 USB DVB-S2 receiver for a couple 
of years, which has (largely) been working fine under the S2-liplianin 
pctv452e driver.  I've been aware of a lot of documented problems with 
running this receiver under the 3.x kernel, so I've stuck with the 2.6 
series kernels.

Unfortunately I've now had to upgrade to the 3.2.0 kernel for other 
unrelated reasons, and it seems that the device is more or less unusable 
under this kernel.  With the stock 3.2.0 kernel, the driver produces 
numerous I2C errors and is quite unreliable.  The I2C errors seem to be 
produced exclusively as a result of stb_6100_read_reg() reading register 
F, and notably all calls to stb6100_read_regs() seem to succeed, so I've 
replaced the stb_6100_read_reg() function with a call to 
stb6100_read_regs(), so it reads all the registers and then returns the 
requested one, rather than reading just the requested register.  This 
seems to make the I2C errors disappear.

However, the card is still very unreliable - after about 5 minutes of 
receiving a channel (using MythTV), it breaks.  No errors logged in 
dmesg, but MythTV logs:

DevRdB(/dev/dvb/adapter0/frontend0) Error: Poll giving up
DVBSH(/dev/dvb/adapter0/frontend0) Error: Device error detected
DVBRec(7:/dev/dvb/adapter0/frontend0) Error: Stream handler died 
unexpectedly.


Can anyone give me any pointers that might help?  I've searched and 
searched and all I can see if people saying that it won't work since the 
DVB-S2 code was integrated into the kernel tree, but I've not seen 
anyone try to figure out _why_ it won't work.

Thanks.

-- 

  - Steve

