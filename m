Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61339 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2A3NE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 08:04:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYM00HXV4C9C950@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jan 2012 13:04:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYM003404C81W@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jan 2012 13:04:57 +0000 (GMT)
Date: Mon, 30 Jan 2012 14:04:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH][media] s5p-g2d: Add HFLIP and VFLIP support
In-reply-to: <201201301311.48370.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com, patches@linaro.org
Message-id: <4F269578.5040205@samsung.com>
References: <1327917523-29836-1-git-send-email-sachin.kamat@linaro.org>
 <201201301311.48370.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2012 01:11 PM, Laurent Pinchart wrote:
>>  static int g2d_open(struct file *file)
>> @@ -564,6 +591,8 @@ static void device_run(void *prv)
>>  	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(dst, 0));
>>
>>  	g2d_set_rop4(dev, ctx->rop);
>> +	g2d_set_flip(dev, ctx->hflip | ctx->vflip);
>> +
> 
> Is this called for every frame, or once at stream start only ? In the later 
> case, this means that hflip and vflip won't be changeable during streaming. Is 
> that on purpose ?

The device_run() callback is called per each frame, i.e. per each single
buffer pair. Hence it should be possible to reconfigure flipping when
streaming is on.

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
