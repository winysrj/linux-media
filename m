Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33681 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbcCCNDD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 08:03:03 -0500
Date: Thu, 3 Mar 2016 10:02:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: Insu Yun <wuninsu@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
Subject: Re: [PATCH] rc: correctly handling failed allocation
Message-ID: <20160303100256.48cbdf45@recife.lan>
In-Reply-To: <20160216105454.GA7378@gofer.mess.org>
References: <1455589991-7795-1-git-send-email-wuninsu@gmail.com>
	<20160216105454.GA7378@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Feb 2016 10:54:54 +0000
Sean Young <sean@mess.org> escreveu:

> On Mon, Feb 15, 2016 at 09:33:11PM -0500, Insu Yun wrote:
> > Since rc_allocate_device() uses kmalloc,
> > it can returns NULL, so need to check, 
> > otherwise, NULL derefenrece can be happened.  
> 
> Thanks for catching that.
> 
> > Signed-off-by: Insu Yun <wuninsu@gmail.com>
> > ---
> >  drivers/media/rc/igorplugusb.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
> > index b36e515..df37cd5 100644
> > --- a/drivers/media/rc/igorplugusb.c
> > +++ b/drivers/media/rc/igorplugusb.c
> > @@ -191,6 +191,8 @@ static int igorplugusb_probe(struct usb_interface *intf,
> >  	usb_make_path(udev, ir->phys, sizeof(ir->phys));
> >  
> >  	rc = rc_allocate_device();
> > +	if (!rc)
> > +		goto fail;  
> 
> At this point, ret is not initialized but will be used in the error path.

Also, it should be setting "ret", like like:

	if (!rc) {
		ret = -ENOMEM;
		goto fail;
	}



> 
> >  	rc->input_name = DRIVER_DESC;
> >  	rc->input_phys = ir->phys;
> >  	usb_to_input_id(udev, &rc->input_id);
> > @@ -213,6 +215,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
> >  	ir->rc = rc;
> >  	ret = rc_register_device(rc);
> >  	if (ret) {  
> 
> I'm not sure how common it is to goto into another nesting level for an
> error path.

I can't remember a single case where we do that. Putting fail at the
end is indeed the clearer way of handling it.

> Also I just noticed that the code is leaking the timer in
> the error path.
> 
> It might be better to put the "fail:" at the end after the last return
> for the successful case, and have a goto to it after both
> rc_allocate_device() and rc_register_device() in case they fail.
> 
> > +fail:
> >  		dev_err(&intf->dev, "failed to register rc device: %d", ret);
> >  		rc_free_device(rc);
> >  		usb_free_urb(ir->urb);
> > -- 
> > 1.9.1  
> 
> Thanks
> Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
