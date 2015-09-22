Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44171 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757865AbbIVOYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:24:37 -0400
Subject: Re: [RFC PATCH v5 6/8] media: videobuf2: Replace v4l2-specific data
 with vb2 data.
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-7-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5601649E.9070709@xs4all.nl>
Date: Tue, 22 Sep 2015 16:24:30 +0200
MIME-Version: 1.0
In-Reply-To: <1442928636-3589-7-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 22-09-15 15:30, Junghak Sung wrote:
> Simple changes that replace v4l2-specific data with vb2 data
> in videobuf2-core.
> 
> enum v4l2_buf_type --> int
> enum v4l2_memory --> enum vb2_memory
> VIDEO_MAX_FRAME --> VB2_MAX_FRAME
> VIDEO_MAX_PLANES --> VB2_MAX_PLANES
> struct v4l2_fh *owner --> void *owner
> V4L2_TYPE_IS_MULTIPLANAR() --> is_multiplanar
> V4L2_TYPE_IS_OUTPUT() --> is_output
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
