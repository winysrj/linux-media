Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:61622 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdJDGVC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 02:21:02 -0400
Subject: Re: [PATCH 3/4] staging: bcm2835-camera: pr_err() strings should end
 with newlines
To: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        gregkh@linuxfoundation.org, jacobvonchorus@cwphoto.ca,
        mchehab@kernel.org, eric@anholt.net, f.fainelli@gmail.com,
        rjui@broadcom.com, Larry.Finger@lwfinger.net, pkshih@realtek.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1507031006-16543-1-git-send-email-arvind.yadav.cs@gmail.com>
 <1507031006-16543-4-git-send-email-arvind.yadav.cs@gmail.com>
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <9a3f3098-4886-67a4-c728-2c5e450ecc5f@i2se.com>
Date: Wed, 4 Oct 2017 08:20:40 +0200
MIME-Version: 1.0
In-Reply-To: <1507031006-16543-4-git-send-email-arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.10.2017 um 13:43 schrieb Arvind Yadav:
> pr_err() messages should end with a new-line to avoid other messages
> being concatenated.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Stefan Wahren <stefan.wahren@i2se.com>

> ---
>  drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
> index 4360db6..6ea7fb0 100644
> --- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
> +++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
> @@ -1963,7 +1963,7 @@ int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance)
>  
>  	status = vchi_service_close(instance->handle);
>  	if (status != 0)
> -		pr_err("mmal-vchiq: VCHIQ close failed");
> +		pr_err("mmal-vchiq: VCHIQ close failed\n");
>  
>  	mutex_unlock(&instance->vchiq_mutex);
>  
