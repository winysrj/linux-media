Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41380 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2GDS4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 14:56:05 -0400
Received: by vbbff1 with SMTP id ff1so5035055vbb.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 11:56:04 -0700 (PDT)
MIME-Version: 1.0
From: pierigno <pierigno@gmail.com>
Date: Wed, 4 Jul 2012 20:55:23 +0200
Message-ID: <CAN7fRVviA=svPsrHUkXj7B_ZZO02XMAOFyXQz0Sa-DiWvjg1cQ@mail.gmail.com>
Subject: AF9035 Twinstar has firmware errors
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello,

I've downloaded and compiled against karnel 3.0.0 and kernel 3.4.3 the
latest git tree from antii, branch dvb-usb-pull, and it doesn't
recognize my dual tuner Avermedia Twinstar (af9035 + mxl5007t)
anymore. Here's the logs from dmesg (the compiled modules do not have
any debug parameters to enable):

[44919.461121] WARNING: You are using an experimental version of the
media stack.
[44919.461125]  As the driver is backported to an older kernel, it doesn't offer
[44919.461129]  enough quality for its usage in production.
[44919.461131]  Use it with care.
[44919.461133] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[44919.461136]  635b1d05b4a2c62ebb76a1514e806faa133abc1f dvb_usb_v2:
remove usb_clear_halt() from stream
[44919.461139]  fc86b47f681e0c052cc6e71a4fd55f405fbe6d51 dvb_usb_v2:
do not try to remove non-existent adapter
[44919.461143]  6b86e957b62381c65f1edc068a4b2483ff9536df dvb_usb_v2:
use dev_* logging macros
[44919.465073] WARNING: You are using an experimental version of the
media stack.
[44919.465077]  As the driver is backported to an older kernel, it doesn't offer
[44919.465080]  enough quality for its usage in production.
[44919.465082]  Use it with care.
[44919.465084] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[44919.465087]  635b1d05b4a2c62ebb76a1514e806faa133abc1f dvb_usb_v2:
remove usb_clear_halt() from stream
[44919.465090]  fc86b47f681e0c052cc6e71a4fd55f405fbe6d51 dvb_usb_v2:
do not try to remove non-existent adapter
[44919.465094]  6b86e957b62381c65f1edc068a4b2483ff9536df dvb_usb_v2:
use dev_* logging macros
[44919.467147] usbcore: registered new interface driver dvb_usb_af9035
[44919.467487] usb 2-1.2: dvb_usbv2: found a 'AVerMedia Twinstar
(A825)' in cold state
[44919.507679] usb 2-1.2: dvb_usbv2: downloading firmware from file
'dvb-usb-af9035-02.fw'
[44919.817562] dvb_usb_af9035: firmware version=11.5.9.0
[44919.817613] usb 2-1.2: dvb_usbv2: found a 'AVerMedia Twinstar
(A825)' in warm state
[44919.820841] usb 2-1.2: dvb_usbv2: will pass the complete MPEG2
transport stream to the software demuxer
[44919.820892] DVB: registering new adapter (AVerMedia Twinstar (A825))
[44919.826864] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
[44919.826875] DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
[44920.166089] mxl5007t 16-0060: creating new instance
[44920.166883] mxl5007t_get_chip_id: unknown rev (3f)
[44920.166891] mxl5007t_get_chip_id: MxL5007T detected @ 16-0060
[44920.178890] usb 2-1.2: dvb_usbv2: 'AVerMedia Twinstar (A825)' error
while loading driver (-22)
[44920.179065] mxl5007t 16-0060: destroying instance
[44920.179599] usb 2-1.2: dvb_usbv2: 'AVerMedia Twinstar (A825)'
successfully deinitialized and disconnected
[45352.006027] usb 2-1.2: USB disconnect, device number 6
[45370.454070] usbcore: deregistering interface driver dvb_usb_af9035

How can I enable debug parameters in order to provide better
informations? I've compiled as usual using the following command
sequence:

git clone git://linuxtv.org/media_build.git
cd media_build
./build --git git://linuxtv.org/anttip/media_tree.git dvb_usb_pull
