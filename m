Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33731
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751361AbdISJd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 05:33:29 -0400
Date: Tue, 19 Sep 2017 06:33:20 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [DVB][FRONTEND] Added a new ioctl for optimizing
 frontend property set operation
Message-ID: <20170919063320.17cba1b6@vento.lan>
In-Reply-To: <1505727345-30780-1-git-send-email-satendra.t@samsung.com>
References: <1505722516-30026-1-git-send-email-satendra.t@samsung.com>
        <CGME20170918093605epcas5p44f91f4ef218e9344e867f0729760d1d0@epcas5p4.samsung.com>
        <1505727345-30780-1-git-send-email-satendra.t@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Sep 2017 05:35:45 -0400
Satendra Singh Thakur <satendra.t@samsung.com> escreveu:

> Hello  Mr Chehab,
> It seems that there is a mismatch among tab spacing
> in local patch on my PC, the patch in email
> and the patch in lkml site.
> This is causing alignment problem. Even if I fix alignment problem
> in my PC, alignment is different in lkml and email.
> Anyway, I have run checkpatch and got 0 err and warnings
> Please review it.
> Thanks for the patience.

Please, always put patch description here.

> 
> Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
> ---

If you have any comments to maintainers/reviewers, add here,
after the "---" line.

>  Documentation/media/uapi/dvb/fe-get-property.rst |  24 ++-
>  drivers/media/dvb-core/dvb_frontend.c            | 191 ++++++++++++++---------
>  include/uapi/linux/dvb/frontend.h                |  24 +++
>  3 files changed, 158 insertions(+), 81 deletions(-)
> 
> diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
> index 015d4db..b63a588 100644
> --- a/Documentation/media/uapi/dvb/fe-get-property.rst
> +++ b/Documentation/media/uapi/dvb/fe-get-property.rst
> @@ -2,14 +2,14 @@
>  
>  .. _FE_GET_PROPERTY:
>  
> -**************************************
> -ioctl FE_SET_PROPERTY, FE_GET_PROPERTY
> -**************************************
> +**************************************************************
> +ioctl FE_SET_PROPERTY, FE_GET_PROPERTY, FE_SET_PROPERTY_SHORT
> +**************************************************************
>  
>  Name
>  ====
>  
> -FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend properties. - FE_GET_PROPERTY returns one or more frontend properties.
> +FE_SET_PROPERTY and FE_SET_PROPERTY_SHORT set one or more frontend properties. FE_GET_PROPERTY returns one or more frontend properties.
>  
>  
>  Synopsis
> @@ -21,6 +21,8 @@ Synopsis
>  .. c:function:: int ioctl( int fd, FE_SET_PROPERTY, struct dtv_properties *argp )
>      :name: FE_SET_PROPERTY
>  
> +.. c:function:: int ioctl( int fd, FE_SET_PROPERTY_SHORT, struct dtv_properties_short *argp )
> +    :name: FE_SET_PROPERTY_SHORT
>  
>  Arguments
>  =========
> @@ -29,15 +31,16 @@ Arguments
>      File descriptor returned by :ref:`open() <frontend_f_open>`.
>  
>  ``argp``
> -    pointer to struct :c:type:`dtv_properties`
> +    Pointer to struct :c:type:`dtv_properties` or
> +	struct :c:type:`dtv_properties_short`.
>  
>  
>  Description
>  ===========
>  
> -All DVB frontend devices support the ``FE_SET_PROPERTY`` and
> -``FE_GET_PROPERTY`` ioctls. The supported properties and statistics
> -depends on the delivery system and on the device:
> +All DVB frontend devices support the ``FE_SET_PROPERTY``, ``FE_GET_PROPERTY``
> +and ``FE_SET_PROPERTY_SHORT`` ioctls. The supported  properties and
> +statistics depends on the delivery system and on the device:
>  
>  -  ``FE_SET_PROPERTY:``
>  
> @@ -60,6 +63,11 @@ depends on the delivery system and on the device:
>  
>     -  This call only requires read-only access to the device.
>  
> +-  ``FE_SET_PROPERTY_SHORT:``
> +
> +   -  This ioctl is similar to FE_SET_PROPERTY ioctl mentioned above
> +      except that the arguments of the former utilize a struct :c:type:`dtv_property_short`
> +      which is smaller in size.
>  
>  Return Value
>  ============

