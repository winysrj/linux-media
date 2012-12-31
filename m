Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10579 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2LaLPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 06:15:25 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MFW00IWE79M2G60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Dec 2012 11:15:23 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MFW00HQB79ML800@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Dec 2012 11:15:22 +0000 (GMT)
Message-id: <50E173C2.6060704@samsung.com>
Date: Mon, 31 Dec 2012 12:15:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH RFC 1/3] [media] s5c73m3: Add driver
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1353684150-24581-2-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On 11/23/2012 04:22 PM, Andrzej Hajda wrote:
> Add driver for S5C73M3 image sensor. The driver exposes the sensor as
> two subdevs: pure sensor and output interface. Two subdev architecture
> supports interleaved UYVY/JPEG image format with separate frame size
> for both sub-formats, there is a separate pad for each sub-format.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/i2c/Kconfig                 |    7 +
>  drivers/media/i2c/Makefile                |    1 +
>  drivers/media/i2c/s5c73m3/Makefile        |    2 +
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c  | 1728 +++++++++++++++++++++++++++++
>  drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c |  565 ++++++++++
>  drivers/media/i2c/s5c73m3/s5c73m3-spi.c   |  156 +++
>  drivers/media/i2c/s5c73m3/s5c73m3.h       |  459 ++++++++
>  include/media/s5c73m3.h                   |   55 +
>  8 files changed, 2973 insertions(+)

Any comments on this patch ? If there is no objections I'll send
a pull request including it later this week.

Thanks,
Sylwester

