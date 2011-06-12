Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41491 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1FLIX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 04:23:29 -0400
Received: by qwk3 with SMTP id 3so1823589qwk.19
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2011 01:23:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Jun 2011 10:23:28 +0200
Message-ID: <BANLkTimkYw70GAu1keW-N6ND=AyiRn2+CA@mail.gmail.com>
Subject: PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C) - DVB-C channel
 scan in mythtv - missing
From: Rune Evjen <rune.evjen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I just tested a PCTV 290e device using the latest media_build drivers
in MythTV as a DVB-C device, and ran into some problems.

The adapter is recognized by the em28xx-dvb driver [1] and dmesg
output seems to be correct [2]. I can successfully scan for channels
using the scan utility in dvb-apps but when I try to scan for channels
in mythtv I get the following errors logged by mythtv-setup:

2011-06-12 00:57:20.971556  PIDInfo(/dev/dvb/adapter0/
frontend1): Failed to open demux device /dev/dvb/adapter0/demux1 for
filter on pid 0x0

The demux1 does not exist, I only have the following nodes under
/dev/dvb/adapter0:

demux0  dvr0  frontend0  frontend1  net0

When searching the linx-media I came across this thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg31839.html

Is there any way to circumvent with the current driver that there is
no corresponding demux1 for frontend1?
Or can the DVB-T/T2 part be disabled somehow so that there is only one
DVB-C frontend registered which corresponds to the demux0?

Best regards,

Rune

[1] modinfo:
modinfo em28xx-dvb
filename:
/lib/modules/2.6.38-8-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
license:        GPL
author:         Mauro Carvalho Chehab <mchehab@infradead.org>
description:    driver for em28xx based DVB cards
srcversion:     663F353AB97767017FDEC27
depends:        em28xx,dvb-core,cxd2820r
vermagic:       2.6.38-8-generic SMP mod_unload modversions 686
parm:           debug:enable debug messages [dvb] (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

[2] dmesg:
[   54.724067] usb 1-3: new high speed USB device using ehci_hcd and address 4
[   54.941327] WARNING: You are using an experimental version of the
media stack.
[   54.941332]     As the driver is backported to an older kernel, it
doesn't offer
[   54.941335]     enough quality for its usage in production.
[   54.941338]     Use it with care.
[   54.941339] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   54.941343]     75125b9d44456e0cf2d1fbb72ae33c
13415299d1 [media] DocBook: Don't be noisy at make cleanmediadocs
[   54.941346]     0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert
[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
[   54.941350]     4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media]
DocBook/video.xml: Document the remaining data structures
[   54.961881] IR NEC protocol handler initialized
[   54.987012] IR RC5(x) protocol handler initialized
[   55.008281] IR RC6 protocol handler initialized
[   55.032239] IR JVC protocol handler initialized
[   55.052312] IR Sony protocol handler initialized
[   55.092892] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[   55.093169] lirc_dev: IR Remote Control driver registered, major 250
[   55.100171] em28xx #0: chip ID is em28174
[   55.110254] IR LIRC bridge handler initialized
[   55.419763] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[   55.464076] Registered IR keymap rc-pinnacle-pctv-hd
[   55.472069] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0/input11
[   55.472505] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0
[   55.483777] em28xx #0: v4l2 driver version 0.1.2
[   55.493073] em28xx #0: V4L2 video device registered as video1
[   55.494836] usbcore: registered new interface driver em28xx
[   55.494844] em28xx driver loaded
[   55.552425] WARNING: You are using an experimental version of the
media stack.
[   55.552430]     As the driver is backported to an older kernel, it
doesn't offer
[   55.552434]     enough quality for its usage in production.
[   55.552436]     Use it with care.
[   55.552438] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   55.552441]     75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media]
DocBook: Don't be noisy at make cleanmediadocs
[   55.552445]     0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert
[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
[   55.552449]     4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media]
DocBook/video.xml: Document the remaining data structures
[   55.610886] tda18271 15-0060: creating new instance
[   55.613267] TDA18271HD/C2 detected @ 15-0060
[   55.845831] tda18271 15-0060: attaching existing instance
[   55.845842] DVB: registering new adapter (em28xx #0)
[   55.845850] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
(DVB-T/T2))...
[   55.846111] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
[   55.846891] em28xx #0: Successfully loaded em28xx-dvb
[   55.846899] Em28xx: Initialized (Em28xx dvb Extension) extension