I'm still in doubt about something: what's the real requirement from userspace
to justify a new ioctl?

Userspace will still need to allocate the same memory in order to get back
the tuner parameters with FE_GET_PROPERTY and to get statistics. Also, tuning
happens just once per channel, so hardly this would bring *any* real 
performance improvement while tuning into a channel.

> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index e3fff8f..7c96197 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1081,28 +1081,25 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>  	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
>  };
>  
> -static void dtv_property_dump(struct dvb_frontend *fe,
> -			      bool is_set,
> +static void dtv_get_property_dump(struct dvb_frontend *fe,
>  			      struct dtv_property *tvp)
>  {
>  	int i;
>  
>  	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
> -		dev_warn(fe->dvb->device, "%s: %s tvp.cmd = 0x%08x undefined\n",
> -				__func__,
> -				is_set ? "SET" : "GET",
> -				tvp->cmd);
> +		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
> +				 , __func__,
> +				 tvp->cmd);
>  		return;
>  	}
>  
> -	dev_dbg(fe->dvb->device, "%s: %s tvp.cmd    = 0x%08x (%s)\n", __func__,
> -		is_set ? "SET" : "GET",
> -		tvp->cmd,
> -		dtv_cmds[tvp->cmd].name);
> +	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
> +			tvp->cmd,
> +			dtv_cmds[tvp->cmd].name);
>  
>  	if (dtv_cmds[tvp->cmd].buffer) {
>  		dev_dbg(fe->dvb->device, "%s: tvp.u.buffer.len = 0x%02x\n",
> -			__func__, tvp->u.buffer.len);
> +				__func__, tvp->u.buffer.len);
>  
>  		for(i = 0; i < tvp->u.buffer.len; i++)
>  			dev_dbg(fe->dvb->device,
> @@ -1515,7 +1512,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  			return r;
>  	}
>  
> -	dtv_property_dump(fe, false, tvp);
> +	dtv_get_property_dump(fe, tvp);
>  
>  	return 0;
>  }
> @@ -1738,23 +1735,35 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
>  	return emulate_delivery_system(fe, delsys);
>  }
>  
> +/**
> + * dtv_property_process_set -  Sets a single DTV property
> + * @fe:		Pointer to &struct dvb_frontend
> + * @file:	Pointer to &struct file
> + * @cmd:	Digital TV command
> + * @data:	An unsigned 32-bits number
> + *
> + * This routine assigns the property
> + * value to the corresponding member of
> + * &struct dtv_frontend_properties
> + *
> + * Returns:
> + * Zero on success, negative errno on failure.
> + */
>  static int dtv_property_process_set(struct dvb_frontend *fe,
> -				    struct dtv_property *tvp,
> -				    struct file *file)
> +					struct file *file,
> +					u32 cmd, u32 data)
>  {
>  	int r = 0;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -
> -	/* Allow the frontend to validate incoming properties */
> -	if (fe->ops.set_property) {
> -		r = fe->ops.set_property(fe, tvp);
> -		if (r < 0)
> -			return r;
> -	}
> -
> -	dtv_property_dump(fe, true, tvp);
> -
> -	switch(tvp->cmd) {
> +	/** Dump DTV command name and value*/
> +	if (!cmd || cmd > DTV_MAX_COMMAND)
> +		dev_warn(fe->dvb->device, "%s: SET cmd 0x%08x undefined\n",
> +				 __func__, cmd);
> +	else
> +		dev_dbg(fe->dvb->device,
> +				"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
> +				__func__, cmd, dtv_cmds[cmd].name, data);
> +	switch (cmd) {
>  	case DTV_CLEAR:
>  		/*
>  		 * Reset a cache of data specific to the frontend here. This does
> @@ -1767,140 +1776,140 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
>  		 * ioctl.
>  		 */
> -		c->state = tvp->cmd;
> +		c->state = cmd;
>  		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
>  				__func__);
>  
>  		r = dtv_set_frontend(fe);
>  		break;
>  	case DTV_FREQUENCY:
> -		c->frequency = tvp->u.data;
> +		c->frequency = data;
>  		break;
>  	case DTV_MODULATION:
> -		c->modulation = tvp->u.data;
> +		c->modulation = data;
>  		break;
>  	case DTV_BANDWIDTH_HZ:
> -		c->bandwidth_hz = tvp->u.data;
> +		c->bandwidth_hz = data;
>  		break;
>  	case DTV_INVERSION:
> -		c->inversion = tvp->u.data;
> +		c->inversion = data;
>  		break;
>  	case DTV_SYMBOL_RATE:
> -		c->symbol_rate = tvp->u.data;
> +		c->symbol_rate = data;
>  		break;
>  	case DTV_INNER_FEC:
> -		c->fec_inner = tvp->u.data;
> +		c->fec_inner = data;
>  		break;
>  	case DTV_PILOT:
> -		c->pilot = tvp->u.data;
> +		c->pilot = data;
>  		break;
>  	case DTV_ROLLOFF:
> -		c->rolloff = tvp->u.data;
> +		c->rolloff = data;
>  		break;
>  	case DTV_DELIVERY_SYSTEM:
> -		r = dvbv5_set_delivery_system(fe, tvp->u.data);
> +		r = dvbv5_set_delivery_system(fe, data);
>  		break;
>  	case DTV_VOLTAGE:
> -		c->voltage = tvp->u.data;
> +		c->voltage = data;
>  		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
>  			(void *)c->voltage);
>  		break;
>  	case DTV_TONE:
> -		c->sectone = tvp->u.data;
> +		c->sectone = data;
>  		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
>  			(void *)c->sectone);
>  		break;
>  	case DTV_CODE_RATE_HP:
> -		c->code_rate_HP = tvp->u.data;
> +		c->code_rate_HP = data;
>  		break;
>  	case DTV_CODE_RATE_LP:
> -		c->code_rate_LP = tvp->u.data;
> +		c->code_rate_LP = data;
>  		break;
>  	case DTV_GUARD_INTERVAL:
> -		c->guard_interval = tvp->u.data;
> +		c->guard_interval = data;
>  		break;
>  	case DTV_TRANSMISSION_MODE:
> -		c->transmission_mode = tvp->u.data;
> +		c->transmission_mode = data;
>  		break;
>  	case DTV_HIERARCHY:
> -		c->hierarchy = tvp->u.data;
> +		c->hierarchy = data;
>  		break;
>  	case DTV_INTERLEAVING:
> -		c->interleaving = tvp->u.data;
> +		c->interleaving = data;
>  		break;
>  
>  	/* ISDB-T Support here */
>  	case DTV_ISDBT_PARTIAL_RECEPTION:
> -		c->isdbt_partial_reception = tvp->u.data;
> +		c->isdbt_partial_reception = data;
>  		break;
>  	case DTV_ISDBT_SOUND_BROADCASTING:
> -		c->isdbt_sb_mode = tvp->u.data;
> +		c->isdbt_sb_mode = data;
>  		break;
>  	case DTV_ISDBT_SB_SUBCHANNEL_ID:
> -		c->isdbt_sb_subchannel = tvp->u.data;
> +		c->isdbt_sb_subchannel = data;
>  		break;
>  	case DTV_ISDBT_SB_SEGMENT_IDX:
> -		c->isdbt_sb_segment_idx = tvp->u.data;
> +		c->isdbt_sb_segment_idx = data;
>  		break;
>  	case DTV_ISDBT_SB_SEGMENT_COUNT:
> -		c->isdbt_sb_segment_count = tvp->u.data;
> +		c->isdbt_sb_segment_count = data;
>  		break;
>  	case DTV_ISDBT_LAYER_ENABLED:
> -		c->isdbt_layer_enabled = tvp->u.data;
> +		c->isdbt_layer_enabled = data;
>  		break;
>  	case DTV_ISDBT_LAYERA_FEC:
> -		c->layer[0].fec = tvp->u.data;
> +		c->layer[0].fec = data;
>  		break;
>  	case DTV_ISDBT_LAYERA_MODULATION:
> -		c->layer[0].modulation = tvp->u.data;
> +		c->layer[0].modulation = data;
>  		break;
>  	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
> -		c->layer[0].segment_count = tvp->u.data;
> +		c->layer[0].segment_count = data;
>  		break;
>  	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
> -		c->layer[0].interleaving = tvp->u.data;
> +		c->layer[0].interleaving = data;
>  		break;
>  	case DTV_ISDBT_LAYERB_FEC:
> -		c->layer[1].fec = tvp->u.data;
> +		c->layer[1].fec = data;
>  		break;
>  	case DTV_ISDBT_LAYERB_MODULATION:
> -		c->layer[1].modulation = tvp->u.data;
> +		c->layer[1].modulation = data;
>  		break;
>  	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
> -		c->layer[1].segment_count = tvp->u.data;
> +		c->layer[1].segment_count = data;
>  		break;
>  	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
> -		c->layer[1].interleaving = tvp->u.data;
> +		c->layer[1].interleaving = data;
>  		break;
>  	case DTV_ISDBT_LAYERC_FEC:
> -		c->layer[2].fec = tvp->u.data;
> +		c->layer[2].fec = data;
>  		break;
>  	case DTV_ISDBT_LAYERC_MODULATION:
> -		c->layer[2].modulation = tvp->u.data;
> +		c->layer[2].modulation = data;
>  		break;
>  	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
> -		c->layer[2].segment_count = tvp->u.data;
> +		c->layer[2].segment_count = data;
>  		break;
>  	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
> -		c->layer[2].interleaving = tvp->u.data;
> +		c->layer[2].interleaving = data;
>  		break;
>  
>  	/* Multistream support */
>  	case DTV_STREAM_ID:
>  	case DTV_DVBT2_PLP_ID_LEGACY:
> -		c->stream_id = tvp->u.data;
> +		c->stream_id = data;
>  		break;
>  
>  	/* ATSC-MH */
>  	case DTV_ATSCMH_PARADE_ID:
> -		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
> +		fe->dtv_property_cache.atscmh_parade_id = data;
>  		break;
>  	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
> -		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
> +		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
>  		break;
>  
>  	case DTV_LNA:
> -		c->lna = tvp->u.data;
> +		c->lna = data;
>  		if (fe->ops.set_lna)
>  			r = fe->ops.set_lna(fe);
>  		if (r < 0)
> @@ -1939,7 +1948,8 @@ static int dvb_frontend_ioctl(struct file *file,
>  		return -EPERM;
>  	}

