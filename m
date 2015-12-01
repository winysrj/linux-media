Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34938 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbLAPmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2015 10:42:54 -0500
Received: by wmuu63 with SMTP id u63so178377628wmu.0
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2015 07:42:52 -0800 (PST)
Subject: Re: [RESEND RFC/PATCH 6/8] media: platform: mtk-vcodec: Add Mediatek
 V4L2 Video Encoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
 <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
 <56588622.8060600@linaro.org> <1448883594.25093.45.camel@mtksdaap41>
 <CAMTL27FchgtJZS4YpVge-x+TstnVHmG1aAnaOV32qCU3zMUbAQ@mail.gmail.com>
 <1448966550.7534.95.camel@mtksdaap41>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	=?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
	<Andrew-CT.Chen@mediatek.com>,
	=?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>,
	=?UTF-8?B?WWluZ2pvZSBDaGVuICjpmbPoi7HmtLIp?=
	<Yingjoe.Chen@mediatek.com>,
	=?UTF-8?B?SmFtZXNKSiBMaWFvICjlu5blu7rmmbop?=
	<jamesjj.liao@mediatek.com>,
	=?UTF-8?B?RGFuaWVsIEhzaWFvICjola3kvK/liZsp?=
	<daniel.hsiao@mediatek.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?UTF-8?B?UG9DaHVuIExpbiAo5p6X5p+P5ZCbKQ==?=
	<PoChun.Lin@mediatek.com>
From: Daniel Thompson <daniel.thompson@linaro.org>
Message-ID: <565DBFF3.1000409@linaro.org>
Date: Tue, 1 Dec 2015 15:42:43 +0000
MIME-Version: 1.0
In-Reply-To: <1448966550.7534.95.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/15 10:42, tiffany lin wrote:
>>>>   > diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
>>>> b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
>>>>   > new file mode 100644
>>>>   > index 0000000..9b3f025
>>>>   > --- /dev/null
> [snip]
>>>>   > +int venc_if_create(void *ctx, unsigned int fourcc, unsigned long
>>>> *handle)
>>>>   > +{
>>>>   > +  struct venc_handle *h;
>>>>   > +  char str[10];
>>>>   > +
>>>>   > +  mtk_vcodec_fmt2str(fourcc, str);
>>>>   > +
>>>>   > +  h = kzalloc(sizeof(*h), GFP_KERNEL);
>>>>   > +  if (!h)
>>>>   > +          return -ENOMEM;
>>>>   > +
>>>>   > +  h->fourcc = fourcc;
>>>>   > +  h->ctx = ctx;
>>>>   > +  mtk_vcodec_debug(h, "fmt = %s handle = %p", str, h);
>>>>   > +
>>>>   > +  switch (fourcc) {
>>>>   > +  default:
>>>>   > +          mtk_vcodec_err(h, "invalid format %s", str);
>>>>   > +          goto err_out;
>>>>   > +  }
>>>>   > +
>>>>   > +  *handle = (unsigned long)h;
>>>>   > +  return 0;
>>>>   > +
>>>>   > +err_out:
>>>>   > +  kfree(h);
>>>>   > +  return -EINVAL;
>>>>   > +}
>>>>   > +
>>>>   > +int venc_if_init(unsigned long handle)
>>>>   > +{
>>>>   > +  int ret = 0;
>>>>   > +  struct venc_handle *h = (struct venc_handle *)handle;
>>>>   > +
>>>>   > +  mtk_vcodec_debug_enter(h);
>>>>   > +
>>>>   > +  mtk_venc_lock(h->ctx);
>>>>   > +  mtk_vcodec_enc_clock_on();
>>>>   > +  vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
>>>>   > +  ret = h->enc_if->init(h->ctx, (unsigned long *)&h->drv_handle);
>>>>   > +  vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
>>>>   > +  mtk_vcodec_enc_clock_off();
>>>>   > +  mtk_venc_unlock(h->ctx);
>>>>   > +
>>>>   > +  return ret;
>>>>   > +}
>>>>
>>>> To me this looks more like an obfuscation layer rather than a
>>>> abstraction layer. I don't understand why we need to hide things from
>>>> the V4L2 implementation that this code forms part of.
>>>>
>>>> More importantly, if this code was included somewhere where it could be
>>>> properly integrated with the device model you might be able to use the
>>>> pm_runtime system to avoid this sort of "heroics" to manage the clocks
>>>> anyway.
>>>>
>>> We want to abstract common part from encoder driver.
>>> Every encoder driver follow same calling flow and only need to take care
>>> about how to communicate with vpu to encode specific format.
>>> Encoder driver do not need to take care clock and multiple instance
>>> issue.
>>
>> Looking at each of those stages:
>>
>> mtk_venc_lock():
>> Why isn't one of the existing V4L2 locking strategies ok for you?
>>
> We only has one encoder hw.
> To support multiple encode instances.
> When one encoder ctx access encoder hw, it need to get lock first.
>
>> mtk_vcodec_enc_clock_on():
>> This does seem like something a sub-driver *should* be doing for itself
> This is for enabling encoder hw related clock.
> To support multiple instances, one encode ctx must get hw lock first
> then clock on/off hw relate clock.
>
>> vpu_enable_clock():
>> Why can't the VPU driver manage this internally using pm_runtime?
>>
> Our VPU do not have power domain.
> We will remove VPU clock on/off and let vpu control it in next version.
>
>>
>> That is why I described this as an obfuscation layer. It is collecting
>> a bunch of stuff that can be handled using the kernel driver model and
>> clumping them together in a special middle layer.
>>
> We do use kernel driver model, but we put it in
> mtk_vcodec_enc_clock_on/mtk_vcodec_enc_clock_off.
> Every sub-driver has no need to write the same code.
> And once clock configuration change or porting to other chips, we don't
> need to change sub-driver one-by-one, just change abstract layer.

