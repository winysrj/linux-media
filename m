Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60128 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731580AbeKMTiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:38:08 -0500
Date: Tue, 13 Nov 2018 11:40:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, jacopo@jmondi.org,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
Message-ID: <20181113094050.o2b4leihqwkbk3rb@valkosipuli.retiisi.org.uk>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1658112.YQ0khu1noY@avalon>
 <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
 <6518376.j8BxZoQUpz@avalon>
 <20180921120342.ku3ed3jkn5puavu6@valkosipuli.retiisi.org.uk>
 <CAAoAYcOQC37r=CC94qpGjaLu_R=QZoGF0z6A_zFOmMsG0AX_5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoAYcOQC37r=CC94qpGjaLu_R=QZoGF0z6A_zFOmMsG0AX_5A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

Apologies for the delay.

On Fri, Sep 21, 2018 at 02:46:23PM +0100, Dave Stevenson wrote:
> Hi Sakari
> 
> On Fri, 21 Sep 2018 at 13:03, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >
> > Hi Laurent,
> >
> > On Fri, Sep 21, 2018 at 01:01:09PM +0300, Laurent Pinchart wrote:
> > ...
> > > > There is also the oddball one of the TC358743 which dynamically
> > > > switches the number of lanes in use based on the data rate required.
> > > > That's probably a separate discussion, but is currently dealt with via
> > > > g_mbus_config as amended back in Sept 2017 [1].
> > >
> > > This falls into the case of dynamic configuration discovery and negotiation I
> > > mentioned above, and we clearly need to make sure the v4l2_subdev API supports
> > > this use case.
> >
> > This could be added to struct v4l2_mbus_frame_desc; Niklas has driver that
> > uses the framework support here, so this would likely end up merged soon:
> >
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/tree/include/media/v4l2-subdev.h?h=vc&id=0cbd2b25b37ef5b2e6a14340dbca6d2d2d5af98e>
> >
> > The CSI-2 bus parameters are missing there currently but nothing prevents
> > adding them. The semantics of set_frame_desc() needs to be probably defined
> > better than it currently is.
> 
> So which parameters are you thinking of putting in there? Just the
> number of lanes, or clocking modes and all other parameters for the
> CSI interface?

I think it could be the number of active lanes, I don't think other
parameters need to change.

> It sounds like this should take over from the receiver's DT
> completely, other than for lane reordering.

Hmm. Right now I don't have an opinion either way. But I'd like to know
what others think.

The endpoint configuration is currently local to the endpoint only. On
other busses than CSI-2 there are more parameters that may be different on
each side of the endpoint. If the parameters are moved to the frame
descriptor entirely, there's no way to e.g. validate them in probe. At
least one would need to show that this is not an issue, or address it
somehow.

> 
> Of course the $1million question is rough timescales? The last commit
> on there appears to be March 2017.
> I've had to backburner my CSI2 receiver driver due to other time
> pressures, so it sounds like I may as well leave it there until this
> all settles down, or start looking at Niklas' driver and what changes
> infers.

Yes; if you write patches to this, please do that on top of Niklas' set.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
