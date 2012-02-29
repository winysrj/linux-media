Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:48966 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab2B2Ilp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 03:41:45 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id q1T8PoL4032285
	for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 09:25:50 +0100
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id q1T8PLiA018997
	for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 09:25:21 +0100
Message-ID: <4F4DE0F1.60407@tvdr.de>
Date: Wed, 29 Feb 2012 09:25:21 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] [PATCH 1/2] stb0899: set FE_HAS_SIGNAL flag in
 read_status
References: <4F4D1FA8.1090100@gmx.de>
In-Reply-To: <4F4D1FA8.1090100@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.02.2012 19:40, Andreas Regel wrote:
> In stb0899_read_status the FE_HAS_SIGNAL flag was not set in case of a
> successful carrier lock. This change fixes that.
>
> Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
> ---
>  drivers/media/dvb/frontends/stb0899_drv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
> index 38565be..4a58afc 100644
> --- a/drivers/media/dvb/frontends/stb0899_drv.c
> +++ b/drivers/media/dvb/frontends/stb0899_drv.c
> @@ -1071,7 +1071,7 @@ static int stb0899_read_status(struct dvb_frontend *fe, enum fe_status *status)
>              reg  = stb0899_read_reg(state, STB0899_VSTATUS);
>              if (STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg)) {
>                  dprintk(state->verbose, FE_DEBUG, 1, "--------> FE_HAS_CARRIER | FE_HAS_LOCK");
> -                *status |= FE_HAS_CARRIER | FE_HAS_LOCK;
> +                *status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
>                   reg = stb0899_read_reg(state, STB0899_PLPARM);
>                  if (STB0899_GETFIELD(VITCURPUN, reg)) {
> @@ -1088,7 +1088,7 @@ static int stb0899_read_status(struct dvb_frontend *fe, enum fe_status *status)
>          if (internal->lock) {
>              reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_STAT2);
>              if (STB0899_GETFIELD(UWP_LOCK, reg) && STB0899_GETFIELD(CSM_LOCK, reg)) {
> -                *status |= FE_HAS_CARRIER;
> +                *status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
>                  dprintk(state->verbose, FE_DEBUG, 1,
>                      "UWP & CSM Lock ! ---> DVB-S2 FE_HAS_CARRIER");

Acked-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
