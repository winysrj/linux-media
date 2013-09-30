Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3I3JTi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 05:19:38 -0400
Date: Mon, 30 Sep 2013 11:22:07 +0200
Message-ID: <s5h1u467jgg.wl%tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
	linux-i2c@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 6/8] ALSA: ppc: keywest: Don't use i2c_client->driver
In-Reply-To: <1380444666-12019-7-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
	<1380444666-12019-7-git-send-email-lars@metafoo.de>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At Sun, 29 Sep 2013 10:51:04 +0200,
Lars-Peter Clausen wrote:
> 
> The 'driver' field of the i2c_client struct is redundant and is going to be
> removed. Use 'to_i2c_driver(client->dev.driver)' instead to get direct
> access to the i2c_driver struct.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

> ---
>  sound/ppc/keywest.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
> index 01aecc2..0d1c27e 100644
> --- a/sound/ppc/keywest.c
> +++ b/sound/ppc/keywest.c
> @@ -65,7 +65,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
>  	 * already bound. If not it means binding failed, and then there
>  	 * is no point in keeping the device instantiated.
>  	 */
> -	if (!keywest_ctx->client->driver) {
> +	if (!keywest_ctx->client->dev.driver) {
>  		i2c_unregister_device(keywest_ctx->client);
>  		keywest_ctx->client = NULL;
>  		return -ENODEV;
> @@ -76,7 +76,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
>  	 * This is safe because i2c-core holds the core_lock mutex for us.
>  	 */
>  	list_add_tail(&keywest_ctx->client->detected,
> -		      &keywest_ctx->client->driver->clients);
> +		      &to_i2c_driver(keywest_ctx->client->dev.driver)->clients);
>  	return 0;
>  }
>  
> -- 
> 1.8.0
> 
