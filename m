Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39619 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbbBYOIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 09:08:42 -0500
Message-ID: <54EDD761.6060900@osg.samsung.com>
Date: Wed, 25 Feb 2015 07:08:33 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] xc5000: fix memory corruption when unplugging device
References: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2015 10:29 AM, Devin Heitmueller wrote:
> This patch addresses a regression introduced in the following patch:
> 
> commit 5264a522a597032c009f9143686ebf0fa4e244fb
> Author: Shuah Khan <shuahkh@osg.samsung.com>
> Date:   Mon Sep 22 21:30:46 2014 -0300
>     [media] media: tuner xc5000 - release firmwware from xc5000_release()
> 
> The "priv" struct is actually reference counted, so the xc5000_release()
> function gets called multiple times for hybrid devices.  Because
> release_firmware() was always being called, it would work fine as expected
> on the first call but then the second call would corrupt aribtrary memory.
> 
> Set the pointer to NULL after releasing so that we don't call
> release_firmware() twice.
> 
> This problem was detected in the HVR-950q where plugging/unplugging the
> device multiple times would intermittently show panics in completely
> unrelated areas of the kernel.

Thanks for finding and fixing the problem.

> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/tuners/xc5000.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index 40f9db6..74b2092 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -1314,7 +1314,10 @@ static int xc5000_release(struct dvb_frontend *fe)
>  
>  	if (priv) {
>  		cancel_delayed_work(&priv->timer_sleep);
> -		release_firmware(priv->firmware);

I would request you to add a comment here indicating the
hybrid case scenario to avoid any future cleanup type work
deciding there is no need to set priv->firmware to null
since priv gets released in hybrid_tuner_release_state(priv);


> +		if (priv->firmware) {
> +			release_firmware(priv->firmware);
> +			priv->firmware = NULL;
> +		}
>  		hybrid_tuner_release_state(priv);
>  	}
>  
> 

Adding Mauro as will to the thread. This should go into stable
as well.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
