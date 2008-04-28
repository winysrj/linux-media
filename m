Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.n.vinogradov@gmail.com>) id 1JqJrt-0002pG-F3
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 05:17:30 +0200
Received: by wf-out-1314.google.com with SMTP id 28so4112885wfa.17
	for <linux-dvb@linuxtv.org>; Sun, 27 Apr 2008 20:17:23 -0700 (PDT)
Message-ID: <a88999c70804272017y544e9f49h131451de927e0f96@mail.gmail.com>
Date: Mon, 28 Apr 2008 10:17:23 +0700
From: "Alexey Vinogradov" <a.n.vinogradov@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Can't compile saa7134_alsa on generic ubuntu kernel
	(Hardy)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello.

I've downloaded the sources of v4l-dvb and built them (I have A16D
tuner which is not supported in "main" kernel). However, saa7134-alsa
wasn't built. "make xconfig" also had this module unchecked (and
unavailable to check).

I've found that this is because of "ubuntu" way of building system:
the generic kernel config file doesn't has ALSA subsystem checked.
Actually you have to install two modules: linux-image and
linux-ubuntu-modules. First contains "minimal" kernel with just
essential options - and .config file corresponding to it.
linux-ubuntu-modules contains everything else - including all ALSA
staff, etc.

The comment in media/saa7134/BOM said:

#
# All of the saa7134 sources were copied directly from the 2.6.24 kernel.
#
# The ALSA depedent modules must be built in LUM since ALSA is
# disabled in the kernel. Not all of the saa7134 modules are depedent on
# ALSA, but it just seemed simpler to grab the whole pile.
#
# Note that the compilation of the saa7134 sources is also dependent on
# the kernel headers packages containing some internal header files
# from the drivers/media directories.
#
# Tim Gardner Apr 3, 2008.

So, my problem is that I can't build v4l-dvb saa7134-alsa module
because ALSA is disabled in kernel.

If I enable the alsa in kernel config, it said this during stage 2 of
building modules:

WARNING: "snd_pcm_lib_ioctl"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_format_big_endian"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_format_signed"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_format_width"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_period_elapsed"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_stop"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_format_physical_width"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_hw_constraint_step"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_hw_constraint_integer"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_card_register"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_set_ops"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_pcm_new"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_ctl_add"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_ctl_new1"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_card_new"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!
WARNING: "snd_card_free"
[/home/alexey/v4l-dvb-3366cefd1b57/v4l/saa7134-alsa.ko] undefined!

The module after such warning IS compiled - but cause segmentation
fault, and is unusable because of it.

I believe that I need to mess some way the v4l-dvb with sources of
linux-ubuntu-modules - to point some way that the ALSA is exists, and
it is not in the kernel. but in the ubuntu-modules.

Am I right?

How to do it?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
