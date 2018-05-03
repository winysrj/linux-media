Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45922 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751069AbeECPTX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 11:19:23 -0400
Subject: Re: [PATCH v11 2/4] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
References: <20180424122700.5387-1-maxime.ripard@bootlin.com>
 <20180424122700.5387-3-maxime.ripard@bootlin.com>
 <4924400e-67ea-e523-321a-a9d3490d7873@xs4all.nl>
 <20180503151350.7pdu5kdl6vp7wz4y@flea>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d8e965c-90f4-6d86-6759-6d77ad7fefc5@xs4all.nl>
Date: Thu, 3 May 2018 17:19:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180503151350.7pdu5kdl6vp7wz4y@flea>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/18 17:13, Maxime Ripard wrote:
> Hi!
> 
> Thanks for your review,
> 
> On Thu, May 03, 2018 at 12:54:57PM +0200, Hans Verkuil wrote:
>>> +static int csi2rx_stop(struct csi2rx_priv *csi2rx)
>>> +{
>>> +	unsigned int i;
>>> +
>>> +	clk_prepare_enable(csi2rx->p_clk);
>>> +	clk_disable_unprepare(csi2rx->sys_clk);
>>> +
>>> +	for (i = 0; i < csi2rx->max_streams; i++) {
>>> +		writel(0, csi2rx->base + CSI2RX_STREAM_CTRL_REG(i));
>>> +
>>> +		clk_disable_unprepare(csi2rx->pixel_clk[i]);
>>> +	}
>>> +
>>> +	clk_disable_unprepare(csi2rx->p_clk);
>>> +
>>> +	return v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, false);
>>> +}
>>> +
>>> +static int csi2rx_s_stream(struct v4l2_subdev *subdev, int enable)
>>> +{
>>> +	struct csi2rx_priv *csi2rx = v4l2_subdev_to_csi2rx(subdev);
>>> +	int ret = 0;
>>> +
>>> +	mutex_lock(&csi2rx->lock);
>>> +
>>> +	if (enable) {
>>> +		/*
>>> +		 * If we're not the first users, there's no need to
>>> +		 * enable the whole controller.
>>> +		 */
>>> +		if (!csi2rx->count) {
>>> +			ret = csi2rx_start(csi2rx);
>>> +			if (ret)
>>> +				goto out;
>>> +		}
>>> +
>>> +		csi2rx->count++;
>>> +	} else {
>>> +		csi2rx->count--;
>>> +
>>> +		/*
>>> +		 * Let the last user turn off the lights.
>>> +		 */
>>> +		if (!csi2rx->count) {
>>> +			ret = csi2rx_stop(csi2rx);
>>> +			if (ret)
>>> +				goto out;
>>
>> Here the error from csi2rx_stop is propagated to the caller, but in the TX
>> driver it is ignored. Is there a reason for the difference?
> 
> Even though that wasn't really intentional, TX only does a writel in
> its stop (which cannot fail), while RX will need to communicate with
> its subdev, and that can fail.
> 
>> In general I see little value in propagating errors when releasing/stopping
>> something, since there is usually very little you can do to handle the error.
>> It really shouldn't fail.
> 
> So do you want me to ignore the values in the s_stream function and
> log the error, or should I just make the start / stop function return
> void?

You can't ignore errors from start(), those should always be returned to the
caller. But for stop() I'd just log the error and make csi2rx/tx_stop void functions.

Regards,

	Hans

> 
> Maxime
> 