I'm afraid I remain extremely unconvinced by the value of this API. It 
is possible that once the types are fixed and it is tidied up it won't 
stick out so much but I will be very surprised.

Either way, I can wait until v2 before we discuss it further.


>>>> If the start streaming operation implemented cleanup-on-error properly
>>>> then there would only be two useful states: Started and stopped. Even
>>>> the "sticky" error behavior looks unnecessary to me (meaning we don't
>>>> need to track its state).
>>>>
>>> We cannot guaranteed that IOCTLs called from the user space follow
>>> required sequence.
>>> We need states to know if our driver could accept IOCTL command.
>>
>> I believe that knowing whether the streaming is started or stopped
>> (e.g. two states) is sufficient for a driver to correctly handle
>> abitrary ioctls from userspace and even then, the core code tracks
>> this state for you so there's no need for you do it.
>>
>> The queue/dequeue ioctls succeed or fail based on the length of the
>> queue (i.e. is the buffer queue overflowing or not) and have no need
>> to check the streaming state.
>
>> If you are absolutely sure that the other states are needed then
>> please provide an example of an ioctl() sequence where the additional
>> state is needed.
>>
> I know your point that we have too many state changes in start_streaming
> and stop_streaming function.
> We will refine these two functions in next version.
>
> For the example, we need MTK_STATE_HEADER state, to make sure before
> encode start, driver already get information to set encode parameters.

Interesting. Again, I'll wait to see how the state simplifcation goes 
before commenting further.


> We need MTK_STATE_ABORT to inform encoder thread (mtk_venc_worker) that
> stop encodeing job from stopped ctx instance.
> When user space qbuf, we need to make sure everything is ready to sent
> buf to encode.

Agree that you need a flag here. In fact currently you have two, 
MTK_STATE_ABORT and an unused one called aborting.

You need to be very careful with these flags though. They are a magnet 
for data race bugs (especially combined with SMP).

For example at present I can't see any locking in the worker code. This 
means there is nothing to make all those read-modify-write sequences 
that manage the state atomic (thus risking state corruption).


Daniel.
