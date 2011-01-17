Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:64518 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1AQDIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 22:08:48 -0500
Subject: Re: [RFC PATCH] pvrusb2: Provide more information about IR units
 to lirc_zilog and ir-kbd-i2c
From: Andy Walls <awalls@md.metrocast.net>
To: Mike Isely <isely@isely.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <alpine.DEB.1.10.1101162018420.5396@ivanova.isely.net>
References: <1295225086.2400.119.camel@localhost>
	 <alpine.DEB.1.10.1101162018420.5396@ivanova.isely.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 22:07:53 -0500
Message-ID: <1295233673.2407.33.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-16 at 20:27 -0600, Mike Isely wrote:
> Andy:
> 
> Is the IR_i2c_init_data struct instance required to remain around for 
> the life of the driver's registration and is that why you stuffed it 
> into the pvr2_hdw struct? 

Yes.

The loading of ir-kbd-i2c or lirc_zilog can happen some undetermined
amount of time after or before the pvrusb2 driver registers the I2C
devices.  The data needs to persist on a per device basis; it cannot
come from the stack.


>  Second: If the first question is yes, then is 
> that struct considered to be read-only once it is set up and passed 
> through to the i2c device registration function?

Yes.  It will only be read once by lirc_zilog or ir-kbd-i2c in their
probe methods.  Although both of those modules can be unloaded and
reloaded, so there is the possibility of being read again any number of
times.

>   In other words, could 
> that structure be a const static initialized at compile time, perhaps 
> as part of a table definition?

Right now, yes.  In the near future, I need to use to to pass 3
non-const items though:

1. A "struct mutex *transceiver_lock" so that the bridge driver can pass
a mutex to multiple modules accessing the Z8.  That would be a per
device instance mutex, instantiated and initialized by the bridge
driver.  The use case where this would be needed is a setup where
ir-kbd-i2c handles Z8 IR Rx and lirc_zilog handles only Z8 IR Tx of the
same chip.

2. A bridge driver provided "void (*reset_ir_chip)(struct i2c_adapter
*adap)",  or maybe "void (*reset_ir_chip)(void *priv)", callback to
reset the transceiver chip when it gets hung.  The original lirc_pvr150
module had some hard coded reset function names and calls in it, but
they were removed with the rename to lirc_zilog and move into the
kernel.  I'd like to get that ability back.

3. A bridge driver provided private data structure for the "void *priv"
argument of the aforementioned reset callback.  This would also be a per
device object instantiated and initialized by the bridge driver. 


> I believe I follow this and it looks good.  The concept looks very 
> simple and it's nice that the changes are really only in a single spot.  
> Just thinking ahead about making the setup table-driven and not 
> requiring data segment storage.

With the patch right now it could be constant, I think.  You would have
to use some generic name, like "pvrusb2 IR", instead of
hdw->hdw_desc->description though.

For my future plans, if you don't provide a reset callback and don't
wish to provide a mutex, then yes you can keep it constant.

I suspect not providing a reset callback may be OK.

Not providing a mutex is also OK but it imposes a limitation: only one
IR module should be allowed to use the Z8 chip.  That means
only lirc_zilog for IR Tx/Rx with Rx through LIRC, or
only ir-kbd-i2c for IR Rx through the the Linux input subsystem.

>   -Mike
> 
> 
> Acked-By: Mike Isely <isely@pobox.com>

Thanks.  I'll pull this into my Z8 branch then.

Regards,
Andy

