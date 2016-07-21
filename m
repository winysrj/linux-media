Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43265 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbcGUJt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 05:49:29 -0400
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
 <28f37284-0c57-7d22-a32d-5627079c86d5@xs4all.nl> <57907A19.9000407@st.com>
Cc: "kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0396c89-922a-ff9f-47cd-0bcbdbaf5dcb@xs4all.nl>
Date: Thu, 21 Jul 2016 11:49:22 +0200
MIME-Version: 1.0
In-Reply-To: <57907A19.9000407@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 09:30 AM, Jean Christophe TROTIN wrote:
> 
> On 07/18/2016 01:45 PM, Hans Verkuil wrote:
>> Hi Jean-Christophe,
>>
>> See my review comments below. Nothing really major, but I do need to know more
>> about the g/s_parm and the restriction on the number of open()s has to be lifted.
>> That's not allowed.
>>
> 
> Hi Hans,
> 
> Thank you for your comments.
> I've explained below why I would like to keep 'hva' as driver's name and why the
> frame rate is needed (g/s_parm).
> I've followed your advice for managing the hardware restriction with regards to
> the number of codec instances (see also below).
> Finally, I've taken into account all the other comments.
> All these modifications will be reflected in the version 3.
> 
> Best regards,
> Jean-Christophe.
> 
>> On 07/11/2016 05:14 PM, Jean-Christophe Trotin wrote:
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
>>>   drivers/media/platform/Kconfig            |   14 +
>>>   drivers/media/platform/Makefile           |    1 +
>>>   drivers/media/platform/sti/hva/Makefile   |    2 +
>>>   drivers/media/platform/sti/hva/hva-hw.c   |  534 ++++++++++++
>>>   drivers/media/platform/sti/hva/hva-hw.h   |   42 +
>>>   drivers/media/platform/sti/hva/hva-mem.c  |   60 ++
>>>   drivers/media/platform/sti/hva/hva-mem.h  |   36 +
>>>   drivers/media/platform/sti/hva/hva-v4l2.c | 1299 +++++++++++++++++++++++++++++
>>>   drivers/media/platform/sti/hva/hva.h      |  284 +++++++
>>>   9 files changed, 2272 insertions(+)
>>>   create mode 100644 drivers/media/platform/sti/hva/Makefile
>>>   create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
>>>   create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
>>>   create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
>>>   create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
>>>   create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
>>>   create mode 100644 drivers/media/platform/sti/hva/hva.h
>>>
>>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>>> index 382f393..182d63f 100644
>>> --- a/drivers/media/platform/Kconfig
>>> +++ b/drivers/media/platform/Kconfig
>>> @@ -227,6 +227,20 @@ config VIDEO_STI_BDISP
>>>        help
>>>          This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
>>>
>>> +config VIDEO_STI_HVA
>>> +     tristate "STMicroelectronics STiH41x HVA multi-format video encoder V4L2 driver"
>>> +     depends on VIDEO_DEV && VIDEO_V4L2
>>> +     depends on ARCH_STI || COMPILE_TEST
>>> +     select VIDEOBUF2_DMA_CONTIG
>>> +     select V4L2_MEM2MEM_DEV
>>> +     help
>>> +       This V4L2 driver enables HVA multi-format video encoder of
>>
>> Please mention here what HVA stands for.
>>
> 
> Done in version 3.
> HVA stands for "Hardware Video Accelerator".
> 
>>> +       STMicroelectronics SoC STiH41x series, allowing hardware encoding of raw
>>> +       uncompressed formats in various compressed video bitstreams format.
>>> +
>>> +       To compile this driver as a module, choose M here:
>>> +       the module will be called hva.
>>
>> How about sti-hva as the module name? 'hva' is a bit too generic.
>>
> 
> 'hva' is a generic IP which could be used on different STMicroelectronics SoCs.
> That's the reason why I would like to keep this name. It's not specific to  the
> STiH41x series: thus, I've reworked the Kconfig's comment.

How about st-hva? I really like it to be a bit more specific.

>>> +static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>>> +{
>>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>>> +     struct device *dev = ctx_to_dev(ctx);
>>> +     struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>>> +
>>> +     time_per_frame->numerator = sp->parm.capture.timeperframe.numerator;
>>> +     time_per_frame->denominator =
>>> +             sp->parm.capture.timeperframe.denominator;
>>> +
>>> +     dev_dbg(dev, "%s set parameters %d/%d\n", ctx->name,
>>> +             time_per_frame->numerator, time_per_frame->denominator);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
>>> +{
>>> +     struct hva_ctx *ctx = fh_to_ctx(file->private_data);
>>> +     struct device *dev = ctx_to_dev(ctx);
>>> +     struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
>>> +
>>> +     sp->parm.capture.timeperframe.numerator = time_per_frame->numerator;
>>> +     sp->parm.capture.timeperframe.denominator =
>>> +             time_per_frame->denominator;
>>> +
>>> +     dev_dbg(dev, "%s get parameters %d/%d\n", ctx->name,
>>> +             time_per_frame->numerator, time_per_frame->denominator);
>>> +
>>> +     return 0;
>>> +}
>>
>> This is strange. Normally codecs don't need this. You give them a buffer and
>> it will be encoded/decoded and then you give it the next one if it is available.
>> There is normally no frame rate involved.
>>
>> How does this work in this SoC? I need to know a bit more about this to be
>> certain there isn't a misunderstanding somewhere.
>>
> 
> Among the parameters dimensioning its buffer model, the 'hva' HW IP needs to
> calculate the depletion that is the quantity of bits at the output of the
> encoder in each time slot, basically bitrate/framerate. That's the reason for
> these 2 functions.
> Furthermore, I've seen that mtk-vcodec and coda encoders also get the frame rate
> to configure their HW IPs (vidioc_venc_s_parm & coda_s_parm).

Ah, OK. That makes sense. So this is *only* used in calculating the bitrate(s),
not in actual scheduling of threads or something like that, right?

Regards,

	Hans
