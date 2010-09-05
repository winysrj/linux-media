Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43963 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab0IESbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 14:31:01 -0400
Subject: Re: [PATCH] gspca_cpia1: Add lamp control for Intel Play QX3
 microscope
From: Andy Walls <awalls@md.metrocast.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C8353D3.3050708@redhat.com>
References: <1283476182.17527.4.camel@morgan.silverblock.net>
	 <4C8353D3.3050708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 14:30:41 -0400
Message-ID: <1283711441.2057.65.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 2010-09-05 at 10:24 +0200, Hans de Goede wrote:
> Hi,
> 
> p.s. (forgot to mention this in my previous mail)
> 
> On 09/03/2010 03:09 AM, Andy Walls wrote:
> 
> <snip>
> 
> > @@ -447,6 +449,20 @@
> >   		.set = sd_setcomptarget,
> >   		.get = sd_getcomptarget,
> >   	},
> > +	{
> > +		{
> > +#define V4L2_CID_LAMPS (V4L2_CID_PRIVATE_BASE+1)
> > +			.id	 = V4L2_CID_LAMPS,
> > +			.type    = V4L2_CTRL_TYPE_MENU,
> > +			.name    = "Lamps",
> > +			.minimum = 0,
> > +			.maximum = 3,
> > +			.step    = 1,
> > +			.default_value = 0,
> > +		},
> > +		.set = sd_setlamps,
> > +		.get = sd_getlamps,
> > +	},
> >   };
> >
> >   static const struct v4l2_pix_format mode[] = {
> 
> We only want this control to be available on the qx3 and not on
> all cpia1 devices,

Yes, I though about that, but couldn't think up a clean way of doing it
in the short amount of time I had available.  I did know that the
control was essentially a NoOp, so I wasn't too concerned at the time. 


>  so you need to add something like the following to
> sd_config:
> 
> 	if (!(id->idVendor == 0x0813 && id->idProduct == 0x0001))
> 		gspca_dev->ctrl_dis = 1 << LAMPS_IDX;
> 
> Where LAMPS_IDX is a define giving the index of V4L2_CID_LAMPS in the
> sd_ctrls array, see the ov519 gspca driver for example.

Thanks for the pointer, I'll have a look.

Regards,
Andy

> Regards,
> 
> Hans


