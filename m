Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37244 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752134AbbJPMFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 08:05:18 -0400
Date: Fri, 16 Oct 2015 15:04:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v7 3/7] media: videobuf2: Add set_timestamp to struct
 vb2_queue
Message-ID: <20151016120444.GJ26916@valkosipuli.retiisi.org.uk>
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
 <1444976863-3657-4-git-send-email-jh1009.sung@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1444976863-3657-4-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

On Fri, Oct 16, 2015 at 03:27:39PM +0900, Junghak Sung wrote:
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f1e7169..6ef7da7 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -431,6 +431,7 @@ struct vb2_buf_ops {
>   *		called since poll() needs to return POLLERR in that situation.
>   * @is_multiplanar: set if buffer type is multiplanar
>   * @is_output:	set if buffer type is output
> + * @copy_timestamp: set if vb2-core should set timestamps
>   * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>   *		last decoded buffer was already dequeued. Set for capture queues
>   *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
> @@ -480,6 +481,7 @@ struct vb2_queue {
>  	unsigned int			waiting_for_buffers:1;
>  	unsigned int			is_multiplanar:1;
>  	unsigned int			is_output:1;
> +	unsigned int			set_timestamp:1;
>  	unsigned int			last_buffer_dequeued:1;
>  
>  	struct vb2_fileio_data		*fileio;

V4L2 buffers use struct timeval with µs precision. Generally speaking, if us
precision is preferred elsewhere, the non-V4l2 specific portion could use
that. The conversion could be done in the videobuf2-v4l2.c.

This could be also changed later on if needed, but please use struct
timespec in new APIs instead of struct timeval. V4L2 events use it, for
instance.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
