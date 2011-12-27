Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:42748 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1L0MLz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 07:11:55 -0500
Message-ID: <4EF9B606.3090908@linuxtv.org>
Date: Tue, 27 Dec 2011 13:11:50 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 01/91] [media] dvb-core: allow demods to specify the
 supported delivery systems supported standards.
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-2-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.12.2011 02:07, Mauro Carvalho Chehab wrote:
> DVB-S and DVB-T, as those were the standards supported by DVBv3.

The description seems to be incomplete.

> New standards like DSS, ISDB and CTTB don't fit on any of the
> above types.
> 
> while there's a way for the drivers to explicitly change whatever
> default DELSYS were filled inside the core, still a fake value is
> needed there, and a "compat" code to allow DVBv3 applications to
> work with those delivery systems is needed. This is good for a
> short term solution, while applications aren't using DVBv5 directly.
> 
> However, at long term, this is bad, as the compat code runs even
> if the application is using DVBv5. Also, the compat code is not
> perfect, and only works when the frontend is capable of auto-detecting
> the parameters that aren't visible by the faked delivery systems.
> 
> So, let the frontend fill the supported delivery systems at the
> device properties directly, and, in the future, let the core to use
> the delsys to fill the reported info::type based on the delsys.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++++++++++
>  drivers/media/dvb/dvb-core/dvb_frontend.h |    8 ++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 8dedff4..f17c411 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1252,6 +1252,19 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
>  	const struct dvb_frontend_info *info = &fe->ops.info;
>  	u32 ncaps = 0;
>  
> +	/*
> +	 * If the frontend explicitly sets a list, use it, instead of
> +	 * filling based on the info->type
> +	 */
> +	if (fe->ops.delsys[ncaps]) {
> +		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
> +			p->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
> +			ncaps++;
> +		}
> +		p->u.buffer.len = ncaps;
> +		return;
> +	}
> +

I don't understand what this is trying to solve. This is already handled
by the get_property driver callback.

dtv_set_default_delivery_caps() only sets some defaults for drivers not
implementing get_property yet.
