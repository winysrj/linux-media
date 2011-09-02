Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:22866 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933421Ab1IBLIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:08:50 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH v3 RESEND] media: vb2: change queue initialization order
Date: Fri, 2 Sep 2011 19:07:04 +0800
Message-ID: <4C79549CB6F772498162A641D92D532802A0922F@penmb01.corp.atmel.com>
In-Reply-To: <1314619082-17911-1-git-send-email-m.szyprowski@samsung.com>
References: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com> <1314619082-17911-1-git-send-email-m.szyprowski@samsung.com>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	<linux-media@vger.kernel.org>
Cc: "Kyungmin Park" <kyungmin.park@samsung.com>,
	"Pawel Osciak" <pawel@osciak.com>,
	"Jonathan Corbet" <corbet@lwn.net>,
	=?iso-8859-1?Q?Uwe_Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	"Hans Verkuil" <hverkuil@xs4all.nl>,
	"Marin Mitov" <mitov@issp.bas.bg>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Tomasz Stanislawski" <t.stanislaws@samsung.com>,
	"Sylwester Nawrocki" <s.nawrocki@samsung.com>,
	"Kamil Debski" <k.debski@samsung.com>,
	"Hans de Goede" <hdegoede@redhat.com>,
	"Paul Mundt" <lethal@linux-sh.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Marek

On Monday, August 29, 2011 7:58 PM, Marek Szyprowski wrote:

> 
> 
> This patch changes the order of operations during stream on call. Now the
> buffers are first queued to the driver and then the start_streaming method
> is called.
> 
> This resolves the most common case when the driver needs to know buffer
> addresses to enable dma engine and start streaming. Additional parameter
> to start_streaming method have been added to simplify drivers code. The
> driver are now obliged to check if the number of queued buffers is high
> enough to enable hardware streaming. If not - it can return an error. In
> such case all the buffers that have been pre-queued are invalidated.
> 
> This patch also updates all videobuf2 clients to work properly with the
> changed order of operations.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> CC: Hans Verkuil <hverkuil@xs4all.nl>
> CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
> CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
> CC: Kamil Debski <k.debski@samsung.com>
> CC: Jonathan Corbet <corbet@lwn.net>
> CC: Josh Wu <josh.wu@atmel.com>
> CC: Hans de Goede <hdegoede@redhat.com>
> CC: Paul Mundt <lethal@linux-sh.org>
> ---
> 
> Hello,
> 
> This is yet another version of the patch that introduces significant
> changes in the vb2 streamon operation. I've decided to remove the
> additional parameter to buf_queue callback and added a few cleanups here
> and there. This patch also includes an update for all vb2 clients.
> Please check if my change didn't break anything.
> 
> (I'm sorry for spamming, but previous version had wrong code for
> atmel-isi driver).
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 

For atmel-isi.c,
Tested-by: Josh Wu <josh.wu@atmel.com>

Best Regards,
Josh Wu

> 
> 
>  drivers/media/video/atmel-isi.c              |   20 ++++--
>  drivers/media/video/marvell-ccic/mcam-core.c |    6 +-
>  drivers/media/video/pwc/pwc-if.c             |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c  |   65 +++++++++++-------
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    2 +-
>  drivers/media/video/s5p-tv/mixer.h           |    2 -
>  drivers/media/video/s5p-tv/mixer_video.c     |   22 +++---
>  drivers/media/video/videobuf2-core.c         |   97 ++++++++++++--------------
>  drivers/media/video/vivi.c                   |    2 +-
>  include/media/videobuf2-core.h               |   17 ++++-
>  11 files changed, 131 insertions(+), 106 deletions(-)
> 
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> index 7e1d789..774715d 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -404,12 +404,13 @@ static void buffer_queue(struct vb2_buffer *vb)
>  
>  	if (isi->active == NULL) {
>  		isi->active = buf;
> -		start_dma(isi, buf);
> +		if (vb2_is_streaming(vb->vb2_queue))
> +			start_dma(isi, buf);
>  	}
>  	spin_unlock_irqrestore(&isi->lock, flags);
>  }
>  
> -static int start_streaming(struct vb2_queue *vq)
> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> @@ -431,17 +432,26 @@ static int start_streaming(struct vb2_queue *vq)
>  	ret = wait_event_interruptible(isi->vsync_wq,
>  				       isi->state != ISI_STATE_IDLE);
>  	if (ret)
> -		return ret;
> +		goto err;
>  
> -	if (isi->state != ISI_STATE_READY)
> -		return -EIO;
> +	if (isi->state != ISI_STATE_READY) {
> +		ret = -EIO;
> +		goto err;
> +	}
>  
>  	spin_lock_irq(&isi->lock);
>  	isi->state = ISI_STATE_WAIT_SOF;
>  	isi_writel(isi, ISI_INTDIS, ISI_SR_VSYNC);
> +	if (count)
> +		start_dma(isi, isi->active);
>  	spin_unlock_irq(&isi->lock);
>  
>  	return 0;
> +err:
> +	isi->active = NULL;
> +	isi->sequence = 0;
> +	INIT_LIST_HEAD(&isi->video_buffer_list);
> +	return ret;
>  }
>  
>  /* abort streaming and wait for last buffer */
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
> index 7abe503..1141b97 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -940,12 +940,14 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
>  /*
>   * These need to be called with the mutex held from vb2
>   */

> [snip]

>  struct vb2_ops {
>  	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> @@ -219,7 +228,7 @@ struct vb2_ops {
>  	int (*buf_finish)(struct vb2_buffer *vb);
>  	void (*buf_cleanup)(struct vb2_buffer *vb);
>  
> -	int (*start_streaming)(struct vb2_queue *q);
> +	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>  	int (*stop_streaming)(struct vb2_queue *q);
>  
>  	void (*buf_queue)(struct vb2_buffer *vb);
> -- 
> 1.7.1.569.g6f426
> 
>
