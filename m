Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodlands.midnighthax.com ([93.89.81.115]:35489 "EHLO
	woodlands.the.cage" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917Ab2CJOb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 09:31:29 -0500
Received: from ws.the.cage ([10.0.0.100])
	by woodlands.the.cage with esmtp (Exim 4.72)
	(envelope-from <kae@midnighthax.com>)
	id 1S6NA3-0001uR-23
	for linux-media@vger.kernel.org; Sat, 10 Mar 2012 14:20:43 +0000
Date: Sat, 10 Mar 2012 14:20:42 +0000
From: Keith Edmunds <kae@midnighthax.com>
To: linux-media@vger.kernel.org
Subject: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
Message-ID: <20120310142042.0f238d3a@ws.the.cage>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi List

I'm having lots of problems with my PCTV Nanostick 290e under MythTV. Is
this the best place to report these problems?

I'm happy to provide whatever detail is needed, but in summary:

 - every day or two, I get the error messages logged below. I need to
   reboot the back end to clear them.

 - when the back end comes back up, 'lsusb' doesn't show the 290e. I have
   to unplug it, wait a few seconds, then plug it back in again

This is extremely frustrating. When it works, it's great; when it doesn't,
recordings fail.

The following errors are reported repeatedly:

Mar  9 10:02:03 woodlands kernel: [ 6006.157991] cxd2820r: i2c wr failed
ret:-110 reg:85 len:1 
Mar  9 10:02:05 woodlands kernel: [ 6008.511994] cxd2820r: i2c wr failed
ret:-110 reg:00 len:1 
Mar  9 10:02:08 woodlands kernel: [ 6011.208909] cxd2820r: i2c wr failed
ret:-110 reg:85 len:1 
Mar 9 10:02:10 woodlands kernel: [ 6013.566440] cxd2820r: i2c wr failed
ret:-110 reg:00 len:1

MythTV backend details:
 - Debian v6.0.4 ("Squeeze")
 - Debian multimedia repository
 - Myth version 0.24.2-0.0squeeze1 (as packaged by repository)
 - Kernel: 2.6.32-5-686-bigmem (I've also tried 3.2.0-0.bpo.1-686-pae,
   both Debian-packaged)
 - Tuners: 2 x Hauppauge Nova-T Stick (USB) and 1 x PCTV Nanostick 290e
   (also USB)
 - no module load parameters specified
 - tuning delay 750mS for each tuner
 - drivers for the 290e built using the media_build scripts
   (http://git.linuxtv.org/media_build.git)

Many thanks,
Keith
-- 
"You can have everything in life you want if you help enough other people
get what they want" - Zig Ziglar. 

Who did you help today?
