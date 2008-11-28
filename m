Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASGiEwt021689
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 11:44:14 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mASGi1Zr019757
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 11:44:02 -0500
Date: Fri, 28 Nov 2008 17:44:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uljvhtzst.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0811281707440.4430@axis700.grange>
References: <uljvhtzst.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Add ov7725 ov7720 support to ov772x driver
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

Hi,

sorry it took me a while to find some time to look at this patch. In 
principle it looks ok, just a couple of notes / questions:

(also Mauro): I am not sure if this is ok to submit a change to 
include/media/v4l2-chip-ident.h in this patch, i.e., if I may pull it via 
my tree. Mauro? Or shall it be submitted separately and _after_ it is 
applied we can also push the main part of the patch? Here's the hunk I'm 
talking about:

> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index bfe5142..14a205f 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -60,7 +60,8 @@ enum {
>  
>  	/* OmniVision sensors: reserved range 250-299 */
>  	V4L2_IDENT_OV7670 = 250,
> -	V4L2_IDENT_OV772X = 251,
> +	V4L2_IDENT_OV7720 = 251,
> +	V4L2_IDENT_OV7725 = 252,
>  
>  	/* Conexant MPEG encoder/decoders: reserved range 410-420 */
>  	V4L2_IDENT_CX23415 = 415,

Now the only question / suggestion I have to this patch:

On Tue, 18 Nov 2008, Kuninori Morimoto wrote:

> @@ -837,15 +859,16 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	 */
>  	pid = i2c_smbus_read_byte_data(priv->client, PID);
>  	ver = i2c_smbus_read_byte_data(priv->client, VER);
> -	if (pid != 0x77 ||
> -	    ver != 0x21) {
> +	if (pid != GET_PID(priv->id->driver_data) ||
> +	    ver != GET_VER(priv->id->driver_data)) {
>  		dev_err(&icd->dev,
>  			"Product ID error %x:%x\n", pid, ver);
>  		return -ENODEV;
>  	}

this means, you can indeed probe the exact type of the camera - 7720 vs. 
7725, right? Then why do you require the platform code to also specify 
exactly which camera is connected? Why don't you leave the platform code 
at the old requirement, i.e., it should just register an i2c device of 
type "ov772x" and then detect yourself what exactly sensor is there? This 
is what I've done in mt9m001 and mt9v022. They both support several sensor 
variants too. This way you can use one kernel for all compatible cameras. 
If there is no real reason not to do the same in ov772x, I would suggest 
you switch it over to autoprobing.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
