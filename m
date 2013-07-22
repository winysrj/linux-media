Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:38841 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3GVLb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 07:31:59 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00FHT4WIZ100@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Jul 2013 07:21:57 -0400 (EDT)
Date: Mon, 22 Jul 2013 08:21:52 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Proposed modifications to dvb_frontend_ops
Message-id: <20130722082152.11e2d960@samsung.com>
In-reply-to: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

Em Fri, 19 Jul 2013 14:27:09 -0600
Chris Lee <updatelee@gmail.com> escreveu:

> In frontend.h we have a struct called dvb_frontend_ops, in there we
> have an element called delsys to show the delivery systems supported
> by the tuner, Id like to propose we add onto that with delmod and
> delfec.
> 
> Its not a perfect solution as sometimes a specific modulation or fec
> is only availible on specific systems. But its better then what we
> have now. The struct fe_caps isnt really suited for this, its missing
> many systems, modulations, and fec's. Its just not expandable enough
> to get all the supported sys/mod/fec a tuner supports in there.
> 
> Expanding this would allow user land applications to poll the tuner to
> determine more detailed information on the tuners capabilities.
> 
> Here is the patch I propose, along with the au8522 driver modified to
> utilize the new elements. Id like to hear comments on it. Does anyone
> see a better way of doing this ?

We had a discussion some time ago about it. Basically, a device that
it is said to support, let's say, DVB-T, should support all possible
modulations and FECs that are part of the system.

So, in thesis, there shouldn't be any need to add a list of modulations
and FECs.

Also, frontends that support multiple delivery systems would need
to enumerate the modulations and FECs after the selection of a given
delivery system (as, typically, they only support a subset of them
for each delsys).

Ok, practice is different, as there are reverse-engineered drivers
that may not support everything that the hardware supports. Also,
a few hardware may have additional restrictions.

Yet, on those cases, the userspace may detect if a given modulation
type or FEC is supported, by trying to set it and check if the
operation didn't fail, and if the cache got properly updated.

So, at the end, it was decided to not add anything like that.

Yet, it is good to see other opinions.

It should be said that one of the hard parts of an approach like
that, is that someone would need to dig into each driver and add
the proper support for per-delsys modulation and FECs.

Alternatively, the core could initialize it to the default value
for each standard, and call some driver-specific function that
would reset the modulation/FECs that aren't supported by some
specific drivers.

Regards,
Mauro

> 
> Chris Lee <updatelee@gmail.com>
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c
> b/drivers/media/dvb-core/dvb_frontend.c
> index 1f925e8..f5df08e 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1036,6 +1036,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>   _DTV_CMD(DTV_API_VERSION, 0, 0),
> 
>   _DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
> + _DTV_CMD(DTV_ENUM_DELMOD, 0, 0),
> + _DTV_CMD(DTV_ENUM_DELFEC, 0, 0),
> 
>   _DTV_CMD(DTV_ATSCMH_PARADE_ID, 1, 0),
>   _DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 1, 0),
> @@ -1285,6 +1287,22 @@ static int dtv_property_process_get(struct
> dvb_frontend *fe,
>   }
>   tvp->u.buffer.len = ncaps;
>   break;
> + case DTV_ENUM_DELMOD:
> + ncaps = 0;
> + while (fe->ops.delmod[ncaps] && ncaps < MAX_DELMOD) {
> + tvp->u.buffer.data[ncaps] = fe->ops.delmod[ncaps];
> + ncaps++;
> + }
> + tvp->u.buffer.len = ncaps;
> + break;
> + case DTV_ENUM_DELFEC:
> + ncaps = 0;
> + while (fe->ops.delfec[ncaps] && ncaps < MAX_DELFEC) {
> + tvp->u.buffer.data[ncaps] = fe->ops.delfec[ncaps];
> + ncaps++;
> + }
> + tvp->u.buffer.len = ncaps;
> + break;
>   case DTV_FREQUENCY:
>   tvp->u.data = c->frequency;
>   break;
> diff --git a/drivers/media/dvb-core/dvb_frontend.h
> b/drivers/media/dvb-core/dvb_frontend.h
> index 371b6ca..4e96640 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -47,6 +47,8 @@
>   * should be smaller or equal to 32
>   */
>  #define MAX_DELSYS 8
> +#define MAX_DELMOD 8
> +#define MAX_DELFEC 32
> 
>  struct dvb_frontend_tune_settings {
>   int min_delay_ms;
> @@ -263,6 +265,8 @@ struct dvb_frontend_ops {
>   struct dvb_frontend_info info;
> 
>   u8 delsys[MAX_DELSYS];
> + u8 delmod[MAX_DELMOD];
> + u8 delfec[MAX_DELFEC];
> 
>   void (*release)(struct dvb_frontend* fe);
>   void (*release_sec)(struct dvb_frontend* fe);
> diff --git a/include/uapi/linux/dvb/frontend.h
> b/include/uapi/linux/dvb/frontend.h
> index c56d77c..be63d37 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -375,7 +375,10 @@ struct dvb_frontend_event {
>  #define DTV_STAT_ERROR_BLOCK_COUNT 68
>  #define DTV_STAT_TOTAL_BLOCK_COUNT 69
> 
> -#define DTV_MAX_COMMAND DTV_STAT_TOTAL_BLOCK_COUNT
> +#define DTV_ENUM_DELMOD 70
> +#define DTV_ENUM_DELFEC 71
> +
> +#define DTV_MAX_COMMAND DTV_ENUM_DELFEC
> 
>  typedef enum fe_pilot {
>   PILOT_ON,
> diff --git a/drivers/media/dvb-frontends/au8522_dig.c
> b/drivers/media/dvb-frontends/au8522_dig.c
> index 6ee9028..1044c9d 100644
> --- a/drivers/media/dvb-frontends/au8522_dig.c
> +++ b/drivers/media/dvb-frontends/au8522_dig.c
> @@ -822,7 +822,9 @@ error:
>  EXPORT_SYMBOL(au8522_attach);
> 
>  static struct dvb_frontend_ops au8522_ops = {
> - .delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
> + .delsys = { SYS_DVBC_ANNEX_B, SYS_ATSC },
> + .delmod = { QAM_256, QAM_64, VSB_8 },
> + .delfec = { FEC_NONE },
>   .info = {
>   .name = "Auvitek AU8522 QAM/8VSB Frontend",
>   .frequency_min = 54000000,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
