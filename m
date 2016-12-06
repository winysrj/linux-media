Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33560 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752589AbcLFIuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 03:50:00 -0500
Received: by mail-lf0-f41.google.com with SMTP id c13so240113745lfg.0
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 00:49:59 -0800 (PST)
MIME-Version: 1.0
From: Konrad Kostecki <konrad.kostecki@gmail.com>
Date: Tue, 6 Dec 2016 09:49:38 +0100
Message-ID: <CALPXi_Tyoz7Y9xMuROc-5Whi_x-M60XZ_Pkpx3wBQpGmZn=dgA@mail.gmail.com>
Subject: DVB CAM did not respond / DVBSky S960CI + SmarCAM-3 CI Plus
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody!

This is my very first message here, so first of all, thank you all for
your participation in this project. I really do appreciate it!

Still I'm looking for some advice.. I bought DVBsky S960CI (DVB-S2),
managed to install drivers, VDR, plugins etc on my Linux systems and I
can view only not encrypted content, but when it comes to encrypted
(and this is my main use) here comes trouble.

It seems that CAM is not responding for some reason..

Kernel: 3.16.36-1+deb8u2~bpo70+1 (2016-10-19) x86_64 GNU/Linux
Drivers used from DVBsky website: media_build-bst-14-141106

CAM module seems to be:
SmarCAM-3 CI Plus / smardtv
software version: 09.00.01.01.03.00
hardware version: 01000102
cpu: CAP100 (200mhz)
memory: 4 MB Flash/ 8 MB RAM
Nagra system
bandwidth: up to 200 Mb/s

Everything (including encoded channels) works fine on Windows with
20151117 DVBsky driver and 151027 version of DVBsky Player.

Could you please advise how can I troubleshoot this issue? Thank you in advance!

And here is what DMESG states:
[ 3694.896376] usb 1-1.3: dvb_usb_v2: found a 'DVBSky S960CI' in warm state
[ 3694.896491] usb 1-1.3: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[ 3694.896521] DVB: registering new adapter (DVBSky S960CI)
[ 3694.898050] dvbsky_usb MAC address=00:18:42:54:96:0c
[ 3694.898065] usb 1-1.3: dvb_usb_v2: MAC address: 00:18:42:54:96:0c
[ 3694.900319] DS3000 chip version: d0 attached.
[ 3694.901664] TS202x chip version[1]: c1 attached.
[ 3694.913840] TS202x chip version[2]: c3 attached.
[ 3694.969092] m88ds3103_load_firmware: Waiting for firmware upload
(dvb-fe-ds3103.fw)...
[ 3694.969164] usb 1-1.3: firmware: direct-loading firmware dvb-fe-ds3103.fw
[ 3694.969173] m88ds3103_load_firmware: Waiting for firmware upload(2)...
[ 3696.034348] usb 1-1.3: DVB: registering adapter 0 frontend 0
(Montage DS3103/TS2022)...
[ 3696.041934] Registered IR keymap rc-dvbsky
[ 3696.042165] input: DVBSky S960CI as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.3/rc/rc0/input11
[ 3696.042683] rc0: DVBSky S960CI as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.3/rc/rc0
[ 3696.042694] usb 1-1.3: dvb_usb_v2: schedule remote query interval
to 300 msecs
[ 3696.042702] usb 1-1.3: dvb_usb_v2: 'DVBSky S960CI' successfully
initialized and connected
[ 3757.382943] dvb_ca adapter 0: DVB CAM did not respond :(

Any suggestions much appreciated.

Kind regards,
Konrad
