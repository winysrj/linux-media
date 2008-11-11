Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABMaWPh007102
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:36:32 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABMaJQx022997
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:36:20 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1L01qO-0002hP-Vb
	for video4linux-list@redhat.com; Tue, 11 Nov 2008 23:36:20 +0100
Date: Tue, 11 Nov 2008 23:36:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811101333030.4248@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811112334320.8435@axis700.grange>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101333030.4248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Moderators: please act (was Re: [PATCH 3/5] soc-camera: add a
 per-camera...)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This message "awaits moderator approval" since 34 hours already, can it be 
posted, please?

Thanks
Guennadi

On Mon, 10 Nov 2008, Guennadi Liakhovetski wrote:

> This pointer will be used by pxa_camera.c to point to its pixel format 
> data.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/media/soc_camera.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 9c3734c..a63f7fb 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -42,6 +42,7 @@ struct soc_camera_device {
>  	const struct soc_camera_data_format *formats;
>  	int num_formats;
>  	struct module *owner;
> +	void *host_priv;		/* per-device host private data */
>  	/* soc_camera.c private count. Only accessed with video_lock held */
>  	int use_count;
>  };
> -- 
> 1.5.4
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
