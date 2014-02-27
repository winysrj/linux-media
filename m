Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50337 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaB0Lhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 06:37:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 06/15] vb2: add note that buf_finish can be called with !vb2_is_streaming()
Date: Thu, 27 Feb 2014 12:39:15 +0100
Message-ID: <5531711.0kD74xJGgQ@avalon>
In-Reply-To: <1393332775-44067-7-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl> <1393332775-44067-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 25 February 2014 13:52:46 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Drivers need to be aware that buf_finish can be called when there is no
> streaming going on, so make a note of that.
> 
> Also add a bunch of missing periods at the end of sentences.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>
> ---
>  include/media/videobuf2-core.h | 44 ++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f443ce0..82b7f0f 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h

[snip]

>   * @buf_finish:		called before every dequeue of the buffer back to
>   *			userspace; drivers may perform any operations required
> - *			before userspace accesses the buffer; optional
> + *			before userspace accesses the buffer; optional. Note:
> + *			this op can be called as well when vb2_is_streaming()
> + *			returns false!

Based on patch 05/15 several drivers assumed that buf_finish is only be called 
when the buffer is to be dequeued to userspace, and performed operations such 
as decompressing the image (yuck...), updating buffer fields such as the 
timestamp, ... If I understand the problem correctly, those operations are 
just a waste of CPU cycles if the buffer will not be returned to userspace, 
hence the driver changes in patch 05/15.

I would document that explicitly here to tell driver developers that 
buf_finish will be called for every buffer that has been queued, and that 
operations related to updating the buffer for userspace can be skipped if the 
queue isn't streaming.

-- 
Regards,

Laurent Pinchart

