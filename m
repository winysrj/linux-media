Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43355 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab0C2L4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 07:56:44 -0400
Subject: Re: [PATCH v3 1/2] v4l: Add memory-to-memory device helper
 framework for videobuf.
From: Andy Walls <awalls@md.metrocast.net>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hvaibhav@ti.com
In-Reply-To: <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
	 <1269848207-2325-2-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain
Date: Mon, 29 Mar 2010 07:57:01 -0400
Message-Id: <1269863821.3952.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-29 at 09:36 +0200, Pawel Osciak wrote:
> A mem-to-mem device is a device that uses memory buffers passed by
> userspace applications for both their source and destination data. This
> is different from existing drivers, which utilize memory buffers for either
> input or output, but not both.
> 
> In terms of V4L2 such a device would be both of OUTPUT and CAPTURE type.
> 
> Examples of such devices would be: image 'resizers', 'rotators',
> 'colorspace converters', etc.
> 
> This patch adds a separate Kconfig sub-menu for mem-to-mem devices as well.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Pawel,

I didn't do a full review (I have no time lately), but I noticed this: 


> +static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> +{
> +	struct v4l2_m2m_dev *m2m_dev;
[...]
> +	v4l2_m2m_try_run(m2m_dev);
> +}

[...]

> +void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
> +			 struct v4l2_m2m_ctx *m2m_ctx)
> +{
[...]
> +	  v4l2_m2m_try_schedule(m2m_ctx);
> +	v4l2_m2m_try_run(m2m_dev);
> +}

I assume it is not bad, but was it your intention to have an addtitonal
call to v4l2_m2m_try_run() ?


Regards,
Andy

