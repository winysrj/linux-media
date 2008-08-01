Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71NSHpS027943
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 19:28:17 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m71NS5XN019927
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 19:28:05 -0400
Date: Sat, 2 Aug 2008 01:28:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0808020127410.14927@axis700.grange>
References: <87tze4cr3g.fsf@free.fr>
	<1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add suspend/resume capabilities to soc_camera.
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

On Sat, 2 Aug 2008, Robert Jarzmik wrote:

> Add suspend/resume hooks to call soc operation specific
> suspend and resume functions. This ensures the camera
> chip has been previously resumed, as well as the camera
> bus.
> These hooks in camera chip drivers should save/restore
> chip context between suspend and resume time.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Applied, thanks
Guennadi

> ---
>  drivers/media/video/soc_camera.c |   26 ++++++++++++++++++++++++++
>  include/media/soc_camera.h       |    5 +++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index a1b9244..dc85182 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -751,10 +751,36 @@ static int soc_camera_remove(struct device *dev)
>  	return 0;
>  }
>  
> +static int soc_camera_suspend(struct device *dev, pm_message_t state)
> +{
> +	struct soc_camera_device *icd = to_soc_camera_dev(dev);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	int ret = 0;
> +
> +	if (ici->ops->suspend)
> +		ret = ici->ops->suspend(icd, state);
> +
> +	return ret;
> +}
> +
> +static int soc_camera_resume(struct device *dev)
> +{
> +	struct soc_camera_device *icd = to_soc_camera_dev(dev);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	int ret = 0;
> +
> +	if (ici->ops->resume)
> +		ret = ici->ops->resume(icd);
> +
> +	return ret;
> +}
> +
>  static struct bus_type soc_camera_bus_type = {
>  	.name		= "soc-camera",
>  	.probe		= soc_camera_probe,
>  	.remove		= soc_camera_remove,
> +	.suspend	= soc_camera_suspend,
> +	.resume		= soc_camera_resume,
>  };
>  
>  static struct device_driver ic_drv = {
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 6a8c8be..1984427 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/videodev2.h>
>  #include <media/videobuf-dma-sg.h>
> +#include <linux/pm.h>
>  
>  struct soc_camera_device {
>  	struct list_head list;
> @@ -66,6 +67,8 @@ struct soc_camera_host_ops {
>  	struct module *owner;
>  	int (*add)(struct soc_camera_device *);
>  	void (*remove)(struct soc_camera_device *);
> +	int (*suspend)(struct soc_camera_device *, pm_message_t state);
> +	int (*resume)(struct soc_camera_device *);
>  	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
>  			   struct v4l2_rect *);
>  	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
> @@ -114,6 +117,8 @@ struct soc_camera_ops {
>  	struct module *owner;
>  	int (*probe)(struct soc_camera_device *);
>  	void (*remove)(struct soc_camera_device *);
> +	int (*suspend)(struct soc_camera_device *, pm_message_t state);
> +	int (*resume)(struct soc_camera_device *);
>  	int (*init)(struct soc_camera_device *);
>  	int (*release)(struct soc_camera_device *);
>  	int (*start_capture)(struct soc_camera_device *);
> -- 
> 1.5.5.3
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
