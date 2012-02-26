Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2BZO2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 09:28:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH 01/11] v4l: Add driver for Micron MT9M032 camera sensor
Date: Sun, 26 Feb 2012 15:28:29 +0100
Message-ID: <1684336.vSGXv4O9Ho@avalon>
In-Reply-To: <CAOMZO5B9=fGGWMxKfr+DfRmSHj4CExS5d5WTzXT_EoH2L=LG2A@mail.gmail.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com> <1330226857-8651-2-git-send-email-laurent.pinchart@ideasonboard.com> <CAOMZO5B9=fGGWMxKfr+DfRmSHj4CExS5d5WTzXT_EoH2L=LG2A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Thanks for the review.

On Sunday 26 February 2012 11:16:19 Fabio Estevam wrote:
> On Sun, Feb 26, 2012 at 12:27 AM, Laurent Pinchart wrote:
> > +static int __init mt9m032_init(void)
> > +{
> > +       int rval;
> > +
> > +       rval = i2c_add_driver(&mt9m032_i2c_driver);
> > +       if (rval)
> > +               pr_err("%s: failed registering " MT9M032_NAME "\n",
> > __func__); +
> > +       return rval;
> > +}
> > +
> > +static void mt9m032_exit(void)
> > +{
> > +       i2c_del_driver(&mt9m032_i2c_driver);
> > +}
> > +
> > +module_init(mt9m032_init);
> > +module_exit(mt9m032_exit);
> 
> module_i2c_driver could be used here instead.

That's fixed by patch 4/11. As explained in the cover letter, patch 01/11 is 
the original driver as submitted by Martin. I've decided not to change it to 
make review easier. I can then squash some of the other patches onto this one 
when pushing the set upstream. 
 
> > +
> > +MODULE_AUTHOR("Martin Hostettler");
> 
> E-mail address missing.

Good point. Martin, can I add your e-mail address here ?

-- 
Regards,

Laurent Pinchart
