Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39638 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZLWQlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 11:41:37 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NNUH7-0002IK-IK
	for linux-media@vger.kernel.org; Wed, 23 Dec 2009 17:41:25 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 17:41:25 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 17:41:25 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Wed, 23 Dec 2009 17:41:03 +0100
Message-ID: <1261586462.8948.23.camel@slash.doma>
References: <4B1D6194.4090308@freenet.de>
	 <1261578615.8948.4.camel@slash.doma>  <200912231753.28988.liplianin@me.by>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200912231753.28988.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On sre, 2009-12-23 at 17:53 +0200, Igor M. Liplianin wrote:
> Since module ir-common.ko moved to IR directory just remove old one.
> 
> 	rm /lib/modules/$(uname -r)/kernel/drivers/media/common/ir-common.ko
> 
> Also it would be good to do
> 
> 	make remove
> 
> Then again build and install drivers.
> 

Ok. There was no common folder in the above path. Anyway, I did rm and
make remove and did a new build (2.6.33-rc1). First, there were
warnings:
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/saa7134.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/saa7134.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/mantis.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/ir-kbd-i2c.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/ir-kbd-i2c.ko] undefined!
WARNING:
"ir_core_debug" [/mnt/storage/temp/technisat/s2-liplianin/v4l/ir-common.ko] undefined!
WARNING:
"ir_g_keycode_from_table" [/mnt/storage/temp/technisat/s2-liplianin/v4l/ir-common.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/em28xx.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/em28xx.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/cx88xx.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/cx88xx.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/cx23885.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/cx23885.ko] undefined!
WARNING:
"ir_input_register" [/mnt/storage/temp/technisat/s2-liplianin/v4l/bttv.ko] undefined!
WARNING:
"ir_input_unregister" [/mnt/storage/temp/technisat/s2-liplianin/v4l/bttv.ko] undefined!

Then I restarted the machine and this is in the kernel log:
ir_common: Unknown symbol ir_g_keycode_from_table
ir_common: Unknown symbol ir_core_debug
+ no mantis module loaded.

I have the IR folder under lib/modules where ir-common.ko resides. In
the common folder there is no file ir-common.ko.

If I do manual loading, I get:
sudo modprobe mantis
WARNING: Error inserting mb86a16
(/lib/modules/2.6.33-rc1/kernel/drivers/media/dvb/frontends/mb86a16.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting mantis
(/lib/modules/2.6.33-rc1/kernel/drivers/media/dvb/mantis/mantis.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg says:
[  289.939402] ir_common: Unknown symbol ir_g_keycode_from_table
[  289.939690] ir_common: Unknown symbol ir_core_debug


This is the s2-liplianin tree.

If using the http://jusst.de/hg/v4l-dvb tree, everything compiles ok,
module loads, but there is no remote anywhere (there is an IR folder
with the ir-common.ko file, under common there is not).


Aljaz



