Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57206 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab0BOSgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 13:36:24 -0500
Received: by bwz5 with SMTP id 5so1309013bwz.1
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 10:36:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
Date: Mon, 15 Feb 2010 13:36:21 -0500
Message-ID: <829197381002151036w2cbfa8f7t59fc097f9c692631@mail.gmail.com>
Subject: Re: [PATCH 01/11] xc2028: tm6000: bugfix firmware xc3028L-v36.fw used
	with Zarlink and DTV78 or DTV8 no shift
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: stefan.ringel@arcor.de
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2010 at 12:37 PM,  <stefan.ringel@arcor.de> wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
>
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>
> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
> index ed50168..e051caa 100644
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>
>        /* All S-code tables need a 200kHz shift */
>        if (priv->ctrl.demod) {
> -               demod = priv->ctrl.demod + 200;
> +               if ((priv->firm_version == 0x0306) &&
> +                       (priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
> +                               ((type & DTV78) || (type & DTV8)))
> +                       demod = priv->ctrl.demod;
> +               else
> +                       demod = priv->ctrl.demod + 200;
>                /*
>                 * The DTV7 S-code table needs a 700 kHz shift.
>                 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this

I would still like to better understand the origin of this change.
Was the tm6000 board not locking without it?  Was this change based on
any documented source?  What basis are you using when deciding this
issue is specific only to the zl10353 and not all boards using the
xc3028L?

We've got a number of boards already supported which use the xc3028L,
so we need to ensure there is no regression introduced in those boards
just to get yours working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