The above optimization seem OK. Still, it is better to place it on
a separate patch.

>  
> -	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
> +	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
> +	    || (cmd == FE_SET_PROPERTY_SHORT))
>  		err = dvb_frontend_ioctl_properties(file, cmd, parg);
>  	else {
>  		c->state = DTV_UNDEFINED;

Assuming that you provide a good reason why we need this ioctl, this
should be on the second patch with the new ioctl.

> @@ -1966,8 +1976,10 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  	dev_dbg(fe->dvb->device, "%s:\n", __func__);
>  
>  	if (cmd == FE_SET_PROPERTY) {
> -		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
> -		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
> +				__func__, tvps->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
> +				__func__, tvps->props);
>  
>  		/* Put an arbitrary limit on the number of messages that can
>  		 * be sent at once */
> @@ -1979,20 +1991,25 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  			return PTR_ERR(tvp);
>  
>  		for (i = 0; i < tvps->num; i++) {
> -			err = dtv_property_process_set(fe, tvp + i, file);
> +			err = dtv_property_process_set(fe, file,
> +					(tvp + i)->cmd,
> +					(tvp + i)->u.data);
>  			if (err < 0)
>  				goto out;
>  			(tvp + i)->result = err;
>  		}
>  
>  		if (c->state == DTV_TUNE)
> -			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
> +			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n",
> +					__func__);
>  
>  	} else if (cmd == FE_GET_PROPERTY) {
>  		struct dtv_frontend_properties getp = fe->dtv_property_cache;
>  
> -		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
> -		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
> +				__func__, tvps->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
> +				__func__, tvps->props);
>  
>  		/* Put an arbitrary limit on the number of messages that can
>  		 * be sent at once */
> @@ -2026,7 +2043,35 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  			err = -EFAULT;
>  			goto out;
>  		}

