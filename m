Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51391 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdJ1HqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 03:46:17 -0400
From: Alois Fertl <alois.fertl@web.de>
To: linux-media@vger.kernel.org
Cc: Alois Fertl <alois.fertl@web.de>
Subject: Re: [PATCH 0/3] support for Logilink VG0022a DVB-T2 stick
Date: Sat, 28 Oct 2017 09:46:04 +0200
Message-Id: <20171028074604.2444-1-alois.fertl@web.de>
In-Reply-To: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

I'm responding to this thread because I have a Terretec CINERGY TC2 Stick, similar
chips, it9303/si2147/si2168, which shows the same problem.
Connecting a scope to the physical i2c bus between 2147 and 2168 gave some
suprising results.
With probe connected to the sda line, the i2c communication starts working reliable,
after disconnecting it failed again. Going further into it indicates that the
communication works up to the point where the loaded si2168 firmware starts executing,
guess this is after sending the \x01\x01 as already found by Andreas.
So probably the firmware configures something in the si2168 that makes
i2c bus weak? firmware issue? Even more I could imagine that some of these USB sticks
do work and others not.

I managed to fix the i2c bus by physically changing the pull-up on the sda line from 4k7
to 10k. So I have a working stick to test what patches are needed.

No changes to current si2157.c and si2148.c sources are necessary in this configuration.

The only reqired changes are in af9035.c:
1st Add the Terratec to the IT903x device table.
2nd Put the it930x initialization stuff, baud rate, port etc. from it930x_tuner_attach
 also into it930x_frontend_attach. Actually it seems sufficient to have it only in
 frontend_attach.

With this I see the following and the device works fine with tvheadend:

[ 3728.290172] WARNING: You are using an experimental version of the media stack.
               	As the driver is backported to an older kernel, it doesn't offer
               	enough quality for its usage in production.
               	Use it with care.
               Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
               	61065fc3e32002ba48aa6bc3816c1f6f9f8daf55 Merge commit '3728e6a255b5' into patchwork
               	3728e6a255b50382591ee374c70e6f5276a47d0a Merge tag 'media/v4.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
               	7571358dd22dc91dea560f0dde62ce23c033b6b6 media: dt: bindings: media: Document data lane numbering without lane reordering
[ 3728.319709] usbcore: registered new interface driver dvb_usb_af9035
[ 3808.368015] usb 7-6: new high-speed USB device number 2 using ehci-pci
[ 3808.519989] usb 7-6: New USB device found, idVendor=0ccd, idProduct=10b2
[ 3808.519992] usb 7-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 3808.519995] usb 7-6: Product: TS Aggregator
[ 3808.519997] usb 7-6: Manufacturer: CINERGY TC2 Stick
[ 3808.522239] dvb_usb_af9035 7-6:1.0: prechip_version=83 chip_version=01 chip_type=9306
[ 3808.522612] usb 7-6: dvb_usb_v2: found a 'TerraTec Cinergy TC2 Stick' in cold state
[ 3808.603993] usb 7-6: firmware: direct-loading firmware dvb-usb-it9303-01.fw
[ 3808.603999] usb 7-6: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9303-01.fw'
[ 3808.644619] dvb_usb_af9035 7-6:1.0: firmware version=1.4.0.0
[ 3808.644631] usb 7-6: dvb_usb_v2: found a 'TerraTec Cinergy TC2 Stick' in warm state
[ 3808.644701] usb 7-6: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[ 3808.644738] dvbdev: DVB: registering new adapter (TerraTec Cinergy TC2 Stick)
[ 3808.862180] i2c i2c-3: Added multiplexed i2c bus 4
[ 3808.862183] si2168 3-0067: Silicon Labs Si2168-B40 successfully identified
[ 3808.862186] si2168 3-0067: firmware version: B 4.0.2
[ 3808.862194] usb 7-6: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[ 3808.865004] si2157 4-0063: Silicon Labs Si2147/2148/2157/2158 successfully attached
[ 3808.885630] usb 7-6: dvb_usb_v2: 'TerraTec Cinergy TC2 Stick' successfully initialized and connected
[ 3818.832270] si2168 3-0067: firmware: direct-loading firmware dvb-demod-si2168-b40-01.fw
[ 3818.832273] si2168 3-0067: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[ 3819.397099] si2168 3-0067: firmware version: B 4.0.11
[ 3819.409474] si2157 4-0063: found a 'Silicon Labs Si2147-A30'
[ 3819.462976] si2157 4-0063: firmware version: 3.0.5
[ 3819.462997] usb 7-6: DVB: adapter 0 frontend 0 frequency 0 out of range (42000000..870000000)

Regards,
Alois
