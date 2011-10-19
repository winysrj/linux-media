Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50175 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1JSI2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 04:28:34 -0400
Received: by yxp4 with SMTP id 4so1429444yxp.19
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 01:28:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFYgh7zzTKT9XHri3seEKDhbMu0xYM=XahjhWU3Wbhj-1U6dhQ@mail.gmail.com>
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
	<CA+2YH7voGzNzxcdFCAissTtn_-NAL=_jfiOS8kia9m-=XqwOig@mail.gmail.com>
	<CAFYgh7zzTKT9XHri3seEKDhbMu0xYM=XahjhWU3Wbhj-1U6dhQ@mail.gmail.com>
Date: Wed, 19 Oct 2011 10:28:34 +0200
Message-ID: <CA+2YH7szWsvzZ7FwL0v99tURrB5qLeR-+ud2cJaRRj0d4HzKaw@mail.gmail.com>
Subject: Re: omap3isp: BT.656 support
From: Enrico <ebutera@users.berlios.de>
To: Boris Todorov <boris.st.todorov@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 19, 2011 at 9:01 AM, Boris Todorov
<boris.st.todorov@gmail.com> wrote:
> On Tue, Oct 18, 2011 at 7:31 PM, Enrico <ebutera@users.berlios.de> wrote:
>> You can try if this:
>>
>> http://www.spinics.net/lists/linux-media/msg37795.html
>>
>> makes it work.
>
> Tried it but it's doesn't work for me.
>
> When yavta calls VIDIOC_DQBUF I'm stuck here:
> omap3isp_video_queue_dqbuf() -> isp_video_buffer_wait()
> "Wait for a buffer to be ready" with O_NONBLOCK
>
> Btw my kernel is 2.6.35 but ISP and V4L are taken from
> omap3isp-omap3isp-yuv and according ISP/TVP register settings
> everything should be OK...

When you stop yavta you should have in the kernel log something like
this (this comes from an old log i'm not 100% sure they are the
correct values):

[  655.470581] omap3isp omap3isp: ###CCDC PCR=0x00000000
[  655.475677] omap3isp omap3isp: ###CCDC SYN_MODE=0x00032f80
[  655.481231] omap3isp omap3isp: ###CCDC HD_VD_WID=0x00000000
[  655.486816] omap3isp omap3isp: ###CCDC PIX_LINES=0x00000000
[  655.492431] omap3isp omap3isp: ###CCDC HORZ_INFO=0x0000059f
[  655.498046] omap3isp omap3isp: ###CCDC VERT_START=0x00000000
[  655.503784] omap3isp omap3isp: ###CCDC VERT_LINES=0x00000139
[  655.509460] omap3isp omap3isp: ###CCDC CULLING=0xffff00ff
[  655.514892] omap3isp omap3isp: ###CCDC HSIZE_OFF=0x000005a0
[  655.520507] omap3isp omap3isp: ###CCDC SDOFST=0x00000249
[  655.525848] omap3isp omap3isp: ###CCDC SDR_ADDR=0x00001000
[  655.531372] omap3isp omap3isp: ###CCDC CLAMP=0x00000010
[  655.536651] omap3isp omap3isp: ###CCDC DCSUB=0x00000040
[  655.541900] omap3isp omap3isp: ###CCDC COLPTN=0xbb11bb11
[  655.547271] omap3isp omap3isp: ###CCDC BLKCMP=0x00000000
[  655.552612] omap3isp omap3isp: ###CCDC FPC=0x00000000
[  655.557708] omap3isp omap3isp: ###CCDC FPC_ADDR=0x00000000
[  655.563232] omap3isp omap3isp: ###CCDC VDINT=0x013800d1
[  655.568511] omap3isp omap3isp: ###CCDC ALAW=0x00000000
[  655.573669] omap3isp omap3isp: ###CCDC REC656IF=0x00000003
[  655.579193] omap3isp omap3isp: ###CCDC CFG=0x00008800
[  655.584289] omap3isp omap3isp: ###CCDC FMTCFG=0x0000e000
[  655.589660] omap3isp omap3isp: ###CCDC FMT_HORZ=0x00000000
[  655.595184] omap3isp omap3isp: ###CCDC FMT_VERT=0x00000000
[  655.600769] omap3isp omap3isp: ###CCDC PRGEVEN0=0x00000000
[  655.606323] omap3isp omap3isp: ###CCDC PRGEVEN1=0x00000000
[  655.611816] omap3isp omap3isp: ###CCDC PRGODD0=0x00000000
[  655.617279] omap3isp omap3isp: ###CCDC PRGODD1=0x00000000
[  655.622711] omap3isp omap3isp: ###CCDC VP_OUT=0x00000000
[  655.628051] omap3isp omap3isp: ###CCDC LSC_CONFIG=0x00006600
[  655.633758] omap3isp omap3isp: ###CCDC LSC_INITIAL=0x00000000
[  655.639556] omap3isp omap3isp: ###CCDC LSC_TABLE_BASE=0x00000000
[  655.645599] omap3isp omap3isp: ###CCDC LSC_TABLE_OFFSET=0x00000000

Send your values so we can try to see where the problem is.

Enrico
