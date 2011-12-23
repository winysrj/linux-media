Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1LWKzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 05:55:22 -0500
Message-ID: <4EF45E0D.1080509@redhat.com>
Date: Fri, 23 Dec 2011 08:55:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi>
In-Reply-To: <4EF3A171.3030906@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22-12-2011 19:30, Antti Palosaari wrote:
> Rename DMB-TH to DTMB.

Patrick seems to believe that CTTB is a better name. In any case,
whatever name we pick, I think that the DocBook specs (and
maybe a comment at the header file) should point all the known
ways to call this standard. So, I'm fine with any choice.

> Add few new values for existing parameters.
> 
> Add two new parameters, interleaving and carrier.
> DTMB supports interleavers: 240 and 720.
> DTMB supports carriers: 1 and 3780.

The API change looks sane to my eyes. I have just a couple
comments below.

> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |   19 ++++++++++++++++++-
>  drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
>  include/linux/dvb/frontend.h              |   13 +++++++++++--
>  include/linux/dvb/version.h               |    2 +-
>  4 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 821b225..ec2cbae 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -924,6 +924,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>      _DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
>      _DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
>      _DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
> +    _DTV_CMD(DTV_CARRIER, 1, 0),
> +    _DTV_CMD(DTV_INTERLEAVING, 1, 0),
> 
>      _DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
>      _DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
> @@ -974,6 +976,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>      _DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>      _DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>      _DTV_CMD(DTV_HIERARCHY, 0, 0),
> +    _DTV_CMD(DTV_CARRIER, 0, 0),
> +    _DTV_CMD(DTV_INTERLEAVING, 0, 0),
> 
>      _DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
>  };
> @@ -1162,7 +1166,8 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
> 
>      /* Fake out a generic DVB-T request so we pass validation in the ioctl */
>      if ((c->delivery_system == SYS_ISDBT) ||
> -        (c->delivery_system == SYS_DVBT2)) {
> +        (c->delivery_system == SYS_DVBT2) ||
> +        (c->delivery_system == SYS_DTMB)) {
>          p->u.ofdm.constellation = QAM_AUTO;
>          p->u.ofdm.code_rate_HP = FEC_AUTO;
>          p->u.ofdm.code_rate_LP = FEC_AUTO;
> @@ -1378,6 +1383,12 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>      case DTV_DVBT2_PLP_ID:
>          tvp->u.data = c->dvbt2_plp_id;
>          break;
> +    case DTV_CARRIER:
> +        tvp->u.data = c->carrier;
> +        break;
> +    case DTV_INTERLEAVING:
> +        tvp->u.data = c->interleaving;
> +        break;
>      default:
>          return -EINVAL;
>      }
> @@ -1544,6 +1555,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>      case DTV_DVBT2_PLP_ID:
>          c->dvbt2_plp_id = tvp->u.data;
>          break;
> +    case DTV_CARRIER:
> +        c->carrier = tvp->u.data;
> +        break;
> +    case DTV_INTERLEAVING:
> +        c->interleaving = tvp->u.data;
> +        break;
>      default:
>          return -EINVAL;
>      }
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 67bbfa7..4979ffc 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -343,6 +343,9 @@ struct dtv_frontend_properties {
> 
>      fe_delivery_system_t    delivery_system;
> 
> +    u32            interleaving;
> +    u32            carrier;
> +
>      /* ISDB-T specifics */
>      u8            isdbt_partial_reception;
>      u8            isdbt_sb_mode;
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index cb114f5..2fa3bc5 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -152,6 +152,7 @@ typedef enum fe_code_rate {
>      FEC_AUTO,
>      FEC_3_5,
>      FEC_9_10,
> +    FEC_2_5,
>  } fe_code_rate_t;
> 
> 
> @@ -169,8 +170,11 @@ typedef enum fe_modulation {
>      APSK_16,
>      APSK_32,
>      DQPSK,
> +    QAM_4_NR,

While the NR is generally associated with the modulation,
this is a channel code, and not part of the modulation itself
(btw, the DVBv3 API calls it as "constellation").

Ok, it is easier to add it here, but maybe it would be safer
to add a separate field for channel coding that would be used
to enable or disable the Nordstrom-Robinson code.

This is currently used only with QAM-4, but nothing prevents this
parity code to be added to other types of modulation.

>  } fe_modulation_t;
> 
> +#define QAM_4 QPSK

IMHO, this is overkill, but I'm ok with that.

> +
>  typedef enum fe_transmit_mode {
>      TRANSMISSION_MODE_2K,
>      TRANSMISSION_MODE_8K,
> @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
>      GUARD_INTERVAL_1_128,
>      GUARD_INTERVAL_19_128,
>      GUARD_INTERVAL_19_256,
> +    GUARD_INTERVAL_PN420,
> +    GUARD_INTERVAL_PN595,
> +    GUARD_INTERVAL_PN945,
>  } fe_guard_interval_t;
> 
> 
> @@ -317,8 +324,10 @@ struct dvb_frontend_event {
>  #define DTV_DVBT2_PLP_ID    43
> 
>  #define DTV_ENUM_DELSYS        44
> +#define DTV_INTERLEAVING    45
> +#define DTV_CARRIER        46
> 
> -#define DTV_MAX_COMMAND                DTV_ENUM_DELSYS
> +#define DTV_MAX_COMMAND                DTV_CARRIER
> 
>  typedef enum fe_pilot {
>      PILOT_ON,
> @@ -349,7 +358,7 @@ typedef enum fe_delivery_system {
>      SYS_ISDBC,
>      SYS_ATSC,
>      SYS_ATSCMH,
> -    SYS_DMBTH,
> +    SYS_DTMB,
>      SYS_CMMB,
>      SYS_DAB,
>      SYS_DVBT2,
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> index 0559e2b..43d9e8d 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>  #define _DVBVERSION_H_
> 
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 5
> +#define DVB_API_VERSION_MINOR 6
> 
>  #endif /*_DVBVERSION_H_*/

