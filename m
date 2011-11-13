Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1KMWqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 17:46:04 -0500
Received: by bke11 with SMTP id 11so5260123bke.19
        for <linux-media@vger.kernel.org>; Sun, 13 Nov 2011 14:46:02 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Sun, 13 Nov 2011 16:46:02 -0600
Message-ID: <CABcw_Ok7W2EHkCwBDm=Zz7kzYWJQA6+mx7QvL9=teAif9M2sVQ@mail.gmail.com>
Subject: mt9p031 on 3.0.8 kernel problems
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm continuing my journey of adding mt9p031 (LI-5M03 board) into 3.0.7
kernel built using oe-core for a beagleboard-xm.

I'm down to starting yavta, but getting the error "Unable to start
streaming: 32."

The mt9p031 is detected correctly at boot.

Here are my setup commands:
media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -v -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F `media-ctl -e
"OMAP3 ISP CCDC output"`

After setup, my media-ctl output looks like:

root@beagleboard:~# media-ctl -p
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev0
        pad0: Input [SGRBG10 4096x4096]
                <- 'OMAP3 ISP CCP2 input':pad0 []
        pad1: Output [SGRBG10 4096x4096]
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video0
        pad0: Output
                -> 'OMAP3 ISP CCP2':pad0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev1
        pad0: Input [SGRBG10 4096x4096]
        pad1: Output [SGRBG10 4096x4096]
                -> 'OMAP3 ISP CSI2a output':pad0 []
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video1
        pad0: Input
                <- 'OMAP3 ISP CSI2a':pad1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev2
        pad0: Input [SGRBG8 320x240]
                <- 'OMAP3 ISP CCP2':pad1 []
                <- 'OMAP3 ISP CSI2a':pad1 []
                <- 'mt9p031 2-0048':pad0 [ACTIVE]
        pad1: Output [SGRBG8 320x240]
                -> 'OMAP3 ISP CCDC output':pad0 [ACTIVE]
                -> 'OMAP3 ISP resizer':pad0 []
        pad2: Output [SGRBG8 320x239]
                -> 'OMAP3 ISP preview':pad0 []
                -> 'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video2
        pad0: Input
                <- 'OMAP3 ISP CCDC':pad1 [ACTIVE]

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev3
        pad0: Input [SGRBG10 4096x4096]
                <- 'OMAP3 ISP CCDC':pad2 []
                <- 'OMAP3 ISP preview input':pad0 []
        pad1: Output [YUYV 4082x4088]
                -> 'OMAP3 ISP preview output':pad0 []
                -> 'OMAP3 ISP resizer':pad0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video3
        pad0: Output
                -> 'OMAP3 ISP preview':pad0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video4
        pad0: Input
                <- 'OMAP3 ISP preview':pad1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev4
        pad0: Input [YUYV 4095x4095 (4,6)/4086x4082]
                <- 'OMAP3 ISP CCDC':pad1 []
                <- 'OMAP3 ISP preview':pad1 []
                <- 'OMAP3 ISP resizer input':pad0 []
        pad1: Output [YUYV 4096x4095]
                -> 'OMAP3 ISP resizer output':pad0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video5
        pad0: Output
                -> 'OMAP3 ISP resizer':pad0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
        pad0: Input
                <- 'OMAP3 ISP resizer':pad1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev5
        pad0: Input
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev6
        pad0: Input
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev7
        pad0: Input
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 16: mt9p031 2-0048 (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev8
        pad0: Output [SGRBG12 370x243 (16,54)/2592x1944]
                -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]


I see 21.6mhz on clka.
I see that /OE is low, and /RESET is high.
I don't see anything on PCLK, or the data lines D0 to D11, which confuses me.

Output from yavta is here: http://pastebin.com/q0mB4ArN

Does this sound like a hardware or software issue?

thanks,
chris
