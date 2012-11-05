Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45620 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab2KEWa4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 17:30:56 -0500
Message-ID: <50983E03.6090709@iki.fi>
Date: Tue, 06 Nov 2012 00:30:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 57/68] [media] anysee: fix a warning
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com> <1351370486-29040-58-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-58-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/27/2012 11:41 PM, Mauro Carvalho Chehab wrote:
> drivers/media/usb/dvb-usb-v2/anysee.c:1179:5: warning: 'tmp' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> Cc: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   drivers/media/usb/dvb-usb-v2/anysee.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
> index e78ca8f..d05c5b5 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> @@ -1170,7 +1170,7 @@ static int anysee_ci_poll_slot_status(struct dvb_ca_en50221 *ci, int slot,
>   	struct dvb_usb_device *d = ci->data;
>   	struct anysee_state *state = d_to_priv(d);
>   	int ret;
> -	u8 tmp;
> +	u8 tmp = 0;
>
>   	ret = anysee_rd_reg_mask(d, REG_IOC, &tmp, 0x40);
>   	if (ret)
>

That is another one I have looked multiple times - you are even asked to 
look once few months back. I don't see how it could take that branch. 
Maybe uninitialized_var() is a little bit cheaper?

Anyway, I am OK with that too.

regards
Antti

-- 
http://palosaari.fi/
