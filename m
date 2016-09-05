Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:51497 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754605AbcIEMC0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 08:02:26 -0400
Subject: Re: [PATCH v5 2/3] st-hva: multi-format video encoder V4L2 driver
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1472476868-10322-1-git-send-email-jean-christophe.trotin@st.com>
 <1472476868-10322-3-git-send-email-jean-christophe.trotin@st.com>
 <398d281c-feb1-d290-b603-d4709914cb0d@xs4all.nl>
 <e89aec4f-d7bb-d51c-ef51-b3e198d266f2@st.com>
Cc: "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0ed7f811-f9a4-be44-3043-0a7669a497e1@xs4all.nl>
Date: Mon, 5 Sep 2016 14:02:16 +0200
MIME-Version: 1.0
In-Reply-To: <e89aec4f-d7bb-d51c-ef51-b3e198d266f2@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2016 01:47 PM, Jean Christophe TROTIN wrote:
> 
> 
> On 09/05/2016 10:24 AM, Hans Verkuil wrote:
>> On 08/29/2016 03:21 PM, Jean-Christophe Trotin wrote:
>>> This patch adds V4L2 HVA (Hardware Video Accelerator) video encoder
>>> driver for STMicroelectronics SoC. It uses the V4L2 mem2mem framework.
>>>
>>> This patch only contains the core parts of the driver:
>>> - the V4L2 interface with the userland (hva-v4l2.c)
>>> - the hardware services (hva-hw.c)
>>> - the memory management utilities (hva-mem.c)
>>>
>>> This patch doesn't include the support of specific codec (e.g. H.264)
>>> video encoding: this support is part of subsequent patches.
>>>
>>> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
>>> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
>>> ---
>>>  drivers/media/platform/Kconfig            |   14 +
>>>  drivers/media/platform/Makefile           |    1 +
>>>  drivers/media/platform/sti/hva/Makefile   |    2 +
>>>  drivers/media/platform/sti/hva/hva-hw.c   |  538 ++++++++++++
>>>  drivers/media/platform/sti/hva/hva-hw.h   |   42 +
>>>  drivers/media/platform/sti/hva/hva-mem.c  |   59 ++
>>>  drivers/media/platform/sti/hva/hva-mem.h  |   34 +
>>>  drivers/media/platform/sti/hva/hva-v4l2.c | 1296 +++++++++++++++++++++++++++++
>>>  drivers/media/platform/sti/hva/hva.h      |  290 +++++++
>>>  9 files changed, 2276 insertions(+)
>>>  create mode 100644 drivers/media/platform/sti/hva/Makefile
>>>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
>>>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
>>>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
>>>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
>>>  create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
>>>  create mode 100644 drivers/media/platform/sti/hva/hva.h
>>>
>>
>> <snip>
>>
>>> +static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>>> +{
>>> +	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>>> +	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>>> +
>>> +	time_per_frame->numerator = sp->parm.capture.timeperframe.numerator;
>>> +	time_per_frame->denominator =
>>> +		sp->parm.capture.timeperframe.denominator;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>>> +{
>>> +	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>>> +	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>>> +
>>> +	sp->parm.capture.timeperframe.numerator = time_per_frame->numerator;
>>> +	sp->parm.capture.timeperframe.denominator =
>>> +		time_per_frame->denominator;
>>> +
>>> +	return 0;
>>> +}
>>
>> In this implementation g/s_parm is supported for both capture and output. Is that
>> intended? If so, please add a comment. If not, then you should check the type.
>>
>> Also the V4L2_CAP_TIMEPERFRAME capability isn't set. I've just added a check to
>> v4l2-compliance to test for that.
>>
>> As per the kbuild robot report you also need to depend on HAS_DMA in the Kconfig.
>>
>> I have no other comments, so once these comments are fixed I can make a pull request.
>>
>> Making a v6 should be quick: if you can post v6 today, then I would very much appreciate
>> it.
>>
>> Regards,
>>
>> 	Hans
>>
> 
> Hi Hans,
> 
> I've aligned the implementation g/s parm with the ones available in coda and 
> mtk-vcodec: g/s parm is supported for output and is rejected (-EINVAL) for any 
> other type.
> 
> I'm confused with the V4L2_CAP_TIMEPERFRAME capability: my understanding is that 
> it should be set only in g_parm (as it's presently done in coda and mtk-vcodec). 

It should be set for both. But v4l2-compliance didn't check for that in the past,
so there are several older drivers that didn't set that capability for s_parm.

I'll ask mediatek to set the capability flag in their driver.

> But, doing this way, then there's a warning with the v4l2-compliance test that 
> you add. Indeed, this test checks the capability after a call to s_parm (which 
> would mean that s_parm should also set the capability), and moreover, always 
> checks it for capture (parm.parm.capture.capability) even the type is output. 

The capture and output layouts are the same, so this works for both.

It's simple: if you can set the timeperframe, then this capability should be set.

Regards,

	Hans

> Could you bring me some explanation about this point (either by email or by IRC)?
> 
> The problem reported by the kbuild robot ("depends on HAS_DMA" missing in the 
> Kconfig) will also be corrected in the version 6.
> 
> I'm ready to deliver a version 6 today: the only remaining point is about the 
> V4L2_CAP_TIMEPERFRAME capability as explained above.
> 
> Regards,
> Jean-Christophe.
> 
