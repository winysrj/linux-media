Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4334 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0BQSTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 13:19:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: Fourcc for multiplanar formats
Date: Wed, 17 Feb 2010 19:21:36 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Kamil Debski'" <k.debski@samsung.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C5635702@bssrvexch01.BS.local>
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC09C5635702@bssrvexch01.BS.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002171921.36567.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 15 February 2010 17:27:46 Pawel Osciak wrote:
> Hello,
> 
> we would like to ask for suggestions for new fourcc formats for multiplanar buffers.
> 
> There are planar formats in V4L2 API, but for all of them, each plane X "immediately
> follows Y plane in memory". We are in the process of testing formats and V4L2 extensions
> that relax those requirements and allow each plane to reside in a separate area of
> memory.
> 
> I am not sure how we should name those formats though. In our example, we are focusing
> on the following formats at the moment:
> - YCbCr 422 2-planar (multiplanar version of V4L2_PIX_FMT_NV16)
> - YCbCr 422 3-planar (multiplanar version of V4L2_PIX_FMT_YUV422P)
> - YCbCr 420 2-planar (multiplanar version of V4L2_PIX_FMT_NV12)
> - YCbCr 420 3-planar (multiplanar version of V4L2_PIX_FMT_YUV420)
> 
> 
> Could anyone give any suggestions how we should name such formats and what to pass to
> the v4l2_fourcc() macro?

What about V4L2_PIX_FMT_NV16_2P, V4L2_PIX_FMT_YUV422P_3P, etc.?

What we pass to the fourcc macro is not very important IMHO. As long as it is unique.

Regards,

	Hans

> 
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
