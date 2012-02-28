Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2B1AWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 19:22:09 -0500
Received: by ghrr11 with SMTP id r11so55971ghr.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 16:22:09 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <4F4AC779.2060003@iki.fi>
References: <CABcw_OmQEV2K0Hgvnh7xtCNQUmf5pa4ftZJwRFdkM68Hftp=Rg@mail.gmail.com>
	<4984891.IGZ3Td2Zlk@avalon>
	<4F4AC1B2.1000607@iki.fi>
	<6307239.U344RCScuO@avalon>
	<4F4AC779.2060003@iki.fi>
Date: Mon, 27 Feb 2012 18:22:08 -0600
Message-ID: <CABcw_Okn+-kVx3mHFfyLENOoMWQpfVaop-VuDXWMHyghxeYX_w@mail.gmail.com>
Subject: Re: OMAP CCDC with sensors that are always on...
From: Chris Whittenburg <whittenburg@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you both for your assistance.

I was able to make it work by correcting my vsync and hsync inputs,
adjusting the vertical blanking, and finally taking out all my debug
cruft that had built up.

It's nice that my changes were limited to the
board-omap3beagle-camera.c and my custom camera driver file, which I
was able to base on the fsr172x driver (thanks Laurent and AJ).

-chris


On Sun, Feb 26, 2012 at 5:59 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Laurent,
>
> Laurent Pinchart wrote:
>> On Monday 27 February 2012 01:35:14 Sakari Ailus wrote:
>>> Laurent Pinchart wrote:
>>>> On Saturday 25 February 2012 01:48:02 Sakari Ailus wrote:
>>>>> On Fri, Feb 17, 2012 at 05:32:31PM -0600, Chris Whittenburg wrote:
>>>>>> I fixed my sensor to respect a "run" signal from the omap, so that now
>>>>>> it only sends data when the ccdc is expecting it.
>>>>>>
>>>>>> This fixed my problem, and now I can capture the 640x1440 frames.
>>>>>>
>>>>>> At least the first one...
>>>>>>
>>>>>> Subsequent frames are always full of 0x55, like the ISP didn't write
>>>>>> anything into them.
>>>>>>
>>>>>> I still get the VD0 interrupts, and I checked that WEN in the
>>>>>> CCDC_SYN_MODE register is set, and that the EXWEN bit is clear.
>>>>>>
>>>>>> I'm using the command:
>>>>>> yavta -c2 -p -F --skip 0 -f Y8 -s 640x1440 /dev/video2
>>>>>>
>>>>>> Here are my register settings:
>>>>>>
>>>>>> [ 6534.029907] omap3isp omap3isp: -------------CCDC Register
>>>>>> dump------------- [ 6534.029907] omap3isp omap3isp: ###CCDC
>>>>>> PCR=0x00000000
>>>>>> [ 6534.029937] omap3isp omap3isp: ###CCDC SYN_MODE=0x00030f00
>>>>>> [ 6534.029937] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
>>>>>> [ 6534.029937] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
>>>>>> [ 6534.029968] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000027f
>>>>>> [ 6534.029968] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
>>>>>> [ 6534.029968] omap3isp omap3isp: ###CCDC VERT_LINES=0x0000059f
>>>>>> [ 6534.029998] omap3isp omap3isp: ###CCDC CULLING=0xffff00ff
>>>>>> [ 6534.029998] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x00000280
>>>>>> [ 6534.029998] omap3isp omap3isp: ###CCDC SDOFST=0x00000000
>>>>>> [ 6534.030029] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00001000
>>>>>> [ 6534.030029] omap3isp omap3isp: ###CCDC CLAMP=0x00000010
>>>>>> [ 6534.030029] omap3isp omap3isp: ###CCDC DCSUB=0x00000000
>>>>>> [ 6534.030059] omap3isp omap3isp: ###CCDC COLPTN=0xbb11bb11
>>>>>> [ 6534.030059] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
>>>>>> [ 6534.030059] omap3isp omap3isp: ###CCDC FPC=0x00000000
>>>>>> [ 6534.030090] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
>>>>>> [ 6534.030090] omap3isp omap3isp: ###CCDC VDINT=0x059e03c0
>>>>>> [ 6534.030090] omap3isp omap3isp: ###CCDC ALAW=0x00000000
>>>>>> [ 6534.030120] omap3isp omap3isp: ###CCDC REC656IF=0x00000000
>>>>>> [ 6534.030120] omap3isp omap3isp: ###CCDC CFG=0x00008000
>>>>>> [ 6534.030120] omap3isp omap3isp: ###CCDC FMTCFG=0x0000e000
>>>>>> [ 6534.030151] omap3isp omap3isp: ###CCDC FMT_HORZ=0x00000280
>>>>>> [ 6534.030151] omap3isp omap3isp: ###CCDC FMT_VERT=0x000005a0
>>>>>> [ 6534.030151] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00000000
>>>>>> [ 6534.030181] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
>>>>>> [ 6534.030181] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
>>>>>> [ 6534.030181] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
>>>>>> [ 6534.030212] omap3isp omap3isp: ###CCDC VP_OUT=0x0b3e2800
>>>>>> [ 6534.030212] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00006600
>>>>>> [ 6534.030212] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
>>>>>> [ 6534.030242] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
>>>>>> [ 6534.030242] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
>>>>>> [ 6534.030242] omap3isp omap3isp:
>>>>>> --------------------------------------------
>>>>>>
>>>>>> Output frame 0 is always good, while output frame 1 is 0x5555.
>>>>>>
>>>>>> I believe my sensor is respecting the clocks required before and after
>>>>>> the frame.
>>>>>>
>>>>>> Could the ISP driver be writing my data to some unexpected location
>>>>>> rather than to the v4l2 buffer?
>>>>>>
>>>>>> Is there a way to determine if the CCDC is writing to memory or not?
>>>>>
>>>>> How long vertical blanking do you have? It shouldn't have an effect,
>>>>> though.
>>>> It definitely can :-) If vertical blanking isn't long enough, the CCDC
>>>> will start processing the next frame before the driver gets time to update
>>>> the hardware with the pointer to the next buffer. The first frame will
>>>> then be overwritten.
>>>
>>> Sure, but in that case no buffers should be dequeued from the driver
>>> either --- as they should always be marked faulty since reprogramming
>>> the CCDC isn't possible.
>>
>> Does the driver detect that ?
>
> It does. The CCDC is disabled in VD1 interrupt which should arrive well
> before VD0. The CCDC continues to process frame until the end of it, and
> once it becomes idle, a new buffer address is programmed. At least as
> far as I remember and how the code looks like to me this late in the
> evening. ;)
>
> Chris: are you capturing at CCDC output video node?
>
> It might also make sense to check whether VD1 and VD0 interrupts arrive
> as expected. (I.e. VD1 first, then VD0 on each frame.)
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
