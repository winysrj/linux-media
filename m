Return-path: <mchehab@gaivota>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1EJK1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 06:27:07 -0400
Received: by iyb14 with SMTP id 14so5055497iyb.19
        for <linux-media@vger.kernel.org>; Tue, 10 May 2011 03:27:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105101153.04978.laurent.pinchart@ideasonboard.com>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
	<201105101132.11041.laurent.pinchart@ideasonboard.com>
	<BANLkTimLhOJstjpbxLSxS-qNPYhbfGxUNw@mail.gmail.com>
	<201105101153.04978.laurent.pinchart@ideasonboard.com>
Date: Tue, 10 May 2011 12:27:05 +0200
Message-ID: <BANLkTinrSz4nULGS729jEhs1O=wvUy19Jg@mail.gmail.com>
Subject: Re: Current status report of mt9p031.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 10 May 2011 11:53, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 10 May 2011 11:49:10 javier Martin wrote:
>> > Please try replacing the media-ctl -f line with
>> >
>> > ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], \
>> >        "OMAP3 ISP CCDC":0[SGRBG8 320x240], \
>> >        "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>> >
>> > --
>> > Regards,
>> >
>> > Laurent Pinchart
>>
>> Hi Laurent,
>> that didn't work either (Unable to start streaming: 32.)
>
> With the latest 2.6.39-rc ? Lane-shifter support has been introduced very
> recently.
>
> Can you post the output of media-ctl -p after configuring formats on your
> pipeline ?
>
> --
> Regards,
>
> Laurent Pinchart
>

Sure,
this is the output you requested:

root@beagleboard:~# ./media-ctl -p
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enume rating pads and links
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
        pad0: Output [SGRBG12 320x240 (0,0)/2240x1920]
                -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
