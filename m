Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:53984 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750866Ab1GOFWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 01:22:06 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Fri, 15 Jul 2011 07:21:23 +0200
Cc: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>
References: <201107032321.46092@orion.escape-edv.de> <201107150145.29547@orion.escape-edv.de> <4E1FBF93.6040702@redhat.com>
In-Reply-To: <4E1FBF93.6040702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107150721.25744@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 July 2011 06:18:27 Mauro Carvalho Chehab wrote:
> Em 14-07-2011 20:45, Oliver Endriss escreveu:
> > - DVB-T tuning does not work anymore.
> 
> The enclosed patch should fix the issue. It were due to a wrong goto error
> replacements that happened at the changeset that were fixing the error
> propagation logic. Sorry for that.
> 
> Please test.

Done. DVB-T works again. Thanks.

@all
Could someone please test DVB-C?

> [media] drxk: Fix a bug at some switches that broke DVB-T
>     
> The error propagation changeset c23bf4402 broke the DVB-T
> code, as it wrongly replaced some break with goto error.
> Fix the broken logic.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
> index a0e2ff5..217796d 100644
> --- a/drivers/media/dvb/frontends/drxk_hard.c
> +++ b/drivers/media/dvb/frontends/drxk_hard.c
> @@ -3451,13 +3451,13 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
>  		data |= ((echoThres->threshold <<
>  			OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
>  			& (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
> -		goto error;
> +		break;
>  	case DRX_FFTMODE_8K:
>  		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
>  		data |= ((echoThres->threshold <<
>  			OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
>  			& (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
> -		goto error;
> +		break;
>  	default:
>  		return -EINVAL;
>  		goto error;
		^^^^^^^^^^^
Hm, this 'goto' should be removed.

CU
Oliver


-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
