Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49887 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab1KQKG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:06:57 -0500
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9554F94042B
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 11:06:48 +0100 (CET)
Date: Thu, 17 Nov 2011 11:07:16 +0100
From: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: Cleanup proposal for media/gspca
Message-ID: <20111117110716.6343d46c@tele>
In-Reply-To: <CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
References: <20111116013445.GA5273@localhost>
	<CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 Nov 2011 15:19:04 -0300
Ezequiel García <elezegarcia@gmail.com> wrote:

> In 'media/video/gspca/gspca.c' I really hated this cast (maybe because
> I am too dumb to understand it):
> 
>   gspca_dev = (struct gspca_dev *) video_devdata(file);
> 
> wich is only legal because a struct video_device is the first member
> of gspca_dev. IMHO, this is 'unnecesary obfuscation'.
> The thing is the driver is surely working fine and there is no good
> reasong for the change.
> 
> Is it ok to submit a patchset to change this? Something like this:
> 
> diff --git a/drivers/media/video/gspca/gspca.c
> b/drivers/media/video/gspca/gspca.c
> index 881e04c..5d962ce 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
>  static int dev_open(struct file *file)
>  {
>  	struct gspca_dev *gspca_dev;
> +	struct video_device *vdev;
> 
>  	PDEBUG(D_STREAM, "[%s] open", current->comm);
> -	gspca_dev = (struct gspca_dev *) video_devdata(file);
> +	vdev = video_devdata(file);
> +	gspca_dev = video_get_drvdata(vdev);
>  	if (!gspca_dev->present)

Hi Ezequiel,

You are right, the cast is not a good way (and there are a lot of them
in the gspca subdrivers), but your patch does not work because the
'private_data' of the device is not initialized (there is no call to
video_set_drvdata).

So, a possible cleanup could be:

> -	gspca_dev = (struct gspca_dev *) video_devdata(file);
> +	gspca_dev = container_of(video_devdata(file), struct gspca_dev, vdev);

Is it OK for you?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
