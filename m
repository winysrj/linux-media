Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48476 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032186AbbKELKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 06:10:47 -0500
Subject: Re: [RFC PATCH v9 5/6] media: videobuf2: Refactor vb2_fileio_data and
 vb2_thread
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-6-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563B392C.10600@xs4all.nl>
Date: Thu, 5 Nov 2015 12:10:36 +0100
MIME-Version: 1.0
In-Reply-To: <1446545802-28496-6-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/15 11:16, Junghak Sung wrote:
> Replace v4l2-stuffs with common things in struct vb2_fileio_data and
> vb2_thread().
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
