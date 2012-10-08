Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47813 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2JHOuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 10:50:44 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Andrei Mandychev <andreymandychev@gmail.com>
CC: "Taneja, Archit" <archit@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrei Mandychev <andrei.mandychev@parrot.com>
Subject: RE: [PATCH] Fixed list_del corruption in videobuf-core.c :
 videobuf_queue_cancel()
Date: Mon, 8 Oct 2012 14:50:37 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB38F54@DBDE01.ent.ti.com>
References: <1349451865-26678-1-git-send-email-andrei.mandychev@parrot.com>
In-Reply-To: <1349451865-26678-1-git-send-email-andrei.mandychev@parrot.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 05, 2012 at 21:14:25, Andrei Mandychev wrote:
> If there is a buffer with VIDEOBUF_QUEUED state it won't be deleted properly
> because the head of queue loses its elements by calling INIT_LIST_HEAD()
> before videobuf_streamoff().

"dma_queue" is driver internal queue and videobuf_streamoff() function 
will end up into buf_release() callback, which in our case doesn't do 
anything with dmaqueue. 


Did you face any runtime issues with this? I still did not understand 
about this corruption thing.

Thanks,
Vaibhav
> ---
>  drivers/media/video/omap/omap_vout.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
> index 409da0f..f02eb8e 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -1738,8 +1738,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
>  		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in"
>  				" streamoff\n");
>  
> -	INIT_LIST_HEAD(&vout->dma_queue);
>  	ret = videobuf_streamoff(&vout->vbq);
> +	INIT_LIST_HEAD(&vout->dma_queue);
>  
>  	return ret;
>  }
> -- 
> 1.7.9.5
> 
> 

