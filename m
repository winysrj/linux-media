Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51269 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1JIR4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 13:56:42 -0400
Received: by ywb5 with SMTP id 5so4793814ywb.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 10:56:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110091912.47482.laurent.pinchart@ideasonboard.com>
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com> <201110091912.47482.laurent.pinchart@ideasonboard.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 9 Oct 2011 19:56:22 +0200
Message-ID: <CAAwP0s0uqe0Hvcoes3uCKQREz46fDUD0JkNMmAv-fuzbXSp=Kg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add support to ITU-R BT.656 video data format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 9, 2011 at 7:12 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> Thanks for the patches.
>
> On Sunday 09 October 2011 04:37:31 Javier Martinez Canillas wrote:
>> This patch-set aims to add support to the ISP CCDC driver to process
>> interlaced video data in ITU-R BT.656 format.
>>
>> The patch-set contains the following patches:
>>
>> [PATCH 1/2] omap3isp: video: Decouple buffer obtaining and set ISP entities
>> format [PATCH 2/2] omap3isp: ccdc: Add support to ITU-R BT.656 video data
>> format
>>
>> The first patch decouples next frame buffer obtaining from the last frame
>> buffer releasing. This change is needed by the second patch that moves
>> most of the CCDC buffer management logic to the VD1 interrupt handler.
>>
>> This patch-set is a proof-of-concept and was only compile tested since I
>> don't have the hardware to test right now. It is a forward porting, on top
>> of Laurent's omap3isp-omap3isp-yuv tree, of the changes we made to the ISP
>> driver to get interlaced video working.
>>
>> Also, the patch will brake other configurations since the resizer and
>> previewer also make use of omap3isp_video_buffer() function that now has a
>> different semantic.
>
> That's an issue you need to address :-)
>

Hi Laurent,

Yes, I know :-)

The first version of the patch-set was only mean so you can review it
but then I understood that your idea is to actually merge some code I
send a few ours ago a v2 of the patch-set [1].

This v2 is a simpler code that doesn't move any of the logic to the
VD1 interrupt handler so it won't brake others components (resizer,
previewer, etc). So first we can focus to have a working version of
the interlaced video data support in the driver and then try to fix
the artifact effect issue.

It is based on an early version of our patch and also I've address all
the issues you called out on the second patch. The fact that the code
to address interlaced video is not bt656 but fldmode dependent.

Also I split the patches in atomic operations so it can be applied
incrementally without breaking the driver.

Please let me know if you got the v2 patches or I can resend them if
it is easier for you.

[1]: http://www.spinics.net/lists/linux-media/msg38973.html

>> I'm posting even when the patch-set is not in a merge-able state so you can
>> review what we were doing and make comments.
>
> You should split your patches differently. Even if we ignore the above issue,
> your first patch will break the CCDC. In order to ease bissection patches
> should be self-contained and not introduce regressions if possible.
>
> Please see my comments to the second patch.
>
>> These are not all our changes since we also modified the ISP to forward the
>> [G | S]_FMT and [G | S]_STD V4L2 ioctl commands to the TVP5151 and to only
>> copy the active lines, but those changes are not relevant with the ghosting
>> effect. With these changes we could get the 25 fps but with some sort of
>> artifacts on the images.
>
> --
> Regards,
>
> Laurent Pinchart
>

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
