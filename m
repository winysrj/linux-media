Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:45996 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab1AOFKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 00:10:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PdyOq-0008Tf-G0
	for linux-media@vger.kernel.org; Sat, 15 Jan 2011 06:10:04 +0100
Received: from 66-78-111-42.access.ripnet.com ([66.78.111.42])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 06:10:04 +0100
Received: from puskyer by 66-78-111-42.access.ripnet.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 06:10:04 +0100
To: linux-media@vger.kernel.org
From: Pasquale <puskyer@gmail.com>
Subject: no sound with WinTV HVR-980 - Help
Date: Sat, 15 Jan 2011 05:03:47 +0000 (UTC)
Message-ID: <loom.20110115T060015-825@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello I am running the following OS "Ubuntu 10.04.1 LTS" 
with Mythtv I have a WinTv HVR-980 and hvae no sound with 
video see errors below any assistance would be appreciated.

I should have a /dev/dsp1 but I can not find it?


[   28.349674] em28xx #0: Config register raw data: 0xd0
[   28.350444] em28xx #0: AC97 vendor ID = 0xffffffff
[   28.350819] em28xx #0: AC97 features = 0x6a90
[   28.350822] em28xx #0: Empia 202 AC97 audio processor detected
[   28.588908] em28xx #0: v4l2 driver version 0.1.2
[   28.676311] em28xx #0: V4L2 video device registered as /dev/video0
[   28.676315] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[   28.692112] usbcore: registered new interface driver em28xx
[   28.692117] em28xx driver loaded
[   28.706196] em28xx_alsa: disagrees about version of symbol snd_pcm_new
[   28.706201] em28xx_alsa: Unknown symbol snd_pcm_new
[   28.706319] em28xx_alsa: disagrees about version of symbol snd_card_register
[   28.706322] em28xx_alsa: Unknown symbol snd_card_register
[   28.706438] em28xx_alsa: disagrees about version of symbol snd_card_free
[   28.706440] em28xx_alsa: Unknown symbol snd_card_free
[   28.706673] em28xx_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
[   28.706675] em28xx_alsa: Unknown symbol snd_pcm_lib_ioctl
[   28.706988] em28xx_alsa: disagrees about version of symbol snd_pcm_set_ops
[   28.706990] em28xx_alsa: Unknown symbol snd_pcm_set_ops
[   28.707209] em28xx_alsa: disagrees about version of symbol
snd_pcm_hw_constraint_integer
[   28.707212] em28xx_alsa: Unknown symbol snd_pcm_hw_constraint_integer
[   28.707657] em28xx_alsa: disagrees about version of symbol snd_card_create
[   28.707660] em28xx_alsa: Unknown symbol snd_card_create
[   28.707766] em28xx_alsa: disagrees about version of symbol
snd_pcm_period_elapsed
[   28.707768] em28xx_alsa: Unknown symbol snd_pcm_period_elapsed
[   28.910841] em28xx #0/2: xc3028 attached
[   28.910844] DVB: registering new adapter (em28xx #0)
[   28.911226] Successfully loaded em28xx-dvb

