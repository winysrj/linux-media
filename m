Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37596 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbbIVNoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 09:44:13 -0400
Subject: Re: [RFC PATCH v5 5/8] media: videobuf2: Change queue_setup argument
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-6-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56015B25.4070102@xs4all.nl>
Date: Tue, 22 Sep 2015 15:44:05 +0200
MIME-Version: 1.0
In-Reply-To: <1442928636-3589-6-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

On 22-09-15 15:30, Junghak Sung wrote:
> Replace struct v4l2_format * with vb2_format * to make queue_setup()
> for common use.
> 
> struct vb2_format {
> 	unsigned int	type;
> 	unsigned int	pixelformat;
> 	unsigned int	width;
> 	unsigned int	height;
> 	unsigned int	num_planes;
> 	unsigned int	bytesperline[VIDEO_MAX_PLANES];
> 	unsigned int	req_sizes[VIDEO_MAX_PLANES];
> };

Why would you need all the other fields besides req_sizes[]?

Which drivers actually need those other fields? Drivers like exynos4-is/fimc-lite.c
don't actually use anything but req_sizes if you read the code carefully.

I suspect any driver that uses more than req_sizes is actually buggy or
written carelessly.

I wish you'd checked with me before making this struct...

Be aware that I'm abroad (vacation/conferences) from tomorrow until October 10,
so I won't be able to do in-depth reviews during that time (well, I'm able,
but I don't want to!)

Regards,

	Hans
