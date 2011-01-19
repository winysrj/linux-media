Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35988 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1ASLFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 06:05:55 -0500
Received: by pwj3 with SMTP id 3so128321pwj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 03:05:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101181036.35818.laurent.pinchart@ideasonboard.com>
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
	<201101141801.01125.laurent.pinchart@ideasonboard.com>
	<AANLkTi=ipwaYj=Be+fqAKhKbaMdR-u8cEquUwapuHYcs@mail.gmail.com>
	<201101181036.35818.laurent.pinchart@ideasonboard.com>
Date: Wed, 19 Jan 2011 12:05:54 +0100
Message-ID: <AANLkTikiYzv-uHzgbDvUSJWDZbiWtC05M24G7Y8Pja04@mail.gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2011/1/18 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Tuesday 18 January 2011 10:20:43 Enric Balletbò i Serra wrote:
>>
>> Now seems yavta is blocked dequeuing a buffer ( VIDIOC_DQBUF ), with
>> strace I get
>>
>> $ strace ./yavta -f SGRBG10 -s 720x525 -n 1 --capture=1 -F /dev/video2
>>
>> mmap2(NULL, 756000, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x4011f000
>> write(1, "Buffer 0 mapped at address 0x401"..., 39Buffer 0 mapped at
>> address 0x4011f000.
>> ) = 39
>> ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbede36cc) = 0
>> ioctl(3, VIDIOC_STREAMON, 0xbede365c)   = 0
>> gettimeofday({10879, 920196}, NULL)     = 0
>> ioctl(3, VIDIOC_DQBUF
>>
>> and the code where stops is here
>>
>> ispqueue.c
>> 913   buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
>> 914   ret = isp_video_buffer_wait(buf, nonblocking);
>>
>> Any idea ?
>
> My guess is that the CCDC doesn't receive the amount of lines it expects.
>
> The CCDC generates an interrupt at 2/3 of the image and another one at the
> beginning of the last line. Start by checking if the ISP generates any
> interrupt to the host with cat /proc/interrupts. If it doesn't, then the CCDC
> receives less than 2/3 of the expected number of lines. If it does, it
> probably receives between 2/3 and 3/3. You can add printk statements in
> ispccdc_vd0_isr() and ispccdc_vd1_isr() to confirm this.

Looks like my problem is that  ispccdc_vd0_isr() and ispccdc_vd1_isr()
are never called, adding printk in these functions I see only a lots
of ispccdc_hs_vs_isr(), Seems the CCDC receives less than 2/3 of
expected number lines. Using an oscilloscope I see VS and HS data
lines of the camera interface, so seems physical interface is working.

I guess I'm missing something to configure in tvp5150 driver but I
don't know. Any help ?

Here is a CCDC Register dump

[ 6211.404205] *** ccdc_configure : height 525
[ 6211.404205] *** ccdc_configure : width 720
[ 6211.404205] omap3isp omap3isp: -------------CCDC Register dump-------------
[ 6211.411315] omap3isp omap3isp: ###CCDC PCR=0x00000001
[ 6211.416381] omap3isp omap3isp: ###CCDC SYN_MODE=0x00000001
[ 6211.421905] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
[ 6211.427520] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
[ 6211.433135] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000028f
[ 6211.438751] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
[ 6211.444458] omap3isp omap3isp: ###CCDC VERT_LINES=0x00000000
[ 6211.450164] omap3isp omap3isp: ###CCDC CULLING=0x00000000
[ 6211.455566] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x00000000
[ 6211.461181] omap3isp omap3isp: ###CCDC SDOFST=0x00000000
[ 6211.466552] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00000000
[ 6211.472076] omap3isp omap3isp: ###CCDC CLAMP=0x00000000
[ 6211.477325] omap3isp omap3isp: ###CCDC DCSUB=0x00000000
[ 6211.482604] omap3isp omap3isp: ###CCDC COLPTN=0x00000000
[ 6211.487945] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
[ 6211.493286] omap3isp omap3isp: ###CCDC FPC=0x80000000
[ 6211.498382] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
[ 6211.503906] omap3isp omap3isp: ###CCDC VDINT=0x0000002a
[ 6211.509155] omap3isp omap3isp: ###CCDC ALAW=0x00000000
[ 6211.514343] omap3isp omap3isp: ###CCDC REC656IF=0x00020000
[ 6211.519866] omap3isp omap3isp: ###CCDC CFG=0x0000b210
[ 6211.524932] omap3isp omap3isp: ###CCDC FMTCFG=0x00000000
[ 6211.530303] omap3isp omap3isp: ###CCDC FMT_HORZ=0x000002d0
[ 6211.535827] omap3isp omap3isp: ###CCDC FMT_VERT=0x00000200
[ 6211.541351] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00013210
[ 6211.546875] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
[ 6211.552398] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
[ 6211.557830] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
[ 6211.563262] omap3isp omap3isp: ###CCDC VP_OUT=0x04182d00
[ 6211.568603] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00000000
[ 6211.574310] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
[ 6211.580108] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
[ 6211.586151] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
[ 6211.592376] omap3isp omap3isp: --------------------------------------------

Thanks in advance,
    Enric

>
> --
> Regards,
>
> Laurent Pinchart
>
