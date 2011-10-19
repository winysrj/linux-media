Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43962 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 09:06:27 -0400
Received: by iaek3 with SMTP id k3so2086238iae.19
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 06:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7vNnTk_AZd4m=AUO8z8XcMuu5x_wYhNPX4tALY4JOCyeQ@mail.gmail.com>
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
	<CA+2YH7voGzNzxcdFCAissTtn_-NAL=_jfiOS8kia9m-=XqwOig@mail.gmail.com>
	<CAFYgh7zzTKT9XHri3seEKDhbMu0xYM=XahjhWU3Wbhj-1U6dhQ@mail.gmail.com>
	<CA+2YH7szWsvzZ7FwL0v99tURrB5qLeR-+ud2cJaRRj0d4HzKaw@mail.gmail.com>
	<CAFYgh7yO7Cizqxms0ZbBEvypHSUPayAwhviNuFuzatYMkW-4gw@mail.gmail.com>
	<CA+2YH7vNnTk_AZd4m=AUO8z8XcMuu5x_wYhNPX4tALY4JOCyeQ@mail.gmail.com>
Date: Wed, 19 Oct 2011 16:06:27 +0300
Message-ID: <CAFYgh7zb0Bv1+rhQMtnY45ZY0Va+1btPsvJrEOdMdxuePEr+ow@mail.gmail.com>
Subject: Re: omap3isp: BT.656 support
From: Boris Todorov <boris.st.todorov@gmail.com>
To: Enrico <ebutera@users.berlios.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 19, 2011 at 3:40 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Wed, Oct 19, 2011 at 11:03 AM, Boris Todorov
> <boris.st.todorov@gmail.com> wrote:
>> Here is my log:
>> [   24.683685] omap3isp omap3isp: -------------CCDC Register dump-------------
>> [   24.683685] omap3isp omap3isp: ###CCDC PCR=0x00000000
>> [   24.683685] omap3isp omap3isp: ###CCDC SYN_MODE=0x00032f80
>> [   24.683715] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
>> [   24.683715] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
>> [   24.683746] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000059f
>> [   24.683746] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
>> [   24.683746] omap3isp omap3isp: ###CCDC VERT_LINES=0x00000105
>> [   24.683776] omap3isp omap3isp: ###CCDC CULLING=0xffff00ff
>> [   24.683776] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x000005a0
>> [   24.683776] omap3isp omap3isp: ###CCDC SDOFST=0x00000249
>> [   24.683807] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00001000
>> [   24.683807] omap3isp omap3isp: ###CCDC CLAMP=0x00000010
>> [   24.683807] omap3isp omap3isp: ###CCDC DCSUB=0x00000000
>> [   24.683837] omap3isp omap3isp: ###CCDC COLPTN=0x00000000
>> [   24.683837] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
>> [   24.683837] omap3isp omap3isp: ###CCDC FPC=0x00000000
>> [   24.683868] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
>> [   24.683868] omap3isp omap3isp: ###CCDC VDINT=0x01040000
>> [   24.683868] omap3isp omap3isp: ###CCDC ALAW=0x00000004
>> [   24.683898] omap3isp omap3isp: ###CCDC REC656IF=0x00000003
>> [   24.683898] omap3isp omap3isp: ###CCDC CFG=0x00008800
>> [   24.683898] omap3isp omap3isp: ###CCDC FMTCFG=0x00006000
>> [   24.683929] omap3isp omap3isp: ###CCDC FMT_HORZ=0x000002d0
>> [   24.683929] omap3isp omap3isp: ###CCDC FMT_VERT=0x0000020d
>> [   24.683929] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00000000
>> [   24.683959] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
>> [   24.683959] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
>> [   24.683959] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
>> [   24.683990] omap3isp omap3isp: ###CCDC VP_OUT=0x04182d00
>> [   24.683990] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00006600
>> [   24.683990] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
>> [   24.684020] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
>> [   24.684020] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000
>> [   24.684051] omap3isp omap3isp: --------------------------------------------
>>
>> This is with:
>>
>> .data_lane_shift = 0,
>> .clk_pol             = 0,
>> .hs_pol             = 0,
>> .vs_pol             = 0,
>> .data_pol              = 0,
>> .fldmode           = 1,
>> .bt656               = 1,
>>
>> and the above mentioned media-ctl settings
>
> From a quick look It seems ok (apart ALAW that maybe should be 0).
>
> One thing to check: before loading omap3-isp kernel module you must
> manually load iommu2, if you don't it will automatically load only
> iommu and it will not work
>
> Enrico
>

When I started omap3-isp was embedded in kernel and my /dev/media0 was
missing. Making it module resolved this issue.
iommu2 is still embedded...
will try with module now
