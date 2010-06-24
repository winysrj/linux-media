Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54785 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0FXTnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 15:43:47 -0400
Received: by bwz7 with SMTP id 7so371364bwz.19
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 12:43:46 -0700 (PDT)
From: Caglar Akyuz <caglarakyuz@gmail.com>
To: linux-media@vger.kernel.org
Subject: DVB-S Frontend + ARM + DSP
Date: Thu, 24 Jun 2010 22:44:24 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006242244.24963.caglarakyuz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've never followed linux-media before, I hope my question is welcome here.

I have a basic project(hopefully), involving connection of an DVB-S frontend 
to an ARM processor. Frontend chip is si2109 which is supported by si21xx 
driver.

I created a pseudo card driver which includes only 3 calls to 
'dvb_register_adapter'  , 'dvb_attach' and 'dvb_register_frontend'. I can do 
some channel scanning with this dummy driver then.

Now I'm in the phase of demuxing and decoding. Since I don't have any hardware 
for this I'm planning to do this on software. I'm planning to perform MPEG-TS 
muxing on ARM and MPEG-2 video decoding on DSP.

Is there any example code to begin with such a use case? I tried to read some 
in tree drivers but I still don't know how to introduce a demux and dvr device 
to user space so that I can use off-shelf applications like gstreamer. 
Moreover, I would definetly need some user-space code, at least for mpegts 
demuxing so I wonder if there is any sane way to make a connection like:

demux0 -> userspace demuxing -> dvr0 -> userpace mpeg2 decoding

Any help on what path/method to use is very appreciated.

Best regards,
Caglar
