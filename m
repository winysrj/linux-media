Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35997 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbcBQHr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 02:47:57 -0500
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Encoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C425A0.6080005@xs4all.nl>
Date: Wed, 17 Feb 2016 08:47:44 +0100
MIME-Version: 1.0
In-Reply-To: <1455604653.19396.68.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2016 07:37 AM, tiffany lin wrote:
>>> +static int fops_vcodec_open(struct file *file)
>>> +{
>>> +	struct video_device *vfd = video_devdata(file);
>>> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
>>> +	struct mtk_vcodec_ctx *ctx = NULL;
>>> +	int ret = 0;
>>> +
>>> +	mutex_lock(&dev->dev_mutex);
>>> +
>>> +	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
>>> +	if (!ctx) {
>>> +		ret = -ENOMEM;
>>> +		goto err_alloc;
>>> +	}
>>> +
>>> +	if (dev->num_instances >= MTK_VCODEC_MAX_ENCODER_INSTANCES) {
>>> +		mtk_v4l2_err("Too many open contexts\n");
>>> +		ret = -EBUSY;
>>> +		goto err_no_ctx;
>>
>> Hmm. I never like it if you can't open a video node because of a reason like this.
>>
>> I.e. a simple 'v4l2-ctl -D' (i.e. calling QUERYCAP) should never fail.
>>
>> If there are hardware limitation that prevent more than X instances from running at
>> the same time, then those limitations typically kick in when you start to stream
>> (or possibly when calling REQBUFS). But before that it should always be possible to
>> open the device.
>>
>> Having this check at open() is an indication of a poor design.
>>
>> Is this is a hardware limitation at all?
>>
> This is to make sure performance meet requirements, such as bitrate and
> framerate.

Is it the driver's job to make enforce this? What if the application only
deals with low-res video, but wants to encode a lot of those? Or is encoding
a video off-line?

The driver generally doesn't know the use-case, so if this is an artificial
limitation as opposed to a hardware limitation, then I would just drop this.

Regards,

	Hans

> We got your point. We will remove this and move limitation control to
> start_streaming or REQBUFS.
> Appreciated for your suggestion.:)
> 
> 
>>> +	}

