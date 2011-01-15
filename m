Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1AOP0r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 10:26:47 -0500
Message-ID: <4D31BCAA.904@redhat.com>
Date: Sat, 15 Jan 2011 13:26:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pasquale Riccio <puskyer@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: no sound with WinTV HVR-980 - Help
References: <loom.20110115T060015-825@post.gmane.org>	<4D31B615.1070407@redhat.com> <AANLkTik+M27T6CqLyfyB1F1WBOif70OanQdn3fN9dqBg@mail.gmail.com>
In-Reply-To: <AANLkTik+M27T6CqLyfyB1F1WBOif70OanQdn3fN9dqBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-01-2011 13:15, Pasquale Riccio escreveu:
> How do I verify if I have the latest headers? do I use the Ubuntu repositories to update (apt-get)  or should I download a version from somewhere?

Sorry, I've no idea. I'm not an Ubuntu user, but it seems that they compile alsa on a separate
package, and they don't include the alsa headers at the kernel tree. The out-of-tree compilation
of media_build (and the deprecated mercurial tree) only looks for the alsa headers on the
kernel tree (where they should be). 

So, if Ubuntu shipping the alsa headers on a different directory or aren't providing the
alsa headers at all, the driver will compile, but, as the headers will be obsolete,
any alsa driver compiled from V4L/DVB won't work, as symbol definitions won't match.

One way to fix it is to get the latest kernel (2.6.37) from kernel.org and compile from it.
I think that there were no recent changes on em28xx that could affect HVR-980. So, using
the vanilla 2.6.37 should provide you audio, video and remote controller on this device.

Cheers,
Mauro

> Thank you for the reply,
> Pasquale
> 
> 
> 
> On Sat, Jan 15, 2011 at 9:58 AM, Mauro Carvalho Chehab <mchehab@redhat.com <mailto:mchehab@redhat.com>> wrote:
> 
>     Em 15-01-2011 03:03, Pasquale escreveu:
>     > Hello I am running the following OS "Ubuntu 10.04.1 LTS"
>     > with Mythtv I have a WinTv HVR-980 and hvae no sound with
>     > video see errors below any assistance would be appreciated.
>     >
>     > I should have a /dev/dsp1 but I can not find it?
>     >
>     >
>     > [   28.349674] em28xx #0: Config register raw data: 0xd0
>     > [   28.350444] em28xx #0: AC97 vendor ID = 0xffffffff
>     > [   28.350819] em28xx #0: AC97 features = 0x6a90
>     > [   28.350822] em28xx #0: Empia 202 AC97 audio processor detected
>     > [   28.588908] em28xx #0: v4l2 driver version 0.1.2
>     > [   28.676311] em28xx #0: V4L2 video device registered as /dev/video0
>     > [   28.676315] em28xx #0: V4L2 VBI device registered as /dev/vbi0
>     > [   28.692112] usbcore: registered new interface driver em28xx
>     > [   28.692117] em28xx driver loaded
>     > [   28.706196] em28xx_alsa: disagrees about version of symbol snd_pcm_new
>     > [   28.706201] em28xx_alsa: Unknown symbol snd_pcm_new
>     > [   28.706319] em28xx_alsa: disagrees about version of symbol snd_card_register
>     > [   28.706322] em28xx_alsa: Unknown symbol snd_card_register
>     > [   28.706438] em28xx_alsa: disagrees about version of symbol snd_card_free
>     > [   28.706440] em28xx_alsa: Unknown symbol snd_card_free
>     > [   28.706673] em28xx_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
>     > [   28.706675] em28xx_alsa: Unknown symbol snd_pcm_lib_ioctl
>     > [   28.706988] em28xx_alsa: disagrees about version of symbol snd_pcm_set_ops
>     > [   28.706990] em28xx_alsa: Unknown symbol snd_pcm_set_ops
>     > [   28.707209] em28xx_alsa: disagrees about version of symbol
>     > snd_pcm_hw_constraint_integer
>     > [   28.707212] em28xx_alsa: Unknown symbol snd_pcm_hw_constraint_integer
>     > [   28.707657] em28xx_alsa: disagrees about version of symbol snd_card_create
>     > [   28.707660] em28xx_alsa: Unknown symbol snd_card_create
>     > [   28.707766] em28xx_alsa: disagrees about version of symbol
>     > snd_pcm_period_elapsed
>     > [   28.707768] em28xx_alsa: Unknown symbol snd_pcm_period_elapsed
>     > [   28.910841] em28xx #0/2: xc3028 attached
>     > [   28.910844] DVB: registering new adapter (em28xx #0)
>     > [   28.911226] Successfully loaded em28xx-dvb
> 
>     Or you have two em28xx drivers or you compiled em28xx_alsa against a different
>     header than the ones used to compile the alsa modules on your distro.
> 
>     It is reported that (some versions) Ubuntu ships the wrong alsa headers
>     with their kernel header package.
> 
>     Cheers,
>     Mauro
> 
> 

