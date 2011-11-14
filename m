Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:35145 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1KNT7R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 14:59:17 -0500
Message-ID: <4EC1730F.9000605@linuxtv.org>
Date: Mon, 14 Nov 2011 20:59:11 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH v3: Query DVB frontend delivery capabilities (was: Re:
 PATCH: Query DVB frontend capabilities)
References: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
In-Reply-To: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.11.2011 20:39, Manu Abraham wrote:
> On 11/12/11, Andreas Oberritter <obi@linuxtv.org> wrote:
>> > On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
>>> >> Em 11-11-2011 20:07, Manu Abraham escreveu:
>>>> >>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
>>>> >>> <mchehab@redhat.com> wrote:
>>>>> >>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
>>>>>> >>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>>>>>> >>>>> <mchehab@redhat.com> wrote:
>>>>>>> >>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>>>>> >>>>> The purpose of the patch is to
>>>>>> >>>>> query DVB delivery system capabilities alone, rather than DVB frontend
>>>>>> >>>>> info/capability.
>>>>>> >>>>>
>>>>>> >>>>> Attached is a revised version 2 of the patch, which addresses the
>>>>>> >>>>> issues that were raised.
>>>>> >>>>
>>>>> >>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
>>>>> >>>> Please, when submitting upstream, don't forget to increment DVB version
>>>>> >>>> and
>>>>> >>>> add touch at DocBook, in order to not increase the gap between API specs
>>>>> >>>> and the
>>>>> >>>> implementation.
>>>> >>>
>>>> >>> Ok, thanks for the feedback, will do that.
>>>> >>>
>>>> >>> The naming issue is trivial. I would like to have a shorter name
>>>> >>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
>>>> >>> device capability.
>>> >>
>>> >> CAPS is not a good name, as there are those two CAPABILITIES calls there
>>> >> (well, currently not implemented). So, it can lead in to some confusion.
>>> >>
>>> >> DTV_ENUM_DELIVERY could be an alternative for a short name to be used
>>> >> there.
>> >
>> > I like "enum", because it suggests that it's a read-only property.
>> >
>> > DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
>> > alternative.
> This is a bit more sensible and meaningful than the others. I like
> this one better than the others.
> 
> Attached is a version 3 patch which addresses all the issues that were raised.
> 
> Regards,
> Manu
> 
> 
> 0001-DVB-Query-DVB-frontend-delivery-capabilities.patch
> 
> 
> From 90a00ffbaa1cdd1e49f63c3f6f912ee5fd420a6a Mon Sep 17 00:00:00 2001
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Mon, 14 Nov 2011 03:17:44 +0530
> Subject: [PATCH] DVB: Query DVB frontend delivery capabilities.
> 
>  Currently, for any multi-standard frontend it is assumed that it just
>  has a single standard capability. This is fine in some cases, but
>  makes things hard when there are incompatible standards in conjuction.
>  Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
>  the same for DSS. This is not specific to any driver as it is, but a
>  generic issue. This was handled correctly in the multiproto tree,
>  while such functionality is missing from the v5 API update.
> 
>  http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
> 
>  Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
>  issue in the v5 API, but that hack is incapable of addressing the
>  issue, as it can be used to simply distinguish between DVB-S and
>  DVB-S2 alone, or another X vs X2 modulation. If there are more systems,
>  then you have a potential issue.
> 
>  An application needs to query the device capabilities before requesting
>  any operation from the device.
> 
> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>

Acked-by: Andreas Oberritter <obi@linuxtv.org>

> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |   36 +++++++++++++++++++++++++++++
>  include/linux/dvb/frontend.h              |    4 ++-
>  include/linux/dvb/version.h               |    2 +-
>  3 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 2c0acdb..1368d8c 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -973,6 +973,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>  	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>  	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>  	_DTV_CMD(DTV_HIERARCHY, 0, 0),
> +
> +	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
>  };

I don't have a strong opinion about the name of the command. I prefer
this one, but I'd be fine with any other reasonable name, too.

>  static void dtv_property_dump(struct dtv_property *tvp)
> @@ -1207,6 +1209,37 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  static int dvb_frontend_ioctl_properties(struct file *file,
>  			unsigned int cmd, void *parg);
>  
> +static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct dtv_property *p)
> +{
> +	const struct dvb_frontend_info *info = &fe->ops.info;
> +	u32 ncaps = 0;
> +
> +	switch (info->type) {
> +	case FE_QPSK:
> +		p->u.buffer.data[ncaps++] = SYS_DVBS;
> +		if (info->caps & FE_CAN_2G_MODULATION)
> +			p->u.buffer.data[ncaps++] = SYS_DVBS2;
> +		if (info->caps & FE_CAN_TURBO_FEC)
> +			p->u.buffer.data[ncaps++] = SYS_TURBO;
> +		break;
> +	case FE_QAM:
> +		p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_AC;
> +		break;
> +	case FE_OFDM:
> +		p->u.buffer.data[ncaps++] = SYS_DVBT;
> +		if (info->caps & FE_CAN_2G_MODULATION)
> +			p->u.buffer.data[ncaps++] = SYS_DVBT2;
> +		break;
> +	case FE_ATSC:
> +		if (info->caps & (FE_CAN_8VSB | FE_CAN_16VSB))
> +			p->u.buffer.data[ncaps++] = SYS_ATSC;
> +		if (info->caps & (FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_128 | FE_CAN_QAM_256))
> +			p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_B;
> +		break;
> +	}
> +	p->u.buffer.len = ncaps;
> +}
> +
>  static int dtv_property_process_get(struct dvb_frontend *fe,
>  				    struct dtv_property *tvp,
>  				    struct file *file)
> @@ -1227,6 +1260,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  	}
>  
>  	switch(tvp->cmd) {
> +	case DTV_ENUM_DELSYS:
> +		dtv_set_default_delivery_caps(fe, tvp);
> +		break;
>  	case DTV_FREQUENCY:
>  		tvp->u.data = c->frequency;
>  		break;
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 1b1094c..f80b863 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -316,7 +316,9 @@ struct dvb_frontend_event {
>  
>  #define DTV_DVBT2_PLP_ID	43
>  
> -#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
> +#define DTV_ENUM_DELSYS		44
> +
> +#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
>  
>  typedef enum fe_pilot {
>  	PILOT_ON,
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> index 66594b1..0559e2b 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>  #define _DVBVERSION_H_
>  
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 4
> +#define DVB_API_VERSION_MINOR 5
>  
>  #endif /*_DVBVERSION_H_*/
> -- 1.7.1
> 
