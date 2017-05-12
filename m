Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38217 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdELI7m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 04:59:42 -0400
Subject: Re: [PATCH] staging: media: cxd2099: Use __func__ macro in messages
To: gregkh@linuxfoundation.org
References: <1494332833-6918-1-git-send-email-alex@ghiti.fr>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Alex Ghiti <alex@ghiti.fr>
Message-ID: <8f88b7c5-a8f0-fab4-0754-df23727ce97c@ghiti.fr>
Date: Fri, 12 May 2017 10:59:11 +0200
MIME-Version: 1.0
In-Reply-To: <1494332833-6918-1-git-send-email-alex@ghiti.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch should be dropped as Jasmin is updating this driver.

Thanks,

On 05/09/2017 02:27 PM, Alexandre Ghiti wrote:
> Replace hardcoded function names in print info with __func__.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  drivers/staging/media/cxd2099/cxd2099.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> index 18186d0..370ecb9 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.c
> +++ b/drivers/staging/media/cxd2099/cxd2099.c
> @@ -473,7 +473,7 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
>  {
>  	struct cxd *ci = ca->data;
>
> -	dev_info(&ci->i2c->dev, "slot_shutdown\n");
> +	dev_info(&ci->i2c->dev, "%s\n", __func__);
>  	mutex_lock(&ci->lock);
>  	write_regm(ci, 0x09, 0x08, 0x08);
>  	write_regm(ci, 0x20, 0x80, 0x80); /* Reset CAM Mode */
> @@ -564,7 +564,7 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
>  	campoll(ci);
>  	mutex_unlock(&ci->lock);
>
> -	dev_info(&ci->i2c->dev, "read_data\n");
> +	dev_info(&ci->i2c->dev, "%s\n", __func__);
>  	if (!ci->dr)
>  		return 0;
>
> @@ -584,7 +584,7 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
>  	struct cxd *ci = ca->data;
>
>  	mutex_lock(&ci->lock);
> -	dev_info(&ci->i2c->dev, "write_data %d\n", ecount);
> +	dev_info(&ci->i2c->dev, "%s %d\n", __func__, ecount);
>  	write_reg(ci, 0x0d, ecount >> 8);
>  	write_reg(ci, 0x0e, ecount & 0xff);
>  	write_block(ci, 0x11, ebuf, ecount);
>
