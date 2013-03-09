Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3CIWEr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 17:04:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UERt2-0003A1-92
	for linux-media@vger.kernel.org; Sat, 09 Mar 2013 23:05:05 +0100
Received: from d173-181-122-224.abhsia.telus.net ([173.181.122.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 09 Mar 2013 23:05:04 +0100
Received: from dixonjnk by d173-181-122-224.abhsia.telus.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 09 Mar 2013 23:05:04 +0100
To: linux-media@vger.kernel.org
From: Dixon Craig <dixonjnk@gmail.com>
Subject: cannot unload =?utf-8?b?Y3gxOF9hbHNh?= to hibernate Mint13 64 computer
Date: Sat, 9 Mar 2013 21:57:48 +0000 (UTC)
Message-ID: <loom.20130309T225537-954@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello and thank you to all linuxtv developers!

I have my hauppuage pvr-1600 working very nicely for us-cable analog and 
composite inputs using cx18 from original linuxmint 13 MATE 64 and I also tried 
newest drivers from git.linuxtv.org.

My problem is cx18_alsa prevents successful suspend to disk when I run hibernate 
script.

I cannot unload module before hibernating because modprobe -r returns "FATAL: 
Module cx18_alsa is in use." 

lsmod does not list dependancies but lists 1 in use. here is my lsmod output:

dixon2@phenom ~ $ lsmod | grep cx
cx18_alsa              13730  1 
cx18                  131960  1 cx18_alsa
dvb_core              105885  1 cx18
cx2341x                28283  1 cx18
i2c_algo_bit           13423  1 cx18
videobuf_vmalloc       13589  1 cx18
videobuf_core          26022  2 cx18,videobuf_vmalloc
tveeprom               21249  1 cx18
v4l2_common            21560  4 cs5345,tuner,cx18,cx2341x
videodev              135159  5 cs5345,tuner,cx18,cx2341x,v4l2_common
snd_pcm                97275  3 cx18_alsa,snd_hda_intel,snd_hda_codec
snd                    79041  18 
cx18_alsa,snd_hda_codec_via,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_ra
wmidi,snd_seq,snd_timer,snd_seq_device


I have tried stopping all sound services (alsa-restore, alsa-store, and 
pulseaudio) then running modprobe -r on all the above listed modules but they 
all return the same "in use" error.

I have tried Lubuntu 12.04 with the same hardware and nvidia graphics driver
using same kernel 3.2.0-38 and I can successfully rmmod cx18_alsa and hibernate
computer. In Lubuntu, lsmod reports cx18_alsa is used by "0" other modules and
it rmmods without a problem.


Is there any other trick I can use to remove cx18_alsa module from kernel?

Thank you

Dixon 


