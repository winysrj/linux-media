Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772Ab0BCURG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:17:06 -0500
Message-ID: <4B69D9B8.7020306@redhat.com>
Date: Wed, 03 Feb 2010 18:16:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 1/15] -  tm6000 build hunk
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>
In-Reply-To: <4B69D83D.5050809@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:

OK, patch is correct, but you should:

- Use the email subject to summarize what the patch does
- Add more detailed patch description;
- Add your Signed-off-by.

In this specific case, you could have:

Subject: Fix compilation breakage

Signed-off-by: your name <your@email>

(this is a really trivial patch - so, you don't need a detailed description)

> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -32,7 +32,7 @@
>  #include "tm6000.h"
>  #include "tm6000-regs.h"
>  #include "tuner-xc2028.h"
> -#include "tuner-xc5000.h"
> +#include "xc5000.h"
>  
>  #define TM6000_BOARD_UNKNOWN            0
>  #define TM5600_BOARD_GENERIC            1
> 


-- 

Cheers,
Mauro
