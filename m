Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27608 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbeJCR2Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 13:28:24 -0400
Date: Wed, 3 Oct 2018 13:40:32 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>, jacopo@jmondi.org
Subject: Re: [PATCH v3 2/2] [media] imx214: Add imx214 camera sensor driver
Message-ID: <20181003104032.gesivjmiwf364ot3@paasikivi.fi.intel.com>
References: <20181002133058.12942-1-ricardo.ribalda@gmail.com>
 <20181002133058.12942-2-ricardo.ribalda@gmail.com>
 <20181002162438.zia2pwztd6vuqme2@paasikivi.fi.intel.com>
 <CAPybu_1B+zAasFuiRrhByXaVGz6KfuBxXJYWRwBM-CL8Bh6C=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_1B+zAasFuiRrhByXaVGz6KfuBxXJYWRwBM-CL8Bh6C=g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wed, Oct 03, 2018 at 09:17:56AM +0200, Ricardo Ribalda Delgado wrote:
> HI Sakari
> 
> Thanks a lot for your review!
> 
> On Tue, Oct 2, 2018 at 6:27 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > > +static int imx214_s_power(struct v4l2_subdev *sd, int on)
> > > +{
> > > +     struct imx214 *imx214 = to_imx214(sd);
> > > +     int ret = 0;
> > > +
> > > +     on = !!on;
> > > +
> > > +     if (imx214->power_on == on)
> > > +             return 0;
> > > +
> > > +     if (on)
> > > +             ret = imx214_set_power_on(imx214);
> > > +     else
> > > +             imx214_set_power_off(imx214);
> > > +
> > > +     imx214->power_on = on;
> > > +
> > > +     return 0;
> >
> > Using runtime PM would relieve you of this function.
> 
> Tried using runtime PM, but did not manage to get it working with the
> qcom i2c driver. Will try again when this is merged on a separated
> patch.

Interesting. With runtime PM, also the parent device will be powered on
automatically. Usually that's what's needed after all.

Could you post the changes you made?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
