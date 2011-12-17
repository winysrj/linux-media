Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:46124 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750884Ab1LQXkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 18:40:13 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linuxtv@stefanringel.de
Subject: Re: [PATCH 2/3] drxk: correction frontend attatching
Date: Sun, 18 Dec 2011 00:39:49 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de> <1324155437-15834-2-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1324155437-15834-2-git-send-email-linuxtv@stefanringel.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201112180039.50208@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 17 December 2011 21:57:16 linuxtv@stefanringel.de wrote:
> From: Stefan Ringel <linuxtv@stefanringel.de>
> 
> all drxk have dvb-t, but not dvb-c.
> 
> Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
> ---
>  drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
> index 038e470..8a59801 100644
> --- a/drivers/media/dvb/frontends/drxk_hard.c
> +++ b/drivers/media/dvb/frontends/drxk_hard.c
> @@ -6460,9 +6460,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
>  	init_state(state);
>  	if (init_drxk(state) < 0)
>  		goto error;
> -	*fe_t = &state->t_frontend;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  
> -	return &state->c_frontend;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^
> +	if (state->m_hasDVBC)
> +		*fe_t = &state->c_frontend;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +	return &state->t_frontend;
               ^^^^^^^^^^^^^^^^^^^     
>  
>  error:
>  	printk(KERN_ERR "drxk: not found\n");

NAK, this changes the behaviour for existing drivers.

What is the point to swap DVB-T and DVB-C frontends?
If you really need this, please add an option to the config struct
with default that does not change anything for existing drivers.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
