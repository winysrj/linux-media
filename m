Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44494 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab0JFSfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 14:35:13 -0400
Date: Wed, 6 Oct 2010 20:35:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-ID: <20101006203553.22edfeb7@tele>
In-Reply-To: <20101006160441.6ee9583d.ospite@studenti.unina.it>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 6 Oct 2010 16:04:41 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Thanks, the following change fixes it, was this what you had in mind?
> 
> diff --git a/drivers/media/video/gspca/gspca.c
> b/drivers/media/video/gspca/gspca.c index b984610..30e0b32 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -651,7 +651,7 @@ static struct usb_host_endpoint *get_ep(struct
> gspca_dev *gspca_dev) : USB_ENDPOINT_XFER_ISOC;
>         i = gspca_dev->alt;                     /* previous alt
> setting */ if (gspca_dev->cam.reverse_alts) {
> -               if (gspca_dev->audio)
> +               if (gspca_dev->audio && !gspca_dev->cam.bulk)
>                         i++;
>                 while (++i < gspca_dev->nbalt) {
>                         ep = alt_xfer(&intf->altsetting[i], xfer);
> @@ -659,7 +659,7 @@ static struct usb_host_endpoint *get_ep(struct
> gspca_dev *gspca_dev) break;
>                 }
>         } else {
> -               if (gspca_dev->audio)
> +               if (gspca_dev->audio && !gspca_dev->cam.bulk)
>                         i--;
>                 while (--i >= 0) {
>                         ep = alt_xfer(&intf->altsetting[i], xfer);

Yes, but, after thought, as there is only one alternate setting, the
tests could be:
	if (gspca_dev->audio && i < gspca_dev->nbalt - 1)
and
	if (gspca_dev->audio && i > 0)

This should work also for isochronous transfers.

regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