> On Sun, 16 Jan 2011, Andy Walls wrote:
> 
> >     
> > When registering an IR Rx device with the I2C subsystem, provide more detailed
> > information about the IR device and default remote configuration for the IR
> > driver modules.
> >     
> > Also explicitly register any IR Tx device with the I2C subsystem.
> >     
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > Cc: Mike Isely <isely@isely.net>
> > 
> > --
> > Mike,
> > 
> > As discussed on IRC, this patch will enable lirc_zilog to bind to Zilog
> > Z8 IR units on devices supported by pvrusb2.
> > 
> > Please review and comment.  This patch could have been written a number
> > of ways.  The way I chose was very direct: hard-coding information in a
> > single function.
> > 
> > A git branch with this change, and the updated lirc_zilog, is here:
> > 
> > 	git://linuxtv.org/awalls/media_tree.git z8-pvrusb2
> > 
> > 	http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8-pvrusb2
> > 
> > Regards,
> > Andy
> > 
> > diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> > index ac94a8b..305e6aa 100644
> > --- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> > +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
> > @@ -40,6 +40,7 @@
> >  #include "pvrusb2-io.h"
> >  #include <media/v4l2-device.h>
> >  #include <media/cx2341x.h>
> > +#include <media/ir-kbd-i2c.h>
> >  #include "pvrusb2-devattr.h"
> >  
> >  /* Legal values for PVR2_CID_HSM */
> > @@ -202,6 +203,7 @@ struct pvr2_hdw {
> >  
> >  	/* IR related */
> >  	unsigned int ir_scheme_active; /* IR scheme as seen from the outside */
> > +	struct IR_i2c_init_data ir_init_data; /* params passed to IR modules */
> >  
> >  	/* Frequency table */
> >  	unsigned int freqTable[FREQTABLE_SIZE];
> > diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > index 7cbe18c..ccc8849 100644
> > --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > @@ -19,6 +19,7 @@
> >   */
> >  
> >  #include <linux/i2c.h>
> > +#include <media/ir-kbd-i2c.h>
> >  #include "pvrusb2-i2c-core.h"
> >  #include "pvrusb2-hdw-internal.h"
> >  #include "pvrusb2-debug.h"
> > @@ -48,13 +49,6 @@ module_param_named(disable_autoload_ir_video, pvr2_disable_ir_video,
> >  MODULE_PARM_DESC(disable_autoload_ir_video,
> >  		 "1=do not try to autoload ir_video IR receiver");
> >  
> > -/* Mapping of IR schemes to known I2C addresses - if any */
> > -static const unsigned char ir_video_addresses[] = {
> > -	[PVR2_IR_SCHEME_ZILOG] = 0x71,
> > -	[PVR2_IR_SCHEME_29XXX] = 0x18,
> > -	[PVR2_IR_SCHEME_24XXX] = 0x18,
> > -};
> > -
> >  static int pvr2_i2c_write(struct pvr2_hdw *hdw, /* Context */
> >  			  u8 i2c_addr,      /* I2C address we're talking to */
> >  			  u8 *data,         /* Data to write */
> > @@ -574,26 +568,56 @@ static void do_i2c_scan(struct pvr2_hdw *hdw)
> >  static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
> >  {
> >  	struct i2c_board_info info;
> > -	unsigned char addr = 0;
> > +	struct IR_i2c_init_data *init_data = &hdw->ir_init_data;
> >  	if (pvr2_disable_ir_video) {
> >  		pvr2_trace(PVR2_TRACE_INFO,
> >  			   "Automatic binding of ir_video has been disabled.");
> >  		return;
> >  	}
> > -	if (hdw->ir_scheme_active < ARRAY_SIZE(ir_video_addresses)) {
> > -		addr = ir_video_addresses[hdw->ir_scheme_active];
> > -	}
> > -	if (!addr) {
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	switch (hdw->ir_scheme_active) {
> > +	case PVR2_IR_SCHEME_24XXX: /* FX2-controlled IR */
> > +	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
> > +		init_data->ir_codes              = RC_MAP_HAUPPAUGE_NEW;
> > +		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
> > +		init_data->type                  = RC_TYPE_RC5;
> > +		init_data->name                  = hdw->hdw_desc->description;
> > +		init_data->polling_interval      = 100; /* ms From ir-kbd-i2c */
> > +		/* IR Receiver */
> > +		info.addr          = 0x18;
> > +		info.platform_data = init_data;
> > +		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> > +		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
> > +			   info.type, info.addr);
> > +		i2c_new_device(&hdw->i2c_adap, &info);
> > +		break;
> > +	case PVR2_IR_SCHEME_ZILOG:     /* HVR-1950 style */
> > +	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
> > +		init_data->ir_codes              = RC_MAP_HAUPPAUGE_NEW;
> > +		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> > +		init_data->type                  = RC_TYPE_RC5;
> > +		init_data->name                  = hdw->hdw_desc->description;
> > +		init_data->polling_interval      = 260; /* ms From lirc_zilog */
> > +		/* IR Receiver */
> > +		info.addr          = 0x71;
> > +		info.platform_data = init_data;
> > +		strlcpy(info.type, "ir_rx_z8f0811_haup", I2C_NAME_SIZE);
> > +		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
> > +			   info.type, info.addr);
> > +		i2c_new_device(&hdw->i2c_adap, &info);
> > +		/* IR Trasmitter */
> > +		info.addr          = 0x70;
> > +		info.platform_data = init_data;
> > +		strlcpy(info.type, "ir_tx_z8f0811_haup", I2C_NAME_SIZE);
> > +		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
> > +			   info.type, info.addr);
> > +		i2c_new_device(&hdw->i2c_adap, &info);
> > +		break;
> > +	default:
> >  		/* The device either doesn't support I2C-based IR or we
> >  		   don't know (yet) how to operate IR on the device. */
> > -		return;
> > +		break;
> >  	}
> > -	pvr2_trace(PVR2_TRACE_INFO,
> > -		   "Binding ir_video to i2c address 0x%02x.", addr);
> > -	memset(&info, 0, sizeof(struct i2c_board_info));
> > -	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> > -	info.addr = addr;
> > -	i2c_new_device(&hdw->i2c_adap, &info);
> >  }
> >  
> >  void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


