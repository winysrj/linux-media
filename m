Return-path: <mchehab@pedra>
Received: from mail.quiktron.com ([64.129.117.10]:56307 "EHLO mail.lastar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1AJAow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 19:44:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.lastar.com (Postfix) with ESMTP id 5EDED2A6005
	for <linux-media@vger.kernel.org>; Sun,  9 Jan 2011 19:36:39 -0500 (EST)
Received: from mail.lastar.com ([127.0.0.1])
	by localhost (mail.lastar.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9hnsUoMD-Zqh for <linux-media@vger.kernel.org>;
	Sun,  9 Jan 2011 19:36:39 -0500 (EST)
Received: from server51.ctg.com (server51.ctg.com [192.168.74.10])
	by mail.lastar.com (Postfix) with ESMTP id 41B182A6004
	for <linux-media@vger.kernel.org>; Sun,  9 Jan 2011 19:36:39 -0500 (EST)
From: Jason Gauthier <jgauthier@lastar.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Enable IR on hdpvr
Date: Mon, 10 Jan 2011 00:36:37 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey all,

   I've been a long time MythTV user, and earlier this year purchased two Hauppauge HDPVRs.   I was running the Mythbuntu distribution (10.04) which had a 2.6.32.

Using a custom hdpvr module, I had the IR bits turned on, and a custom lirc_zilog (which was not standard in the kernel then).  
When hdpvr.ko would load, it would enable the IR chipset, and lirc_zilog would pick it up.  Occasionally, I would an oops, and I believe this is why the IR pieces were disabled to begin with.

Well, a ton of changes have occurred since .32, to .37.  Namely, I2C changes.  The custom code I have won't compile at all.  
So, I started doing some more digging, and I discovered the linuxtv git repository.  Recently, Andy Walls put some piece in place that interested me.

I pulled the tree down, and worked with it a while.  What I am trying to do is re-enable the IR transmitter in the hdprv module. I've done plenty of development but, unfortunately, this is a bit over my head.   

After reading through these three patches:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg26264.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg07588.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg07589.html

It looks very close to what I am interested in.  

I've spent awhile messing with this, but just haven't gotten anywhere.    Does anyone know what it would take, or how, to enable the IR bits on the hdpvr code?

I did simply try changing:

       /* until i2c is working properly */
       retval = 0; /* hdpvr_register_i2c_ir(dev); */
       if (retval < 0)

so that it would register with i2c.
Doing so returns a positive registration with I2C, but the lirc_zilog driver doesn't see the chip when it loads. (The lirc_zilog is now in the kernel, yay)

Really appreciate any help!

Thanks,

Jason

