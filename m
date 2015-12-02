Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35027 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbLBQCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 11:02:54 -0500
Received: by wmuu63 with SMTP id u63so221124416wmu.0
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2015 08:02:53 -0800 (PST)
Subject: Re: [RESEND RFC/PATCH 6/8] media: platform: mtk-vcodec: Add Mediatek
 V4L2 Video Encoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
 <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
 <56588622.8060600@linaro.org> <1448883594.25093.45.camel@mtksdaap41>
 <CAMTL27FchgtJZS4YpVge-x+TstnVHmG1aAnaOV32qCU3zMUbAQ@mail.gmail.com>
 <1448966550.7534.95.camel@mtksdaap41> <565DBFF3.1000409@linaro.org>
 <1449061708.8326.5.camel@mtksdaap41>
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
Message-ID: <565F162A.4070106@linaro.org>
Date: Wed, 2 Dec 2015 16:02:50 +0000
MIME-Version: 1.0
In-Reply-To: <1449061708.8326.5.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/15 13:08, tiffany lin wrote:
>>> We need MTK_STATE_ABORT to inform encoder thread (mtk_venc_worker) that
>>> stop encodeing job from stopped ctx instance.
>>> When user space qbuf, we need to make sure everything is ready to sent
>>> buf to encode.
>>
>> Agree that you need a flag here. In fact currently you have two,
>> MTK_STATE_ABORT and an unused one called aborting.
>>
>> You need to be very careful with these flags though. They are a magnet
>> for data race bugs (especially combined with SMP).
>>
>> For example at present I can't see any locking in the worker code. This
>> means there is nothing to make all those read-modify-write sequences
>> that manage the state atomic (thus risking state corruption).
>>
> We prevent that one function set the flag and others clear the flag.
> So there is no special lock to protect state.

What prevents concurrent access from different calling contexts? It 
looks to me like the work on the work queue may run concurrently with 
the ioctl calls.


> +static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	int retry;
> +	int ret;
> +
> +	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->idx, q->type);
> +
> +	retry = 0;
> +	while ((ctx->state & MTK_STATE_RUNNING) && (retry < 10)) {
> +		mtk_vcodec_clean_ctx_int_flags(ctx);
> +		ctx->state |= MTK_STATE_ABORT;

As a simple example I think the above line can run concurrently with the 
following code near the end of the worker code.

> +	ctx->state &= ~MTK_STATE_RUNNING;
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);

If I'm right then the state of the flags can definitely get clobbered 
due to the read-modify-write actions on the state.


Daniel.
