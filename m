Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36814 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754476AbeEHKiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 06:38:46 -0400
Date: Tue, 8 May 2018 12:38:36 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][media-next] media: ddbridge: avoid out-of-bounds write
 on array demod_in_use
Message-ID: <20180508123836.0b5c2f7f@lt530>
In-Reply-To: <20180507230842.28409-1-colin.king@canonical.com>
References: <20180507230842.28409-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

Am Tue,  8 May 2018 00:08:42 +0100
schrieb Colin King <colin.king@canonical.com>:

> From: Colin Ian King <colin.king@canonical.com>
> 
> In function stop there is a check to see if state->demod is a stopped
> value of 0xff, however, later on, array demod_in_use is indexed with
> this value causing an out-of-bounds write error.  Avoid this by only
> writing to array demod_in_use if state->demod is not set to the stopped
> sentinal value for this specific corner case.  Also, replace the magic
> value 0xff with DEMOD_STOPPED to make code more readable.
> 
> Detected by CoverityScan, CID#1468550 ("Out-of-bounds write")
> 
> Fixes: daeeb1319e6f ("media: ddbridge: initial support for MCI-based MaxSX8 cards")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/pci/ddbridge/ddbridge-mci.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
> index a85ff3e6b919..1f5ed53c8d35 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-mci.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
> @@ -20,6 +20,8 @@
>  #include "ddbridge-io.h"
>  #include "ddbridge-mci.h"
>  
> +#define DEMOD_STOPPED	(0xff)
> +
>  static LIST_HEAD(mci_list);
>  
>  static const u32 MCLK = (1550000000 / 12);
> @@ -193,7 +195,7 @@ static int stop(struct dvb_frontend *fe)
>  	u32 input = state->tuner;
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	if (state->demod != 0xff) {
> +	if (state->demod != DEMOD_STOPPED) {
>  		cmd.command = MCI_CMD_STOP;
>  		cmd.demod = state->demod;
>  		mci_cmd(state, &cmd, NULL);
> @@ -209,10 +211,11 @@ static int stop(struct dvb_frontend *fe)
>  	state->base->tuner_use_count[input]--;
>  	if (!state->base->tuner_use_count[input])
>  		mci_set_tuner(fe, input, 0);
> -	state->base->demod_in_use[state->demod] = 0;
> +	if (state->demod != DEMOD_STOPPED)
> +		state->base->demod_in_use[state->demod] = 0;
>  	state->base->used_ldpc_bitrate[state->nr] = 0;
> -	state->demod = 0xff;
> -	state->base->assigned_demod[state->nr] = 0xff;
> +	state->demod = DEMOD_STOPPED;
> +	state->base->assigned_demod[state->nr] = DEMOD_STOPPED;
>  	state->base->iq_mode = 0;
>  	mutex_unlock(&state->base->tuner_lock);
>  	state->started = 0;

Thanks for the patch, or - better - pointing this out. While it's
unlikely this will ever be an issue, I'm fine with changing the code
like that, but I'd prefer to change it a bit differently (ie.
DEMOD_STOPPED should be DEMOD_UNUSED, and I'd add defines for max.
tuners and use/compare against them).

I'll send out a different patch that will cover the potential
coverityscan problem throughout the end of the week.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
