Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1ANVCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 16:02:23 -0500
Date: Fri, 14 Jan 2011 16:01:59 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH] hdpvr: reduce latency of i2c read/write w/recycled buffer
Message-ID: <20110114210159.GC9849@redhat.com>
References: <20110114200109.GB9849@redhat.com>
 <20110114213524.16a74206@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114213524.16a74206@endymion.delvare>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 14, 2011 at 09:35:24PM +0100, Jean Delvare wrote:
> Hi Jarod,
> 
> On Fri, 14 Jan 2011 15:01:09 -0500, Jarod Wilson wrote:
> > The current hdpvr code kmalloc's a new buffer for every i2c read and
> > write. Rather than do that, lets allocate a buffer in the driver's
> > device struct and just use that every time.
> > 
> > The size I've chosen for the buffer is the maximum size I could
> > ascertain might be used by either ir-kbd-i2c or lirc_zilog, plus a bit
> > of padding (lirc_zilog may use up to 100 bytes on tx, rounded that up
> > to 128).
> 
> Definitely a good move, as discussed on IRC earlier this week.
> 
> > Note that this might also remedy user reports of very sluggish behavior
> > of IR receive with hdpvr hardware.
> 
> Maybe. But the fact that the Zilog is unresponsive during processing of
> sent data certainly contributes to this feeling too.

I believe this was the case even when tx wasn't in use, so I'm hopeful.


> > diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> > index c0696c3..7f1a313 100644
> > --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> > +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> > @@ -57,23 +57,18 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
> >  			  unsigned char addr, char *data, int len)
> >  {
> >  	int ret;
> > -	char *buf = kmalloc(len, GFP_KERNEL);
> > -	if (!buf)
> > -		return -ENOMEM;
> >  
> >  	ret = usb_control_msg(dev->udev,
> >  			      usb_rcvctrlpipe(dev->udev, 0),
> >  			      REQTYPE_I2C_READ, CTRL_READ_REQUEST,
> > -			      (bus << 8) | addr, 0, buf, len, 1000);
> > +			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
> 
> Shouldn't you first ensure that len <= sizeof(dev->i2c_buf)? It should
> hopefully always be the case, but... if it isn't, you'll corrupt your
> data structure and possibly more.
...
> > @@ -81,31 +76,26 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, int bus,
> >  			   unsigned char addr, char *data, int len)
> >  {
> >  	int ret;
> > -	char *buf = kmalloc(len, GFP_KERNEL);
> > -	if (!buf)
> > -		return -ENOMEM;
> >  
> > -	memcpy(buf, data, len);
> > +	memcpy(&dev->i2c_buf, data, len);
> 
> Same here.

Yeah, while it *shouldn't* happen, making sure seems prudent. v2 in a
moment.

-- 
Jarod Wilson
jarod@redhat.com

