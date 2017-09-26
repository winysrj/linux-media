Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:57104 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966841AbdIZWAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 18:00:23 -0400
Received: by mail-pg0-f41.google.com with SMTP id 7so6634641pgd.13
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 15:00:23 -0700 (PDT)
MIME-Version: 1.0
From: Biff Eros <bifferos@gmail.com>
Date: Tue, 26 Sep 2017 23:00:22 +0100
Message-ID: <CAOcM_bkDv7BJhAHdf26f6u=YVqt8qdXgwq1inPpZvacAguXr-A@mail.gmail.com>
Subject: BUG: Hauppauge USB Live2 audio issues
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I get some errors loading the driver (modprobe cx231xx):

[ 8177.651308] cx231xx 2-3:1.1: New device Hauppauge Hauppauge Device
@ 480 Mbps (2040:c200) with 6 interfaces
[ 8177.651416] cx231xx 2-3:1.1: can't change interface 3 alt no. to 3:
Max. Pkt size = 0
[ 8177.651418] cx231xx 2-3:1.1: Identified as Hauppauge USB Live 2 (card=9)
[ 8177.652390] i2c i2c-10: Added multiplexed i2c bus 12
[ 8177.652525] i2c i2c-10: Added multiplexed i2c bus 13
[ 8177.737412] cx25840 9-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
[ 8179.800209] cx25840 9-0044: loaded v4l-cx231xx-avcore-01.fw
firmware (16382 bytes)
[ 8179.834337] cx231xx 2-3:1.1: v4l2 driver version 0.0.3
[ 8179.925757] cx231xx 2-3:1.1: Registered video device video0 [v4l2]
[ 8179.925974] cx231xx 2-3:1.1: Registered VBI device vbi0
[ 8179.925986] cx231xx 2-3:1.1: video EndPoint Addr 0x84, Alternate settings: 5
[ 8179.925991] cx231xx 2-3:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
[ 8179.925994] cx231xx 2-3:1.1: sliced CC EndPoint Addr 0x86,
Alternate settings: 2
[ 8179.926036] usbcore: registered new interface driver cx231xx
[ 8179.935145] cx231xx 2-3:1.1: audio EndPoint Addr 0x83, Alternate settings: 3
[ 8179.935147] cx231xx 2-3:1.1: Cx231xx Audio Extension initialized
[ 8179.984924] cx231xx 2-3:1.1: cx231xx_send_usb_command: failed with
status --32
[ 8180.031215] cx231xx 2-3:1.1: cx231xx_send_usb_command: failed with
status --22
[ 8180.037242] cx231xx 2-3:1.1: cx231xx_send_usb_command: failed with
status --22
[ 8180.196931] cx231xx 2-3:1.1: cx231xx_send_usb_command: failed with
status --22
[ 8180.197304] cx231xx 2-3:1.1: cx231xx_send_usb_command: failed with
status --22

I also get non-working sound some of the time, however video capture
with ffmpeg works quite well.  I have been testing using the following
capture command:

ffmpeg -thread_queue_size 512 -f alsa -i hw:2,0 -thread_queue_size 512 \
        -f v4l2 -standard pal -i /dev/video0 -codec:v huffyuv -aspect 4:3  \
        -codec:a pcm_s16le out.mkv

I've tried with 4.4.14, 4.9.45, 4.9.50.
Also tried: 4.13.0-rc4 (with linuxtv/master a couple of days ago).
They all do the same thing.

thanks,
Mark.
