Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPLV4HZ004317
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 16:31:04 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAPLUxcV021597
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 16:31:00 -0500
Date: Tue, 25 Nov 2008 22:30:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0811252225200.10677@axis700.grange>
References: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add support for mt9m112 since sensors seem
 identical
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

On Tue, 25 Nov 2008, Mike Rapoport wrote:

> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/media/video/mt9m111.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index da0b2d5..49c1167 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -841,7 +841,8 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
>  	data = reg_read(CHIP_VERSION);
>  
>  	switch (data) {
> -	case 0x143a:
> +	case 0x143a: /* MT9M111 */
> +	case 0x148c: /* MT9M112 */
>  		mt9m111->model = V4L2_IDENT_MT9M111;

Wouldn't it be better to add a new chip ID? Are there any differences 
between the two models, that the user might want to know about?

Thanks
Guennadi

>  		icd->formats = mt9m111_colour_formats;
>  		icd->num_formats = ARRAY_SIZE(mt9m111_colour_formats);
> -- 
> 1.5.6.4
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
