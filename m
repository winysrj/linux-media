Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab0BCUW7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:22:59 -0500
Message-ID: <4B69DB19.7070201@redhat.com>
Date: Wed, 03 Feb 2010 18:22:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 3/15] -  tm6000 bugfix hunk in init_dev
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de> <4B69D950.2090504@arcor.de>
In-Reply-To: <4B69D950.2090504@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is too generic:

 tm6000 bugfix hunk in init_dev

A better subject would be:

[PATCH 3/15] tm6000: avoid unregister the driver after success at tm6000_init_dev

PS.: don't mind to re-submit those patches where just the subject has troubles.
I'll fix it locally. I'm pointing the issues to save me some time on your next
patcheset submission ;)

For the patchsets that you forgot to sign (1/15 for example), just reply your own
email with Signed-off-by:.

Cheers,
Mauro 


Stefan Ringel wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> 
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -402,6 +448,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
>          }
>  #endif
>      }
> +    return 0;
>  
>  err2:
>      v4l2_device_unregister(&dev->v4l2_dev);
> 
