Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:28389 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3EIPEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:04:05 -0400
Message-ID: <518BBAE4.4010507@libertysurf.fr>
Date: Thu, 09 May 2013 17:04:04 +0200
From: pierre <pdurand13@libertysurf.fr>
Reply-To: pdurand13@libertysurf.fr
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HD-Audio Generic HDMI/DP on wheezy
References: <20130509144422.420FC8FF9BB@zimbra65-e11.priv.proxad.net>
In-Reply-To: <20130509144422.420FC8FF9BB@zimbra65-e11.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Some difficult on wheezy, on my computer
product: Inspiron 620
vendor: Dell Inc.
version: 00
serial: D9V135J
width: 64 bits

My sound card is now defined as Caicos HDMI Audio [Radeon HD 6400 
Series] Digital Stereo (HDMI) on Squeeze, it was HD-Audio Generic 
Digital Stereo (HDMI).
It works but i'm not able to get analogic output, only HDMI / display 
port that i can't use.

extract of kern.log:
May  9 14:46:53 retraite kernel: [    6.852532] snd_hda_intel 
0000:01:00.1: irq 45 for MSI/MSI-X
May  9 14:46:53 retraite kernel: [    6.852560] snd_hda_intel 
0000:01:00.1: setting latency timer to 64
May  9 14:46:53 retraite kernel: [    6.885811] HDMI status: Codec=0 
Pin=3 Presence_Detect=0 ELD_Valid=0
May  9 14:46:53 retraite kernel: [    6.885931] input: HD-Audio Generic 
HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input6
May  9 14:46:53 retraite kernel: [    8.968035] WARNING: You are using 
an experimental version of the media stack.
May  9 14:46:53 retraite kernel: [    8.968037]     As the driver is 
backported to an older kernel, it doesn't offer
May  9 14:46:53 retraite kernel: [    8.968039]     enough quality for 
its usage in production.
May  9 14:46:53 retraite kernel: [    8.968040]     Use it with care.
May  9 14:46:53 retraite kernel: [    8.968041] Latest git patches 
(needed if you report a bug to linux-media@vger.kernel.org):
May  9 14:46:53 retraite kernel: [    8.968042]     
02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less 
verbose
May  9 14:46:53 retraite kernel: [    8.968044]     
a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at 
em28xx_dvb_bus_ctrl()
May  9 14:46:53 retraite kernel: [    8.968046]     
4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix 
indentation of the help section in Kconfig
May  9 14:46:53 retraite kernel: [    8.985632] WARNING: You are using 
an experimental version of the media stack.
May  9 14:46:53 retraite kernel: [    8.985634]     As the driver is 
backported to an older kernel, it doesn't offer
May  9 14:46:53 retraite kernel: [    8.985635]     enough quality for 
its usage in production.
May  9 14:46:53 retraite kernel: [    8.985636]     Use it with care.
May  9 14:46:53 retraite kernel: [    8.985636] Latest git patches 
(needed if you report a bug to linux-media@vger.kernel.org):
May  9 14:46:53 retraite kernel: [    8.985637]     
02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less 
verbose
May  9 14:46:53 retraite kernel: [    8.985639]     
a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at 
em28xx_dvb_bus_ctrl()
May  9 14:46:53 retraite kernel: [    8.985640]     
4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix 
indentation of the help section in Kconfig

Hoping theese informations can help you ... and me.

Thanks.

Pierre.

