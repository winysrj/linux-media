Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:62174 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756513AbcJHL5x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Oct 2016 07:57:53 -0400
Message-ID: <57F8DF3C.70208@bfs.de>
Date: Sat, 08 Oct 2016 13:57:48 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>
CC: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] [media] dvb-tc90522: Rename a jump label in tc90522_probe()
References: <566ABCD9.1060404@users.sourceforge.net> <906cc86f-bac0-fd47-8a6f-d3310b10fd08@users.sourceforge.net> <7cee472f-4dad-7306-ed14-098bef5f862c@users.sourceforge.net>
In-Reply-To: <7cee472f-4dad-7306-ed14-098bef5f862c@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 07.10.2016 21:46, schrieb SF Markus Elfring:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 7 Oct 2016 21:13:57 +0200
> 
> Adjust a jump label according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/dvb-frontends/tc90522.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> index c2d45f0..4687e15 100644
> --- a/drivers/media/dvb-frontends/tc90522.c
> +++ b/drivers/media/dvb-frontends/tc90522.c
> @@ -794,14 +794,13 @@ static int tc90522_probe(struct i2c_client *client,
>  	i2c_set_adapdata(adap, state);
>  	ret = i2c_add_adapter(adap);
>  	if (ret < 0)
> -		goto err;
> +		goto free_state;
>  	cfg->tuner_i2c = state->cfg.tuner_i2c = adap;
>  
>  	i2c_set_clientdata(client, &state->cfg);
>  	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
>  	return 0;
> -
> -err:
> +free_state:
>  	kfree(state);
>  	return ret;
>  }

there is only one user, IMHO this can be moved to the if block.

re,
 wh