Indentation is still wrong. Are you setting tab to 8?

> -
> +	/* New ioctl for optimizing property set*/
> +	} else if (cmd == FE_SET_PROPERTY_SHORT) {
> +		struct dtv_property_short *tvp_short = NULL;
> +		struct dtv_properties_short *tvps_short = parg;
> +
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
> +				__func__, tvps_short->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
> +				__func__, tvps_short->props);
> +		if ((!tvps_short->num) ||
> +		    (tvps_short->num > DTV_IOCTL_MAX_MSGS))
> +			return -EINVAL;
> +		tvp_short = memdup_user(tvps_short->props,
> +		tvps_short->num * sizeof(*tvp_short));
> +		if (IS_ERR(tvp_short))
> +			return PTR_ERR(tvp_short);
> +		for (i = 0; i < tvps_short->num; i++) {
> +			err = dtv_property_process_set(fe, file,
> +					(tvp_short + i)->cmd,
> +					(tvp_short + i)->data);
> +			if (err < 0) {
> +				kfree(tvp_short);
> +				return err;
> +			}
> +		}
> +		if (c->state == DTV_TUNE)
> +			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n",
> +					__func__);
> +		kfree(tvp_short);

Place the new ioctl code on the second patch.

>  	} else
>  		err = -EOPNOTSUPP;
>  
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 00a20cd..9d96dab 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -476,6 +476,17 @@ struct dtv_property {
>  	int result;
>  } __attribute__ ((packed));
>  
> +/**
> + * struct dtv_property_short - A shorter version of &struct dtv_property
> + *
> + * @cmd:	Digital TV command.
> + * @data:	An unsigned 32-bits number.
> + */
> +struct dtv_property_short {
> +	__u32 cmd;
> +	__u32 data;
> +};
> +
>  /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
>  #define DTV_IOCTL_MAX_MSGS 64
>  
> @@ -484,6 +495,18 @@ struct dtv_properties {
>  	struct dtv_property *props;
>  };
>  
> +/**
> + * struct dtv_properties_short - A variant of &struct dtv_properties
> + * to support &struct dtv_property_short
> + *
> + * @num:	Number of properties
> + * @props:	Pointer to &struct dtv_property_short
> + */
> +struct dtv_properties_short {
> +	__u32 num;
> +	struct dtv_property_short *props;
> +};
> +
>  #if defined(__DVB_CORE__) || !defined (__KERNEL__)
>  
>  /*
> @@ -565,6 +588,7 @@ struct dvb_frontend_event {
>  
>  #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
>  #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
> +#define FE_SET_PROPERTY_SHORT	   _IOW('o', 84, struct dtv_properties_short)
>  
>  /**
>   * When set, this flag will disable any zigzagging or other "normal" tuning

Place the new ioctl code on the second patch.


Thanks,
Mauro
