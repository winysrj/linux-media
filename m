Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:35946 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1IGQBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:01:54 -0400
Message-ID: <4E679407.1090300@mlbassoc.com>
Date: Wed, 07 Sep 2011 09:55:51 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: OMAP3 ISP and UYVY422
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I now have my camera, attached to TVP5150 running in BT656 mode,
grabbing data.  Sadly, the output is not yet correct.

My pipeline is set up as:
   media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
   media-ctl -f '"tvp5150 2-005c":0[UYVY2X8 720x480], "OMAP3 ISP CCDC":0[UYVY2X8 720x480], "OMAP3 ISP CCDC":1[UYVY2X8 720x480]'

Running this command to grab the data:
   ffmpeg -r 14/1 -pix_fmt uyvy422 -s 720x480 -f video4linux2 -i /dev/video2 -f rawvideo raw-3.0

My UYVY422 data looks like this (raw-3.0):
   0000000: 0080 0080 007f 0080 007f 0080 007f 0080  ................
   0000010: 0080 0080 0080 0080 0080 0080 0080 0080  ................
   0000020: 0080 0080 0080 0080 007f 0080 0080 0080  ................
   0000030: 0080 007f 0080 007f 0080 007f 0080 007f  ................

It should look more like this (raw-2.6.32):
   0000000: 8034 8033 8034 8034 8034 8034 8034 8034  .4.3.4.4.4.4.4.4
   0000010: 8034 8033 8034 8034 8034 8034 8034 8033  .4.3.4.4.4.4.4.3
   0000020: 8034 8034 8034 8034 8034 8034 8033 8032  .4.4.4.4.4.4.3.2
   0000030: 8034 8035 8033 8034 8033 8034 8033 8034  .4.5.3.4.3.4.3.4

n.b. these are grabbed from the same image on the camera, on the same
board - either running the new media controller code (3.0+) or old TI
PSP code (2.6.32)

I've compared the CCDC registers between the two systems and they look
pretty good to me (none of the differences explain the behaviour above)

It looks to me like the 8 bit data coming into the CCDC is not being
packed properly, as well as the second byte of each pair is being
dropped.

Any hints on where to look, what might be mis-configured, etc?

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
