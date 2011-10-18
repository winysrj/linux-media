Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:54204 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1JRQYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 12:24:06 -0400
Message-ID: <4E9DA823.3080708@mlbassoc.com>
Date: Tue, 18 Oct 2011 10:24:03 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Boris Todorov <boris.st.todorov@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: omap3isp: BT.656 support
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com> <4E9D882F.5010608@mlbassoc.com> <CAFYgh7wKeOmQnvpbugZcFX-shKRN7oGmho_tyYLtcVOnPL8Peg@mail.gmail.com> <4E9D9209.3000907@mlbassoc.com> <CAFYgh7ybJYX0ec9avYrMf+cCWnp_AU3WivZkROCDLi-6p2WB_A@mail.gmail.com> <4E9D9A23.8060604@mlbassoc.com> <CAFYgh7x7LOw493Bvy3ETC9rq8DkDVnj5tL9mEZd4OF6RtNk8yA@mail.gmail.com> <4E9DA3A2.3050009@mlbassoc.com> <CAFYgh7zUwt=C9pyfepM6B0stHhnJs7U08JP_w8x_ycce2HKbZg@mail.gmail.com>
In-Reply-To: <CAFYgh7zUwt=C9pyfepM6B0stHhnJs7U08JP_w8x_ycce2HKbZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-18 10:14, Boris Todorov wrote:
> On Tue, Oct 18, 2011 at 7:04 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2011-10-18 09:53, Boris Todorov wrote:
>>>
>>> On Tue, Oct 18, 2011 at 6:24 PM, Gary Thomas<gary@mlbassoc.com>    wrote:
>>>>
>>>> On 2011-10-18 09:10, Boris Todorov wrote:
>>>>>
>>>>> On Tue, Oct 18, 2011 at 5:49 PM, Gary Thomas<gary@mlbassoc.com>
>>>>>   wrote:
>>>>>>
>>>>>> On 2011-10-18 08:28, Boris Todorov wrote:
>>>>>>>
>>>>>>> I'm using different board.
>>>>>>
>>>>>> What board?  I would think the architecture of the OMAP3 ISP would
>>>>>> not change, based on the board?
>>>>>
>>>>> It's a custom board with omap3630. ISP is not changed.
>>>>> When I disable OMAP2_VOUT from defconfig "CCD output" is /dev/video2.
>>>>
>>>> I see, I have that option turned off.
>>>>
>>>>> But result is the same - yavta sleeps at VIDIOC_DQBUF ioctl
>>>>
>>>> How are you configuring the TVP5150?  In particular these settings at
>>>> boot
>>>> time:
>>>>
>>>> static struct isp_v4l2_subdevs_group my_camera_subdevs[] = {
>>>>         {
>>>>                 .subdevs = tvp5150_camera_subdevs,
>>>>                 .interface = ISP_INTERFACE_PARALLEL,
>>>>                 .bus = {
>>>>                                 .parallel = {
>>>>                                         .data_lane_shift = 0,
>>>>                                         .clk_pol = 1,
>>>>                                         .bt656 = 1,
>>>>                                         .fldmode = 1,
>>>>                                 }
>>>>                 },
>>>>         },
>>>>         { },
>>>> };
>>>
>>> My settings are:
>>>                                 .data_lane_shift        = 0,
>>>                                 .clk_pol                = 0,
>>>                                 .hs_pol                 = 0,
>>>                                 .vs_pol                 = 0,
>>>                                 .fldmode                = 1,
>>>                                 .bt656               = 1,
>>>
>>> I tried yours but same result.
>>> Why did you chose clk_pol=1?
>>
>> I just copied the settings from the BeagleBoard
> btw what board are you using?

An internal project for the company I work with, OMAP 3530, much like the BeagleBoard

