Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab2LWNoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 08:44:38 -0500
Date: Sun, 23 Dec 2012 11:44:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
Message-ID: <20121223114413.6d2c7dc1@redhat.com>
In-Reply-To: <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
	<1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

Em Thu,  8 Nov 2012 20:11:53 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> By default, isoc transfers are used if possible.
> With the new module parameter, bulk can be selected as the
> preferred USB transfer type.

I did some tests yesterday with prefer_bulk. IMHO, webcams should
select bulk mode by default, as this allows more than one camera to
work at the same time (I tested yesterday with 3 Silvercrest ones on
my notebook). With ISOC transfers, the core won't let it to happen, as
a single camera reserves 51% of the max allowed isoc traffic.

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |   11 +++++++++--
>  1 Datei geändert, 9 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index a9344f0..7f5b303 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -61,6 +61,11 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>  module_param_array(card,  int, NULL, 0444);
>  MODULE_PARM_DESC(card,     "card type");
>  
> +static unsigned int prefer_bulk;
> +module_param(prefer_bulk, int, 0644);

This needs to be changed to 0444, as prefer_bulk doesn't allow changing
it dynamically, as the test is done during device probe, not at stream on.

Regards,
Mauro
