Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60296 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaK0SrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 13:47:09 -0500
Received: by mail-pd0-f181.google.com with SMTP id z10so5215022pdj.26
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 10:47:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ebd316f3f4f7cefa937562adba8ce60f2057ca9d.1417015567.git.mchehab@osg.samsung.com>
References: <ebd316f3f4f7cefa937562adba8ce60f2057ca9d.1417015567.git.mchehab@osg.samsung.com>
Date: Thu, 27 Nov 2014 13:47:09 -0500
Message-ID: <CAOcJUbwiDEvp3-c+j7B1L9MxFjnrw9mT0116C+Dy9p4hOQNEhg@mail.gmail.com>
Subject: Re: [PATCH] [media] tda18271: Fix identation
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:26 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> As reported by smatch:
>         drivers/media/tuners/tda18271-common.c:176 tda18271_read_extended() warn: if statement not indented
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
> index 86e5e3110118..6118203543ea 100644
> --- a/drivers/media/tuners/tda18271-common.c
> +++ b/drivers/media/tuners/tda18271-common.c
> @@ -173,12 +173,9 @@ int tda18271_read_extended(struct dvb_frontend *fe)
>
>         for (i = 0; i < TDA18271_NUM_REGS; i++) {
>                 /* don't update write-only registers */
> -               if ((i != R_EB9)  &&
> -                   (i != R_EB16) &&
> -                   (i != R_EB17) &&
> -                   (i != R_EB19) &&
> -                   (i != R_EB20))
> -               regs[i] = regdump[i];
> +               if ((i != R_EB9)  && (i != R_EB16) && (i != R_EB17) &&
> +                   (i != R_EB19) && (i != R_EB20))
> +                       regs[i] = regdump[i];
>         }
>
>         if (tda18271_debug & DBG_REG)
> --
> 1.9.3
>

Mauro,

I would actually rather NOT merge this patch.  This hurts the
readability of the code.  If applied already, please revert it.

Cheers,

Mike
