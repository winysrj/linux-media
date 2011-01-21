Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab1AUQfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 11:35:18 -0500
Date: Fri, 21 Jan 2011 11:34:11 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Mike Isely <isely@isely.net>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Mike Isley <isley@isley.net>
Subject: Re: [PATCH 3/3] ir-kbd-i2c: improve remote behavior with z8 behind
 usb
Message-ID: <20110121163411.GC16585@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
 <1295584225-21210-4-git-send-email-jarod@redhat.com>
 <alpine.DEB.1.10.1101211029150.5370@ivanova.isely.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1101211029150.5370@ivanova.isely.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 21, 2011 at 10:31:42AM -0600, Mike Isely wrote:
> 
> The pvrusb2 change is obviously trivial so I have no issue with it.
> 
> Acked-By: Mike Isely <isely@pobox.com>
> 
> Note the spelling of my last name "Isely" not "Isley".  A good way to 
> remember is to think of the normal word "wisely" and just drop the 
> leading "w".  (And yes, isely@isely.net and isely@pobox.com lead to the 
> same inbox.)

Thanks Mike, apologies about the misspelling, I didn't catch it until
after I hit send. I had the Isley Brothers in my head. :)


> On Thu, 20 Jan 2011, Jarod Wilson wrote:
> 
> > Add the same "are you ready?" i2c_master_send() poll command to
> > get_key_haup_xvr found in lirc_zilog, which is apparently seen in
> > the Windows driver for the PVR-150 w/a z8. This stabilizes what is
> > received from both the HD-PVR and HVR-1950, even with their polling
> > intervals at the default of 100, thus the removal of the custom
> > 260ms polling_interval in pvrusb2-i2c-core.c.
> > 
> > CC: Andy Walls <awalls@md.metrocast.net>
> > CC: Mike Isley <isley@isley.net>
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++++++
> >  drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
> >  2 files changed, 13 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> > index d2b20ad..a221ad6 100644
> > --- a/drivers/media/video/ir-kbd-i2c.c
> > +++ b/drivers/media/video/ir-kbd-i2c.c
> > @@ -128,6 +128,19 @@ static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> >  
> >  static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> >  {
> > +	int ret;
> > +	unsigned char buf[1] = { 0 };
> > +
> > +	/*
> > +	 * This is the same apparent "are you ready?" poll command observed
> > +	 * watching Windows driver traffic and implemented in lirc_zilog. With
> > +	 * this added, we get far saner remote behavior with z8 chips on usb
> > +	 * connected devices, even with the default polling interval of 100ms.
> > +	 */
> > +	ret = i2c_master_send(ir->c, buf, 1);
> > +	if (ret != 1)
> > +		return (ret < 0) ? ret : -EINVAL;
> > +
> >  	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
> >  }
> >  
> > diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > index ccc8849..451ecd4 100644
> > --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> > @@ -597,7 +597,6 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
> >  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> >  		init_data->type                  = RC_TYPE_RC5;
> >  		init_data->name                  = hdw->hdw_desc->description;
> > -		init_data->polling_interval      = 260; /* ms From lirc_zilog */
> >  		/* IR Receiver */
> >  		info.addr          = 0x71;
> >  		info.platform_data = init_data;
> > 
> 
> -- 
> 
> Mike Isely
> isely @ isely (dot) net
> PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

-- 
Jarod Wilson
jarod@redhat.com

