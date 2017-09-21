Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60742
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751745AbdIUQAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 12:00:48 -0400
Date: Thu, 21 Sep 2017 13:00:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 17/25] media: dvb_frontend: dtv_property_process_set()
 cleanups
Message-ID: <20170921130005.5f1d0896@recife.lan>
In-Reply-To: <ed877265-0e2f-7c6d-b8f5-d547b3986b7a@kernel.org>
References: <cover.1505933919.git.mchehab@s-opensource.com>
 <112cb6a6a7b72e74b88d98beac10b7d91d3a4e37.1505933919.git.mchehab@s-opensource.com>
 <ed877265-0e2f-7c6d-b8f5-d547b3986b7a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Sep 2017 08:32:25 -0600
Shuah Khan <shuah@kernel.org> escreveu:

> On 09/20/2017 01:11 PM, Mauro Carvalho Chehab wrote:
> > From: Satendra Singh Thakur <satendra.t@samsung.com>
> > 
> > Since all properties in the func dtv_property_process_set() use
> > at most 4 bytes arguments, change the code to pass
> > u32 cmd and u32 data as function arguments, instead of passing a
> > pointer to the entire struct dtv_property *tvp.
> > 
> > Instead of having a generic dtv_property_dump(), added its own
> > properties debug logic at dtv_property_process_set().  
> 
> Nit: in the dtv_property_process_set()
> 
> > 
> > Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/dvb-core/dvb_frontend.c | 125 ++++++++++++++++++++--------------
> >  1 file changed, 72 insertions(+), 53 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> > index bd60a490ce0f..b7094c7a405f 100644
> > --- a/drivers/media/dvb-core/dvb_frontend.c
> > +++ b/drivers/media/dvb-core/dvb_frontend.c
> > @@ -1107,22 +1107,19 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
> >  	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
> >  };
> >  
> > -static void dtv_property_dump(struct dvb_frontend *fe,
> > -			      bool is_set,
> > +static void dtv_get_property_dump(struct dvb_frontend *fe,
> >  			      struct dtv_property *tvp)
> >  {
> >  	int i;
> >  
> >  	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
> > -		dev_warn(fe->dvb->device, "%s: %s tvp.cmd = 0x%08x undefined\n",
> > -				__func__,
> > -				is_set ? "SET" : "GET",
> > +		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
> > +				, __func__,
> >  				tvp->cmd);
> >  		return;
> >  	}
> >  
> > -	dev_dbg(fe->dvb->device, "%s: %s tvp.cmd    = 0x%08x (%s)\n", __func__,
> > -		is_set ? "SET" : "GET",
> > +	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
> >  		tvp->cmd,
> >  		dtv_cmds[tvp->cmd].name);
> >  
> > @@ -1532,7 +1529,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
> >  		return -EINVAL;
> >  	}
> >  
> > -	dtv_property_dump(fe, false, tvp);
> > +	dtv_get_property_dump(fe, tvp);
> >  
> >  	return 0;
> >  }
> > @@ -1755,16 +1752,36 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
> >  	return emulate_delivery_system(fe, delsys);
> >  }
> >  
> > +/**
> > + * dtv_property_process_set -  Sets a single DTV property
> > + * @fe:		Pointer to &struct dvb_frontend  
> 
> Nit: extra tab looks like:
> 
> > + * @file:	Pointer to &struct file
> > + * @cmd:	Digital TV command
> > + * @data:	An unsigned 32-bits number
> > + *
> > + * This routine assigns the property
> > + * value to the corresponding member of
> > + * &struct dtv_frontend_properties
> > + *
> > + * Returns:
> > + * Zero on success, negative errno on failure.
> > + */
> >  static int dtv_property_process_set(struct dvb_frontend *fe,
> > -				    struct dtv_property *tvp,
> > -				    struct file *file)
> > +					struct file *file,
> > +					u32 cmd, u32 data)
> >  {
> >  	int r = 0;
> >  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> >  
> > -	dtv_property_dump(fe, true, tvp);  
> 
> Why not keep dtv_property_dump() the way it is? I am not seeing the
> value of this change.
> 

See below.

> > -
> > -	switch(tvp->cmd) {
> > +	/** Dump DTV command name and value*/
> > +	if (!cmd || cmd > DTV_MAX_COMMAND)
> > +		dev_warn(fe->dvb->device, "%s: SET cmd 0x%08x undefined\n",
> > +				 __func__, cmd);
> > +	else
> > +		dev_dbg(fe->dvb->device,
> > +				"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
> > +				__func__, cmd, dtv_cmds[cmd].name, data);  
> 
> The code looked simpler before this change? Why add almost identical duplicate
> code here?

Looking on each separate patch (17 and 18) makes harder to see the value :-)

Basically, after the changes we have, at dtv_property_process_set():

	int r = 0;
	struct dtv_frontend_properties *c = &fe->dtv_property_cache;

	/** Dump DTV command name and value*/
	if (!cmd || cmd > DTV_MAX_COMMAND)
		dev_warn(fe->dvb->device, "%s: SET cmd 0x%08x undefined\n",
				 __func__, cmd);
	else
		dev_dbg(fe->dvb->device,
				"%s: SET cmd 0x%08x (%s) to 0x%08x\n",
				__func__, cmd, dtv_cmds[cmd].name, data);

As here the prints happen before setting the property, the code
needs to check if the command is at the range, printing an dvb_warn()
on such case. 


At dtv_property_process_get():

	int ncaps;

	switch(tvp->cmd) {
...
	default:
		dev_dbg(fe->dvb->device,
			"%s: FE property %d doesn't exist\n",
			__func__, tvp->cmd);
		return -EINVAL;
	}

	if (!dtv_cmds[tvp->cmd].buffer)
		dev_dbg(fe->dvb->device,
			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
			__func__, tvp->cmd, dtv_cmds[tvp->cmd].name,
			tvp->u.data);
	else
		dev_dbg(fe->dvb->device,
			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
			__func__,
			tvp->cmd, dtv_cmds[tvp->cmd].name,
			tvp->u.buffer.len,
			tvp->u.buffer.len, tvp->u.buffer.data);

As the debugs are after the switch(), we don't need anymore to check
for invalid values, as the switch() code will return -EINVAL.

On the other hand, here, it can't assume that the message has just one
u32 data, as it may have multiple ones.

So, in other words, after getting rid of dtv_property_dump(), the debug
logic is actually different and there isn't much gain on putting them
at the same routine.

BTW, I have to double-check, but I guess the "if" there should be doing:

	if (!dtv_cmds[tvp->cmd].buffer.len)

Anyway, if this is a bug, it is a pre-existent one, and should be
addressed on a separate patch.



> 
> > +	switch (cmd) {
> >  	case DTV_CLEAR:
> >  		/*
> >  		 * Reset a cache of data specific to the frontend here. This does
> > @@ -1784,133 +1801,133 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
> >  		r = dtv_set_frontend(fe);
> >  		break;
> >  	case DTV_FREQUENCY:
> > -		c->frequency = tvp->u.data;
> > +		c->frequency = data;
> >  		break;
> >  	case DTV_MODULATION:
> > -		c->modulation = tvp->u.data;
> > +		c->modulation = data;
> >  		break;
> >  	case DTV_BANDWIDTH_HZ:
> > -		c->bandwidth_hz = tvp->u.data;
> > +		c->bandwidth_hz = data;
> >  		break;
> >  	case DTV_INVERSION:
> > -		c->inversion = tvp->u.data;
> > +		c->inversion = data;
> >  		break;
> >  	case DTV_SYMBOL_RATE:
> > -		c->symbol_rate = tvp->u.data;
> > +		c->symbol_rate = data;
> >  		break;
> >  	case DTV_INNER_FEC:
> > -		c->fec_inner = tvp->u.data;
> > +		c->fec_inner = data;
> >  		break;
> >  	case DTV_PILOT:
> > -		c->pilot = tvp->u.data;
> > +		c->pilot = data;
> >  		break;
> >  	case DTV_ROLLOFF:
> > -		c->rolloff = tvp->u.data;
> > +		c->rolloff = data;
> >  		break;
> >  	case DTV_DELIVERY_SYSTEM:
> > -		r = dvbv5_set_delivery_system(fe, tvp->u.data);
> > +		r = dvbv5_set_delivery_system(fe, data);
> >  		break;
> >  	case DTV_VOLTAGE:
> > -		c->voltage = tvp->u.data;
> > +		c->voltage = data;
> >  		r = dvb_frontend_handle_ioctl(file, FE_SET_VOLTAGE,
> >  			(void *)c->voltage);
> >  		break;
> >  	case DTV_TONE:
> > -		c->sectone = tvp->u.data;
> > +		c->sectone = data;
> >  		r = dvb_frontend_handle_ioctl(file, FE_SET_TONE,
> >  			(void *)c->sectone);
> >  		break;
> >  	case DTV_CODE_RATE_HP:
> > -		c->code_rate_HP = tvp->u.data;
> > +		c->code_rate_HP = data;
> >  		break;
> >  	case DTV_CODE_RATE_LP:
> > -		c->code_rate_LP = tvp->u.data;
> > +		c->code_rate_LP = data;
> >  		break;
> >  	case DTV_GUARD_INTERVAL:
> > -		c->guard_interval = tvp->u.data;
> > +		c->guard_interval = data;
> >  		break;
> >  	case DTV_TRANSMISSION_MODE:
> > -		c->transmission_mode = tvp->u.data;
> > +		c->transmission_mode = data;
> >  		break;
> >  	case DTV_HIERARCHY:
> > -		c->hierarchy = tvp->u.data;
> > +		c->hierarchy = data;
> >  		break;
> >  	case DTV_INTERLEAVING:
> > -		c->interleaving = tvp->u.data;
> > +		c->interleaving = data;
> >  		break;
> >  
> >  	/* ISDB-T Support here */
> >  	case DTV_ISDBT_PARTIAL_RECEPTION:
> > -		c->isdbt_partial_reception = tvp->u.data;
> > +		c->isdbt_partial_reception = data;
> >  		break;
> >  	case DTV_ISDBT_SOUND_BROADCASTING:
> > -		c->isdbt_sb_mode = tvp->u.data;
> > +		c->isdbt_sb_mode = data;
> >  		break;
> >  	case DTV_ISDBT_SB_SUBCHANNEL_ID:
> > -		c->isdbt_sb_subchannel = tvp->u.data;
> > +		c->isdbt_sb_subchannel = data;
> >  		break;
> >  	case DTV_ISDBT_SB_SEGMENT_IDX:
> > -		c->isdbt_sb_segment_idx = tvp->u.data;
> > +		c->isdbt_sb_segment_idx = data;
> >  		break;
> >  	case DTV_ISDBT_SB_SEGMENT_COUNT:
> > -		c->isdbt_sb_segment_count = tvp->u.data;
> > +		c->isdbt_sb_segment_count = data;
> >  		break;
> >  	case DTV_ISDBT_LAYER_ENABLED:
> > -		c->isdbt_layer_enabled = tvp->u.data;
> > +		c->isdbt_layer_enabled = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERA_FEC:
> > -		c->layer[0].fec = tvp->u.data;
> > +		c->layer[0].fec = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERA_MODULATION:
> > -		c->layer[0].modulation = tvp->u.data;
> > +		c->layer[0].modulation = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
> > -		c->layer[0].segment_count = tvp->u.data;
> > +		c->layer[0].segment_count = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
> > -		c->layer[0].interleaving = tvp->u.data;
> > +		c->layer[0].interleaving = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERB_FEC:
> > -		c->layer[1].fec = tvp->u.data;
> > +		c->layer[1].fec = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERB_MODULATION:
> > -		c->layer[1].modulation = tvp->u.data;
> > +		c->layer[1].modulation = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
> > -		c->layer[1].segment_count = tvp->u.data;
> > +		c->layer[1].segment_count = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
> > -		c->layer[1].interleaving = tvp->u.data;
> > +		c->layer[1].interleaving = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERC_FEC:
> > -		c->layer[2].fec = tvp->u.data;
> > +		c->layer[2].fec = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERC_MODULATION:
> > -		c->layer[2].modulation = tvp->u.data;
> > +		c->layer[2].modulation = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
> > -		c->layer[2].segment_count = tvp->u.data;
> > +		c->layer[2].segment_count = data;
> >  		break;
> >  	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
> > -		c->layer[2].interleaving = tvp->u.data;
> > +		c->layer[2].interleaving = data;
> >  		break;
> >  
> >  	/* Multistream support */
> >  	case DTV_STREAM_ID:
> >  	case DTV_DVBT2_PLP_ID_LEGACY:
> > -		c->stream_id = tvp->u.data;
> > +		c->stream_id = data;
> >  		break;
> >  
> >  	/* ATSC-MH */
> >  	case DTV_ATSCMH_PARADE_ID:
> > -		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
> > +		fe->dtv_property_cache.atscmh_parade_id = data;
> >  		break;
> >  	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
> > -		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
> > +		fe->dtv_property_cache.atscmh_rs_frame_ensemble = data;
> >  		break;
> >  
> >  	case DTV_LNA:
> > -		c->lna = tvp->u.data;
> > +		c->lna = data;
> >  		if (fe->ops.set_lna)
> >  			r = fe->ops.set_lna(fe);
> >  		if (r < 0)
> > @@ -2137,7 +2154,9 @@ static int dvb_frontend_handle_ioctl(struct file *file,
> >  			return PTR_ERR(tvp);
> >  
> >  		for (i = 0; i < tvps->num; i++) {
> > -			err = dtv_property_process_set(fe, tvp + i, file);
> > +			err = dtv_property_process_set(fe, file,
> > +							(tvp + i)->cmd,
> > +							(tvp + i)->u.data);
> >  			if (err < 0) {
> >  				kfree(tvp);
> >  				return err;
> >   
> 
> The rest looks good. Once the other comments are addressed and/or explained.
> 
> Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> thanks,
> -- Shuah



Thanks,
Mauro
