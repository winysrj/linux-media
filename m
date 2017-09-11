Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53120 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750782AbdIKOPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 10:15:47 -0400
Date: Mon, 11 Sep 2017 17:15:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v10 19/24] v4l: fwnode: Add convenience function for
 parsing common external refs
Message-ID: <20170911141543.phkw3heyb2er2ozz@valkosipuli.retiisi.org.uk>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-20-sakari.ailus@linux.intel.com>
 <20170911111746.GC28095@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911111746.GC28095@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 01:17:46PM +0200, Pavel Machek wrote:
> On Mon 2017-09-11 11:00:03, Sakari Ailus wrote:
> > Add v4l2_fwnode_parse_reference_sensor_common for parsing common
> > sensor properties that refer to adjacent devices such as flash or lens
> > driver chips.
> > 
> > As this is an association only, there's little a regular driver needs to
> > know about these devices as such.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-fwnode.h           | 13 +++++++++++++
> >  2 files changed, 48 insertions(+)
> > 
> >  
> > +/**
> > + * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> > + *					       sensors for async sub-devices
> > + * @dev: the device node the properties of which are parsed for references
> > + * @notifier: the async notifier where the async subdevs will be added
> > + *
> > + * Return: 0 on success
> > + *	   -ENOMEM if memory allocation failed
> > + *	   -EINVAL if property parsing failed
> > + */
> 
> Returns: would sound more correct to me, but it seems kernel is split
> on that.

I think in V4L2 there are roughly as many of each instances. I'll keep it
as it is.

> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
