Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m46DjkVD024621
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 09:45:46 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m46DjYWr006016
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 09:45:35 -0400
Date: Tue, 6 May 2008 15:45:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "hbmeier@hni.uni-paderborn.de" <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <365592.144287319-sendEmail@carolinen>
Message-ID: <Pine.LNX.4.64.0805061520250.5880@axis700.grange>
References: <365592.144287319-sendEmail@carolinen>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add x_skip_left to soc_camera_device
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

Hi Stefan,

The patch looks good in general, thanks, but

On Tue, 6 May 2008, hbmeier@hni.uni-paderborn.de wrote:

> Add x_skip_left to soc_camera_device and use it as "Beginning-of-Line
> Pixel Clock Wait Count" in pxa_camera driver
> 
> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
> ---
> diff -r ead7cbcb4e49 linux/drivers/media/video/mt9m001.c
> --- a/linux/drivers/media/video/mt9m001.c	Tue May 06 07:50:51 2008 -0300
> +++ b/linux/drivers/media/video/mt9m001.c	Tue May 06 13:56:27 2008 +0200
> @@ -649,18 +649,19 @@ static int mt9m001_probe(struct i2c_clie
>  
>  	/* Second stage probe - when a capture adapter is there */
>  	icd = &mt9m001->icd;
> -	icd->ops	= &mt9m001_ops;
> -	icd->control	= &client->dev;
> -	icd->x_min	= 20;
> -	icd->y_min	= 12;
> -	icd->x_current	= 20;
> -	icd->y_current	= 12;
> -	icd->width_min	= 48;
> -	icd->width_max	= 1280;
> -	icd->height_min	= 32;
> -	icd->height_max	= 1024;
> -	icd->y_skip_top	= 1;
> -	icd->iface	= icl->bus_id;
> +	icd->ops = &mt9m001_ops;
> +	icd->control = &client->dev;
> +	icd->x_min = 20;
> +	icd->y_min = 12;
> +	icd->x_current = 20;
> +	icd->y_current = 12;
> +	icd->width_min = 48;
> +	icd->width_max = 1280;
> +	icd->height_min = 32;
> +	icd->height_max = 1024;
> +	icd->x_skip_left = 0;
> +	icd->y_skip_top = 1;
> +	icd->iface = icl->bus_id;

hmmm... I did tell you

> > Use your esthetic feeling:-) But if it doesn't coincide with mine, I'll 
> > reject the patch:-))

and, I am sorry, it is really pretty far from mine, so...:-) But the main 
reason why I don't quite like it is, that you _needlessly_ modify 12 
lines. It is good to keep patches as small as possible, to simplify review 
and to reduce the chances for a mistake. You see, I can think of several 
ways to add this line to these two files (mt9m001 and mt9v022), e.g., just 
add it with one space at the end,

	icd->width_max	= 1280;
	icd->height_min	= 32;
	icd->height_max	= 1024;
	icd->y_skip_top	= 1;
+	icd->x_skip_left = 0;

Yes, alignment will be broken, but only on one line. Or add one more TAB. 
But I don't think your solution is the best. Actually, I think, we 
shouldn't add this line to these two files at all. icd is embedded in 
mt9m001 / mt9v022 structs, and they are allocated per kzalloc, so, already 
nullified. I would just leave these two files as they are.

> diff -r ead7cbcb4e49 linux/drivers/media/video/pxa_camera.c
> --- a/linux/drivers/media/video/pxa_camera.c	Tue May 06 07:50:51 2008 -0300
> +++ b/linux/drivers/media/video/pxa_camera.c	Tue May 06 13:51:28 2008 +0200
> @@ -883,7 +883,7 @@ static int pxa_camera_set_bus_param(stru
>  	}
>  
>  	CICR1 = cicr1;
> -	CICR2 = 0;
> +	CICR2 = CICR2_BLW_VAL(min((unsigned short)255, icd->x_skip_left));
>  	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
>  		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
>  	CICR4 = mclk_get_divisor(pcdev) | cicr4;
> diff -r ead7cbcb4e49 linux/include/media/soc_camera.h
> --- a/linux/include/media/soc_camera.h	Tue May 06 07:50:51 2008 -0300
> +++ b/linux/include/media/soc_camera.h	Tue May 06 13:51:28 2008 +0200
> @@ -29,6 +29,7 @@ struct soc_camera_device {
>  	unsigned short width_max;
>  	unsigned short height_min;
>  	unsigned short height_max;
> +	unsigned short x_skip_left;	/* Pixel to skip at the left */
>  	unsigned short y_skip_top;	/* Lines to skip at the top */
>  	unsigned short gain;
>  	unsigned short exposure;

I think, this is all we need for now - small and nice. Actually, it would 
make even more sense to submit this when your new camera driver is ready, 
but if you prefer, I'll accept it now. Just, please, resubmit it without 
the above two hunks, and, maybe, add a sentence to the patch comment, 
saying "will be used in xxx driver."

Sorry, and I promise, I'll accept the patch in proposed form, as long as 
it still applies and works at the time you submit it:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