>
>> Have you had this working before (earlier kernel, etc)?
> Never in BT.656 mode...
>
>>
>>>
>>>>
>>>> This is how you tell the ISP to run in BT656 mode.  Without it, it will
>>>> run
>>>> using the HS/VS/FID signals (and also in my experience does not work
>>>> properly)
>>>>
>>>>>>
>>>>>>> According "media-ctl -p":
>>>>>>>
>>>>>>> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>>>>>>>              type V4L2 subdev subtype Unknown
>>>>>>>              device node name /dev/v4l-subdev2
>>>>>>>          pad0: Input [UYVY2X8 720x525]
>>>>>>>                  <- 'OMAP3 ISP CCP2':pad1 []
>>>>>>>                  <- 'OMAP3 ISP CSI2a':pad1 []
>>>>>>>                  <- 'tvp5150 3-005c':pad0 [ACTIVE]
>>>>>>>          pad1: Output [UYVY2X8 720x525]
>>>>>>>                  ->        'OMAP3 ISP CCDC output':pad0 [ACTIVE]
>>>>>>>                  ->        'OMAP3 ISP resizer':pad0 []
>>>>>>>          pad2: Output [UYVY2X8 720x524]
>>>>>>>                  ->        'OMAP3 ISP preview':pad0 []
>>>>>>>                  ->        'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
>>>>>>>                  ->        'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
>>>>>>>                  ->        'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]
>>>>>>>
>>>>>>> - entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
>>>>>>>              type Node subtype V4L
>>>>>>>              device node name /dev/video4
>>>>>>>          pad0: Input
>>>>>>>                  <- 'OMAP3 ISP CCDC':pad1 [ACTIVE]
>>>>>>>
>>>>>>>
>>>>>>> Should be /dev/video4...
>>>>>>
>>>>>> Could you send your pipeline setup and full output of 'media-ctl -p'?
>>>>>
>>>>> Pipeline setup is:
>>>>>
>>>>> $ media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1],
>>>>> "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>>>>> $ media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
>>>>> $ media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
>>>>> $ media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'
>>>>>
>>>>> media-ctl output (with /dev/video4):
>>>>>
>>>>> $ media-ctl -p
>>>>> Opening media device /dev/media0
>>>>> Enumerating entities
>>>>> Found 16 entities
>>>>> Enumerating pads and links
>>>>> Device topology
>>>>> - entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
>>>>>              type V4L2 subdev subtype Unknown
>>>>>              device node name /dev/v4l-subdev0
>>>>>          pad0: Input [SGRBG10 4096x4096]
>>>>>                  <- 'OMAP3 ISP CCP2 input':pad0 []
>>>>>          pad1: Output [SGRBG10 4096x4096]
>>>>>                  ->      'OMAP3 ISP CCDC':pad0 []
>>>>>
>>>>> - entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
>>>>>              type Node subtype V4L
>>>>>              device node name /dev/video0
>>>>>          pad0: Output
>>>>>                  ->      'OMAP3 ISP CCP2':pad0 []
>>>>>
>>>>> - entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
>>>>>              type V4L2 subdev subtype Unknown
>>>>>              device node name /dev/v4l-subdev1
>>>>>          pad0: Input [SGRBG10 4096x4096]
>>>>>          pad1: Output [SGRBG10 4096x4096]
>>>>>                  ->      'OMAP3 ISP CSI2a output':pad0 []
>>>>>                  ->      'OMAP3 ISP CCDC':pad0 []
>>>>>
>>>>> - entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
>>>>>              type Node subtype V4L
>>>>>              device node name /dev/video3
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP CSI2a':pad1 []
>>>>>
>>>>> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>>>>>              type V4L2 subdev subtype Unknown
>>>>>              device node name /dev/v4l-subdev2
>>>>>          pad0: Input [UYVY2X8 720x525]
>>>>>                  <- 'OMAP3 ISP CCP2':pad1 []
>>>>>                  <- 'OMAP3 ISP CSI2a':pad1 []
>>>>>                  <- 'tvp5150 3-005c':pad0 [ACTIVE]
>>>>>          pad1: Output [UYVY2X8 720x525]
>>>>>                  ->      'OMAP3 ISP CCDC output':pad0 [ACTIVE]
>>>>>                  ->      'OMAP3 ISP resizer':pad0 []
>>>>>          pad2: Output [UYVY2X8 720x524]
>>>>>                  ->      'OMAP3 ISP preview':pad0 []
>>>>>                  ->      'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
>>>>>                  ->      'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
>>>>>                  ->      'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]
>>>>>
>>>>> - entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
>>>>>              type Node subtype V4L
>>>>>              device node name /dev/video4
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP CCDC':pad1 [ACTIVE]
>>>>>
>>>>> - entity 7: OMAP3 ISP preview (2 pads, 4 links)
>>>>>              type V4L2 subdev subtype Unknown
>>>>>              device node name /dev/v4l-subdev3
>>>>>          pad0: Input [SGRBG10 4096x4096]
>>>>>                  <- 'OMAP3 ISP CCDC':pad2 []
>>>>>                  <- 'OMAP3 ISP preview input':pad0 []
>>>>>          pad1: Output [YUYV 4082x4088]
>>>>>                  ->      'OMAP3 ISP preview output':pad0 []
>>>>>                  ->      'OMAP3 ISP resizer':pad0 []
>>>>>
>>>>> - entity 8: OMAP3 ISP preview input (1 pad, 1 link)
>>>>>              type Node subtype V4L
>>>>>              device node name /dev/video5
>>>>>          pad0: Output
>>>>>                  ->      'OMAP3 ISP preview':pad0 []
>>>>>
>>>>> - entity 9: OMAP3 ISP preview output (1 pad, 1 link)
>>>>>              type Node subtype V4L
>>>>>              device node name /dev/video6
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP preview':pad1 []
>>>>>
>>>>> - entity 10: OMAP3 ISP resizer (2 pads, 4 links)
>>>>>               type V4L2 subdev subtype Unknown
>>>>>               device node name /dev/v4l-subdev4
>>>>>          pad0: Input [YUYV 4095x4095 (4,6)/4086x4082]
>>>>>                  <- 'OMAP3 ISP CCDC':pad1 []
>>>>>                  <- 'OMAP3 ISP preview':pad1 []
>>>>>                  <- 'OMAP3 ISP resizer input':pad0 []
>>>>>          pad1: Output [YUYV 4096x4095]
>>>>>                  ->      'OMAP3 ISP resizer output':pad0 []
>>>>>
>>>>> - entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
>>>>>               type Node subtype V4L
>>>>>               device node name /dev/video7
>>>>>          pad0: Output
>>>>>                  ->      'OMAP3 ISP resizer':pad0 []
>>>>>
>>>>> - entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
>>>>>               type Node subtype V4L
>>>>>               device node name /dev/video8
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP resizer':pad1 []
>>>>>
>>>>> - entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
>>>>>               type V4L2 subdev subtype Unknown
>>>>>               device node name /dev/v4l-subdev5
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]
>>>>>
>>>>> - entity 14: OMAP3 ISP AF (1 pad, 1 link)
>>>>>               type V4L2 subdev subtype Unknown
>>>>>               device node name /dev/v4l-subdev6
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]
>>>>>
>>>>> - entity 15: OMAP3 ISP histogram (1 pad, 1 link)
>>>>>               type V4L2 subdev subtype Unknown
>>>>>               device node name /dev/v4l-subdev7
>>>>>          pad0: Input
>>>>>                  <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]
>>>>>
>>>>> - entity 16: tvp5150 3-005c (1 pad, 1 link)
>>>>>               type V4L2 subdev subtype Unknown
>>>>>               device node name /dev/v4l-subdev8
>>>>>          pad0: Output [UYVY2X8 720x525]
>>>>>                  ->      'OMAP3 ISP CCDC':pad0 [ACTIVE]
>>>>>
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Tue, Oct 18, 2011 at 5:07 PM, Gary Thomas<gary@mlbassoc.com>
>>>>>>>   wrote:
>>>>>>>>
>>>>>>>> On 2011-10-18 07:33, Boris Todorov wrote:
>>>>>>>>>
>>>>>>>>> Hi
>>>>>>>>>
>>>>>>>>> I'm trying to run OMAP + TVP5151 in BT656 mode.
>>>>>>>>>
>>>>>>>>> I'm using omap3isp-omap3isp-yuv
>>>>>>>>> (git.linuxtv.org/pinchartl/media.git).
>>>>>>>>> Plus the following patches:
>>>>>>>>>
>>>>>>>>> TVP5151:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150
>>>>>>>>>
>>>>>>>>> The latest RFC patches for BT656 support:
>>>>>>>>>
>>>>>>>>> Enrico Butera (2):
>>>>>>>>>    omap3isp: ispvideo: export isp_video_mbus_to_pix
>>>>>>>>>    omap3isp: ispccdc: configure CCDC registers and add BT656 support
>>>>>>>>>
>>>>>>>>> Javier Martinez Canillas (1):
>>>>>>>>>    omap3isp: ccdc: Add interlaced field mode to platform data
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I'm able to configure with media-ctl:
>>>>>>>>>
>>>>>>>>> media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1],
>>>>>>>>> "OMAP3
>>>>>>>>> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>>>>>>>>> media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
>>>>>>>>> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
>>>>>>>>> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'
>>>>>>>>>
>>>>>>>>> But
>>>>>>>>> ./yavta -f UYVY -s 720x525 -n 4 --capture=4 -F /dev/video4
>>>>>>>>>
>>>>>>>>> sleeps after
>>>>>>>>> ...
>>>>>>>>> Buffer 1 mapped at address 0x4021d000.
>>>>>>>>> length: 756000 offset: 1515520
>>>>>>>>> Buffer 2 mapped at address 0x402d6000.
>>>>>>>>> length: 756000 offset: 2273280
>>>>>>>>> Buffer 3 mapped at address 0x4038f000.
>>>>>>>>>
>>>>>>>>> Anyone with the same issue??? This happens with every other v4l test
>>>>>>>>> app
>>>>>>>>> I
>>>>>>>>> used.
>>>>>>>>> I can see data from TVP5151 but there are no interrupts in ISP.
>>>>>>>>
>>>>>>>> Why are you using /dev/video4?  The CCDC output is on /dev/video2
>>
>> --
>> ------------------------------------------------------------
>> Gary Thomas                 |  Consulting for the
>> MLB Associates              |    Embedded world
>> ------------------------------------------------------------
>>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
