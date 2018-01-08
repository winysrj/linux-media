Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60480 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754909AbeAHUe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 15:34:59 -0500
Subject: Re: [PATCH 2/2] lgdt3306a: Fix a double kfree on i2c device remove
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
 <1515164233-2423-3-git-send-email-brad@nextdimension.cc>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <86509eed-b1c3-f7d4-9281-47e072fb7232@gentoo.org>
Date: Mon, 8 Jan 2018 21:34:14 +0100
MIME-Version: 1.0
In-Reply-To: <1515164233-2423-3-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2018 um 15:57 schrieb Brad Love:
> Both lgdt33606a_release and lgdt3306a_remove kfree state, but _release is
> called first, then _remove operates on states members before kfree'ing it.
> This can lead to random oops/GPF/etc on USB disconnect.
> 
lgdt3306a_release does nothing but the kfree. So the exact same effect
can be archived by setting state->frontend.ops.release to NULL. This
need to be done already at probe time I think.
lgdt3306a_remove does this, but too late (after the call to release).

Regards
Matthias

> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  drivers/media/dvb-frontends/lgdt3306a.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
> index d370671..3642e6e 100644
> --- a/drivers/media/dvb-frontends/lgdt3306a.c
> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
> @@ -1768,7 +1768,13 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
>  	struct lgdt3306a_state *state = fe->demodulator_priv;
>  
>  	dbg_info("\n");
> -	kfree(state);
> +
> +	/*
> +	 * If state->muxc is not NULL, then we are an i2c device
> +	 * and lgdt3306a_remove will clean up state
> +	 */
> +	if (!state->muxc)
> +		kfree(state);
>  }
>  
>  static const struct dvb_frontend_ops lgdt3306a_ops;
> 
