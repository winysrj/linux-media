Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60891 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab1JRO21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 10:28:27 -0400
Received: by yxp4 with SMTP id 4so634506yxp.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 07:28:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9D882F.5010608@mlbassoc.com>
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
	<4E9D882F.5010608@mlbassoc.com>
Date: Tue, 18 Oct 2011 17:28:25 +0300
Message-ID: <CAFYgh7wKeOmQnvpbugZcFX-shKRN7oGmho_tyYLtcVOnPL8Peg@mail.gmail.com>
Subject: Re: omap3isp: BT.656 support
From: Boris Todorov <boris.st.todorov@gmail.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using different board.

According "media-ctl -p":

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev2
        pad0: Input [UYVY2X8 720x525]
                <- 'OMAP3 ISP CCP2':pad1 []
                <- 'OMAP3 ISP CSI2a':pad1 []
                <- 'tvp5150 3-005c':pad0 [ACTIVE]
        pad1: Output [UYVY2X8 720x525]
                -> 'OMAP3 ISP CCDC output':pad0 [ACTIVE]
                -> 'OMAP3 ISP resizer':pad0 []
        pad2: Output [UYVY2X8 720x524]
                -> 'OMAP3 ISP preview':pad0 []
                -> 'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video4
        pad0: Input
                <- 'OMAP3 ISP CCDC':pad1 [ACTIVE]


Should be /dev/video4...


On Tue, Oct 18, 2011 at 5:07 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-10-18 07:33, Boris Todorov wrote:
>>
>> Hi
>>
>> I'm trying to run OMAP + TVP5151 in BT656 mode.
>>
>> I'm using omap3isp-omap3isp-yuv (git.linuxtv.org/pinchartl/media.git).
>> Plus the following patches:
>>
>> TVP5151:
>>
>> https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150
>>
>> The latest RFC patches for BT656 support:
>>
>> Enrico Butera (2):
>>   omap3isp: ispvideo: export isp_video_mbus_to_pix
>>   omap3isp: ispccdc: configure CCDC registers and add BT656 support
>>
>> Javier Martinez Canillas (1):
>>   omap3isp: ccdc: Add interlaced field mode to platform data
>>
>>
>> I'm able to configure with media-ctl:
>>
>> media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
>> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
>> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
>> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'
>>
>> But
>> ./yavta -f UYVY -s 720x525 -n 4 --capture=4 -F /dev/video4
>>
>> sleeps after
>> ...
>> Buffer 1 mapped at address 0x4021d000.
>> length: 756000 offset: 1515520
>> Buffer 2 mapped at address 0x402d6000.
>> length: 756000 offset: 2273280
>> Buffer 3 mapped at address 0x4038f000.
>>
>> Anyone with the same issue??? This happens with every other v4l test app I
>> used.
>> I can see data from TVP5151 but there are no interrupts in ISP.
>
> Why are you using /dev/video4?  The CCDC output is on /dev/video2
>
> --
> ------------------------------------------------------------
> Gary Thomas                 |  Consulting for the
> MLB Associates              |    Embedded world
> ------------------------------------------------------------
>
