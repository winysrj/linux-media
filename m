Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46226 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751902AbdEKO7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 10:59:50 -0400
Date: Thu, 11 May 2017 17:59:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170511145913.GI3227@valkosipuli.retiisi.org.uk>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <CGME20170511143945epcas1p26203dff026b3dc9c2f65c5ca0be7967b@epcas1p2.samsung.com>
 <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 11, 2017 at 04:39:41PM +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 05/11/2017 08:30 AM, Tomasz Figa wrote:
> >> +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >> +{
> >> +       struct dw9714_device *dw9714_dev = container_of(sd,
> >> +                                                       struct dw9714_device,
> >> +                                                       sd);
> >> +       struct device *dev = &dw9714_dev->client->dev;
> >> +       int rval;
> >> +
> >> +       rval = pm_runtime_get_sync(dev);
> >> +       if (rval >= 0)
> >> +               return 0;
> >> +
> >> +       pm_runtime_put(dev);
> >> +       return rval;
> >>
> > nit: The typical coding style is to return early in case of a special
> > case and keep the common path linear, i.e.
> > 
> >     rval = pm_runtime_get_sync(dev);
> >     if (rval < 0) {
> >         pm_runtime_put(dev);
> >         return rval;
> >     }
> 
> Aren't we supposed to call pm_runtime_put() only when corresponding 
> pm_runtime_get() succeeds? I think the pm_runtime_put() call above
> is not needed. 

pm_runtime_get() increments the usage_count independently of whether it
succeeded. See __pm_runtime_resume().

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
