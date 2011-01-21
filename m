Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1AUOOT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 09:14:19 -0500
Date: Fri, 21 Jan 2011 09:14:12 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] hdpvr: fix up i2c device registration
Message-ID: <20110121141412.GB16585@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
 <1295584225-21210-2-git-send-email-jarod@redhat.com>
 <1295616898.2114.30.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295616898.2114.30.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 21, 2011 at 08:34:58AM -0500, Andy Walls wrote:
> On Thu, 2011-01-20 at 23:30 -0500, Jarod Wilson wrote:
> > We have to actually call i2c_new_device() once for each of the rx and tx
> > addresses. Also improve error-handling and device remove i2c cleanup.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> 
> I do have some comments, but the real show-stoppers are:
> 
> - '#if defined(..' for the i2c_del_adapter() in the error path
> - A very unlikely race by using file scope data
> 
> See below.
> 
> > ---
> >  drivers/media/video/hdpvr/hdpvr-core.c |   21 +++++++++++++++++----
> >  drivers/media/video/hdpvr/hdpvr-i2c.c  |   28 ++++++++++++++++++++--------
> >  drivers/media/video/hdpvr/hdpvr.h      |    6 +++++-
> >  3 files changed, 42 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> > index a6572e5..f617a23 100644
> > --- a/drivers/media/video/hdpvr/hdpvr-core.c
> > +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> > @@ -381,13 +381,21 @@ static int hdpvr_probe(struct usb_interface *interface,
> >  #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> >  	retval = hdpvr_register_i2c_adapter(dev);
> >  	if (retval < 0) {
> > -		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
> > +		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
> >  		goto error;
> >  	}
> >  
> > -	retval = hdpvr_register_i2c_ir(dev);
> > -	if (retval < 0)
> > -		v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");
> > +	hdpvr_register_ir_rx_i2c(dev);
> > +	if (!dev->i2c_rx) {
> > +		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> > +		goto reg_fail;
> > +	}
> > +
> > +	hdpvr_register_ir_tx_i2c(dev);
> > +	if (!dev->i2c_tx) {
> > +		v4l2_err(&dev->v4l2_dev, "i2c IR TX device register failed\n");
> > +		goto reg_fail;
> > +	}
> 
> Once your driver is debugged and complete, there is really never a need
> to save pointers to the i2c_clients.  You might want to consider having
> void hdpvr_register_ir_?x_i2c() instead return a pointer that you can
> check against NULL.

Yeah, I'd saved them when I was thinking I might need to call
i2c_unregister_device on driver removal, then debated dropping them, but
left them in, just in case. If you're certain there's never a particularly
good reason to keep them around, I'll drop them. An earlier iteration of
this patch did return a struct i2c_client for hdpvr_probe to check for
NULL.


> >  #endif
> >  
> >  	/* let the user know what node this device is now attached to */
> > @@ -395,6 +403,8 @@ static int hdpvr_probe(struct usb_interface *interface,
> >  		  video_device_node_name(dev->video_dev));
> >  	return 0;
> >  
> > +reg_fail:
> > +	i2c_del_adapter(&dev->i2c_adapter);
> 
> Don't you need an '#if defined(CONFIG_I2C)...' here, in case the symbol
> does not exist?

Crap, yeah, thought I was clever catching it in the remove path, missed it
here... :)


> > -static struct i2c_board_info hdpvr_i2c_board_info = {
> > +static struct i2c_board_info hdpvr_ir_tx_i2c_board_info = {
> >  	I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
> > +};
> 
> This does not need to be file scope.  (In fact this creates a hard to
> trigger race in the function below.)
> 
> It should be non-static function scope, as the I2C subsystem will make a
> copy of the string and address byte and the platform data pointer when
> you add the I2C device.    See pvrusb2.

Okay, will go with code that looks more like pvrusb2.

Thanks for the review, will get a v2 together shortly, sanity-check and
post it...

-- 
Jarod Wilson
jarod@redhat.com

