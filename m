Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab0BCIas (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 03:30:48 -0500
Message-ID: <4B693432.4040101@infradead.org>
Date: Wed, 03 Feb 2010 06:30:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: julia@diku.dk, "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: akpm@linux-foundation.org, linux-media@vger.kernel.org
Subject: Re: [patch 1/7] drivers/media/video: move dereference after NULL
 test
References: <201002022240.o12Mekvr018902@imap1.linux-foundation.org>
In-Reply-To: <201002022240.o12Mekvr018902@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

> From: Julia Lawall <julia@diku.dk>
 

> diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
> --- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test
> +++ a/drivers/media/video/davinci/vpif_display.c
> @@ -383,8 +383,6 @@ static int vpif_get_std_info(struct chan
>  	int index;
>  
>  	std_info->stdid = vid_ch->stdid;
> -	if (!std_info)
> -		return -1;
>  
>  	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
>  		config = &ch_params[index];

IMO, the better would be to move the if to happen before the usage of std_info, and make it return 
a proper error code, instead of -1.

Murali,
Any comments?

> diff -puN drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/saa7134/saa7134-alsa.c
> --- a/drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test
> +++ a/drivers/media/video/saa7134/saa7134-alsa.c
> @@ -1011,8 +1011,6 @@ static int snd_card_saa7134_new_mixer(sn
>  	unsigned int idx;
>  	int err, addr;
>  
> -	if (snd_BUG_ON(!chip))
> -		return -EINVAL;
>  	strcpy(card->mixername, "SAA7134 Mixer");

The better here is to keep the BUG_ON and moving this initialization:
        struct snd_card *card = chip->card;

to happen after the test.

>  
>  	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
> diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/usbvideo/quickcam_messenger.c
> --- a/drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test
> +++ a/drivers/media/video/usbvideo/quickcam_messenger.c
> @@ -692,12 +692,13 @@ static int qcm_start_data(struct uvd *uv
>  
>  static void qcm_stop_data(struct uvd *uvd)
>  {
> -	struct qcm *cam = (struct qcm *) uvd->user_data;
> +	struct qcm *cam;
>  	int i, j;
>  	int ret;
>  
>  	if ((uvd == NULL) || (!uvd->streaming) || (uvd->dev == NULL))
>  		return;
> +	cam = (struct qcm *) uvd->user_data;
>  
>  	ret = qcm_camera_off(uvd);
>  	if (ret)

OK.

Cheers,
Mauro
