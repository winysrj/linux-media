Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51576 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2LDPzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 10:55:36 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEI001HFKBSW0A0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 15:58:11 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEI00B56K8K0QB0@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Dec 2012 15:55:33 +0000 (GMT)
Message-id: <50BE1CF4.9080009@samsung.com>
Date: Tue, 04 Dec 2012 16:55:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 11/23/2012 04:22 PM, Andrzej Hajda wrote:
> Function support variable number of subdevs in pipe-line.

I'm will be applying this patch with description changed to:

Make the pipeline try format routine more generic to support any
number of subdevs in the pipeline, rather than hard coding it for
only a sensor, MIPI-CSIS and FIMC subdevs and the FIMC video node.

> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/fimc-capture.c |  100 +++++++++++++++---------
>  1 file changed, 64 insertions(+), 36 deletions(-)
> 
...
>  /**
>   * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
>   *                            elements
> @@ -809,65 +824,78 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
...
>  		ffmt = fimc_find_format(NULL, mf->code != 0 ? &mf->code : NULL,
>  					FMT_FLAGS_CAM, i++);
> -		if (ffmt == NULL) {
> -			/*
> -			 * Notify user-space if common pixel code for
> -			 * host and sensor does not exist.
> -			 */
> +		if (ffmt == NULL)
>  			return -EINVAL;
> -		}
> +

And as we agreed, with this chunk removed from the patch. Since the comment
still stands.

--

Thank you!
Sylwester
