Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34710 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbcIBFZR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 01:25:17 -0400
Date: Fri, 02 Sep 2016 14:25:14 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 1/7] [media] rc-main: assign driver type during
 allocation
Message-id: <20160902052514.fmjk4mrhblztthzb@samsunx.samsung>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-2-andi.shyti@samsung.com>
 <CGME20160901212401epcas1p398150b4d46215d868997016db430c3c8@epcas1p3.samsung.com>
 <20160901212351.GB22198@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160901212351.GB22198@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> >  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> > -	dev = rc_allocate_device();
> > +	dev = rc_allocate_device(RC_DRIVER_IR_RAW);
> >  	if (!ir || !dev)
> >  		goto err_out_free;
> >  
> 
> If ir->sampling = 0 then it should be RC_DRIVER_SCANCODE.
> 
> 
> > @@ -481,7 +481,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
> >  	dev->scancode_mask = hardware_mask;
> >  
> >  	if (ir->sampling) {
> > -		dev->driver_type = RC_DRIVER_IR_RAW;
> >  		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
> >  	} else {
> >  		dev->driver_type = RC_DRIVER_SCANCODE;
> 
> That assignment shouldn't really be there any more.

I think this doesn't change the driver's behavior, because I
either do like:

  -   dev = rc_allocate_device();
  +   dev = rc_allocate_device(RC_DRIVER_SCANCODE);

  [ ... ]

      if (ir->sampling) {
              dev->driver_type = RC_DRIVER_IR_RAW;
              dev->timeout = 10 * 1000 * 1000; /* 10 ms */
      } else {
   -          dev->driver_type = RC_DRIVER_SCANCODE;

Or I would need to do aftr the long switch...case statement

    +  if (ir->sampling) {
    +          dev = rc_allocate_device(RC_DRIVER_IR_RAW);
    +          ...
    +  } else {
    +          dev = rc_allocate_device(RC_DRIVER_SCANCODE);
    +          ...

I prefered the first way because it doesn't alter much the
driver.

> >  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> > -	rc = rc_allocate_device();
> > +	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
> >  	if (!ir || !rc) {
> >  		err = -ENOMEM;
> >  		goto err_out_free;
> 
> This is not correct, I'm afraid. If you look at the code you can see that
> if raw_decode is true, then it should be RC_DRIVER_IR_RAW.

Same here, the driver doesn't change the behavior. raw_decode can
be both 'true' or 'false' it's set as default RC_DRIVER_SCANCODE
and depending on value of raw_decode it's chaged to
RC_DRIVER_IR_RAW.

also in this case I can do

    +  if (raw_decode) {
    +          rc = rc_allocate_device(RC_DRIVER_IR_RAW);
    +          ...
    +  } else {
    +          rc = rc_allocate_device(RC_DRIVER_SCANCODE);
    +          ...

but also in this case my original approach doesn't add much
changes.

Thanks,
Andi
