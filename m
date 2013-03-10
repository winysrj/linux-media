Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58856 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab3CJCIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:08:54 -0500
Message-ID: <1362881375.13530.10.camel@palomino.walls.org>
Subject: Re: cannot unload cx18_alsa to hibernate Mint13 64 computer
From: Andy Walls <awalls@md.metrocast.net>
To: Dixon Craig <dixonjnk@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Sat, 09 Mar 2013 21:09:35 -0500
In-Reply-To: <loom.20130309T225537-954@post.gmane.org>
References: <loom.20130309T225537-954@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2013-03-09 at 21:57 +0000, Dixon Craig wrote:
> Hello and thank you to all linuxtv developers!
> 
> I have my hauppuage pvr-1600 working very nicely for us-cable analog and 
> composite inputs using cx18 from original linuxmint 13 MATE 64 and I also tried 
> newest drivers from git.linuxtv.org.
> 
> My problem is cx18_alsa prevents successful suspend to disk when I run hibernate 
> script.
> 
> I cannot unload module before hibernating because modprobe -r returns "FATAL: 
> Module cx18_alsa is in use." 
> 
> lsmod does not list dependancies but lists 1 in use. here is my lsmod output:
> 
> dixon2@phenom ~ $ lsmod | grep cx
> cx18_alsa              13730  1 
> cx18                  131960  1 cx18_alsa
> dvb_core              105885  1 cx18
> cx2341x                28283  1 cx18
> i2c_algo_bit           13423  1 cx18
> videobuf_vmalloc       13589  1 cx18
> videobuf_core          26022  2 cx18,videobuf_vmalloc
> tveeprom               21249  1 cx18
> v4l2_common            21560  4 cs5345,tuner,cx18,cx2341x
> videodev              135159  5 cs5345,tuner,cx18,cx2341x,v4l2_common
> snd_pcm                97275  3 cx18_alsa,snd_hda_intel,snd_hda_codec
> snd                    79041  18 
> cx18_alsa,snd_hda_codec_via,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_ra
> wmidi,snd_seq,snd_timer,snd_seq_device
> 
> 
> I have tried stopping all sound services (alsa-restore, alsa-store, and 
> pulseaudio) then running modprobe -r on all the above listed modules but they 
> all return the same "in use" error.

pulseaudio respawns when you kill it.  pulseaudio is likely the process
keeping the CX23418 ALSA device node open: use 'ps axf' and 'fuser' as
root on the /dev/snd/pcm* and /dev/snd/control* nodes to verify.

You have these options:

# killall pulseaudio; modprobe -r cx18_alsa; killall pulseaudio;
modprobe -r cx18_alsa; killall pulseaudio; modprobe -r cx18_alsa

or

# pactl (some arcane arugments to get pulseaudio to let go of the cx18
ALSA /dev/ nodes)

or 

# pacmd
> (some arcane commands to get pulseaudio to let go of the cx18
ALSA /dev/ nodes)
> exit

or

# find /lib/modules/`uname -r` -name "cx18-alsa.ko" -exec mv {}
{}.backup \; -print
# shutdown -r now


Regards,
Andy


> I have tried Lubuntu 12.04 with the same hardware and nvidia graphics driver
> using same kernel 3.2.0-38 and I can successfully rmmod cx18_alsa and hibernate
> computer. In Lubuntu, lsmod reports cx18_alsa is used by "0" other modules and
> it rmmods without a problem.
> 
> 
> Is there any other trick I can use to remove cx18_alsa module from kernel?
> 
> Thank you
> 
> Dixon 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


