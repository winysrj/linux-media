Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40916 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZBFT4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 14:56:34 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 6 Feb 2009 13:56:26 -0600
Subject: RE: [REVIEW][PATCH] LV8093: Add driver for LV8093 lens actuator.
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012A7949F1@dlee07.ent.ti.com>
In-Reply-To: <1233904456.1916.140.camel@tux.localhost>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]
> Sent: Friday, February 06, 2009 1:14 AM
> To: Curran, Dominic
> Cc: linux-media@vger.kernel.org
> Subject: Re: [REVIEW][PATCH] LV8093: Add driver for LV8093 lens actuator.
>
> Hello, Dominic
> May i make few comments ?
>
> On Wed, 2009-02-04 at 12:40 -0600, Dominic Curran wrote:
> > Hi
> > Below is a new driver for the LV8093 lens actuator.
> >
> > Of course all comments are welcome, however I have a specific issue that i
> am
> > concerned about...
<snip>

> > +   lens->v4l2_int_device = &lv8093_int_device;
> > +
> > +   lens->i2c_client = client;
> > +   i2c_set_clientdata(client, lens);
> > +
> > +   err = v4l2_int_device_register(lens->v4l2_int_device);
> > +   if (err) {
> > +           v4l_err(client, "Failed to Register "
> > +                  LV8093_NAME " as V4L2 device.\n");
> > +           i2c_set_clientdata(client, NULL);
> > +   } else {
> > +           printk(KERN_ERR "Registered " LV8093_NAME
> > +                   " as V4L2 device.\n");
>
> This is cool :)
> First, it's better to use v4l_err here (because you use v4l_err in
> module).
> Second, it should be not KERN_ERR nor v4l_err! Your code says that you
> want printk(KERN_INFO "message") (see also comments below)
> Third, this two lines (if joined) fit to 80 symbols.

[DC] Agreed.



> > +static int __init lv8093_init(void)
> > +{
> > +   int err;
> > +
> > +   err = i2c_add_driver(&lv8093_i2c_driver);
> > +   if (err)
> > +           goto fail;
> > +   printk(KERN_INFO "Registered " LV8093_NAME
> > +           " as i2c device.\n");
>
> Well, i don't know if this is really important, but i saw in different
> e-mails that developers prefer to use one interface for messages
> everywhere in driver. I mean that you use pr_info and printk
> (KERN_INFO.. If you switch to one interface it becames more comfortable
> to read code.
>
> If you decide to use pr_info you can also use pr_err for your
> convenience.

[DC] Agreed.

Thanks for your comments.
