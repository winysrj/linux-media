Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18742 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3JDIRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 04:17:03 -0400
Date: Fri, 4 Oct 2013 11:16:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devel@driverdev.osuosl.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] v4l: omap4iss: Add support for OMAP4 camera
 interface - Video devices
Message-ID: <20131004081638.GA6192@mwanda>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1380758133-16866-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380758133-16866-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 03, 2013 at 01:55:29AM +0200, Laurent Pinchart wrote:
> +
> +	ret = vb2_streamon(&vfh->queue, type);
> +	if (ret < 0)
> +		goto err_iss_video_check_format;
> +
> +	/* In sensor-to-memory mode, the stream can be started synchronously
> +	 * to the stream on command. In memory-to-memory mode, it will be
> +	 * started when buffers are queued on both the input and output.
> +	 */
> +	if (pipe->input == NULL) {
> +		unsigned long flags;
> +		ret = omap4iss_pipeline_set_stream(pipe,
> +					      ISS_PIPELINE_STREAM_CONTINUOUS);
> +		if (ret < 0)
> +			goto err_omap4iss_set_stream;
> +		spin_lock_irqsave(&video->qlock, flags);
> +		if (list_empty(&video->dmaqueue))
> +			video->dmaqueue_flags |= ISS_VIDEO_DMAQUEUE_UNDERRUN;
> +		spin_unlock_irqrestore(&video->qlock, flags);
> +	}
> +
> +	if (ret < 0) {
> +err_omap4iss_set_stream:
> +		vb2_streamoff(&vfh->queue, type);
> +err_iss_video_check_format:
> +		media_entity_pipeline_stop(&video->video.entity);
> +err_media_entity_pipeline_start:
> +		if (video->iss->pdata->set_constraints)
> +			video->iss->pdata->set_constraints(video->iss, false);
> +		video->queue = NULL;
> +	}
> +
> +	if (!ret)
> +		video->streaming = 1;
> +
> +	mutex_unlock(&video->stream_lock);
> +	return ret;
> +}

This driver is mostly really nice code, but this error handling is
spaghetti-al-nasty.  Just split up the success and failure returns.

	video->streaming = 1;
	mutex_unlock(&video->stream_lock);
	return 0;

err_omap4iss_set_stream:
	vb2_streamoff(&vfh->queue, type);
err_iss_video_check_format:
	media_entity_pipeline_stop(&video->video.entity);
err_media_entity_pipeline_start:
	if (video->iss->pdata->set_constraints)
		video->iss->pdata->set_constraints(video->iss, false);
	video->queue = NULL;

	mutex_unlock(&video->stream_lock);
	return ret;
}

regards,
dan carpenter


