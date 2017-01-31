Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36674
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751910AbdAaNBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 08:01:18 -0500
Date: Tue, 31 Jan 2017 11:01:11 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Tuukka Toivonen <tuukkat76@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.11] Add et8ek8 driver
Message-ID: <20170131110111.06321f77@vento.lan>
In-Reply-To: <20170131124534.GW7139@valkosipuli.retiisi.org.uk>
References: <20170125140745.GH7139@valkosipuli.retiisi.org.uk>
        <20170131104248.4e0f0bd8@vento.lan>
        <20170131124534.GW7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 31 Jan 2017 14:45:34 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Jan 31, 2017 at 10:42:48AM -0200, Mauro Carvalho Chehab wrote:
> > That added a new warning:
> > 
> > drivers/media/i2c/et8ek8/et8ek8_driver.c: In function 'et8ek8_registered':
> > drivers/media/i2c/et8ek8/et8ek8_driver.c:1262:29: warning: variable 'format' set but not used [-Wunused-but-set-variable]
> >   struct v4l2_mbus_framefmt *format;
> >                              ^~~~~~
> > compilation succeeded
> > 
> > 
> > The driver is calling this function and storing it on a var
> > that is not used:
> > 
> >         format = __et8ek8_get_pad_format(sensor, NULL, 0,
> >                                          V4L2_SUBDEV_FORMAT_ACTIVE);
> >         return 0;
> > 
> > Please send a fixup patch.  
> 
> I compiled it, too, but I guess I had a GCC version that didn't complain
> about this particular matter. I'll send you a fix.

I run make with "W=1", to enable a few extra warnings that are usually
troubles, like the above. W=2 would point some other things, but
IMHO, it is not worth trying to fix the extra warnings, as it will enable
a lot of signed/unsigned errors with are usually OK.

Thanks,
Mauro
