Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35123
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753239AbdGSU4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 16:56:10 -0400
Date: Wed, 19 Jul 2017 17:56:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 5/8] v4l: Add support for CSI-1 and CCP2 busses
Message-ID: <20170719175602.567e2eae@vento.lan>
In-Reply-To: <20170719205329.akt2tcspq7ri3xh4@valkosipuli.retiisi.org.uk>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
        <20170705230019.5461-6-sakari.ailus@linux.intel.com>
        <20170719163751.3fd7c891@vento.lan>
        <20170719205329.akt2tcspq7ri3xh4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Jul 2017 23:53:30 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Wed, Jul 19, 2017 at 04:37:51PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu,  6 Jul 2017 02:00:16 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> > > From: Sakari Ailus <sakari.ailus@iki.fi>
> > > 
> > > CCP2 and CSI-1, are older single data lane serial busses.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > ---
> > >  drivers/media/platform/pxa_camera.c              |  3 ++
> > >  drivers/media/platform/soc_camera/soc_mediabus.c |  3 ++
> > >  drivers/media/v4l2-core/v4l2-fwnode.c            | 58 +++++++++++++++++++-----
> > >  include/media/v4l2-fwnode.h                      | 19 ++++++++
> > >  include/media/v4l2-mediabus.h                    |  4 ++
> > >  5 files changed, 76 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> > > index 399095170b6e..17e797c9559f 100644
> > > --- a/drivers/media/platform/pxa_camera.c
> > > +++ b/drivers/media/platform/pxa_camera.c
> > > @@ -638,6 +638,9 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
> > >  		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
> > >  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
> > >  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> > > +	default:
> > > +		__WARN();
> > > +		return -EINVAL;
> > >  	}
> > >  	return 0;
> > >  }
> > > diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> > > index 57581f626f4c..43192d80beef 100644
> > > --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> > > +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> > > @@ -508,6 +508,9 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
> > >  		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
> > >  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
> > >  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> > > +	default:
> > > +		__WARN();
> > > +		return -EINVAL;
> > >  	}
> > >  	return 0;
> > >  }
> > > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > > index d71dd3913cd9..76a88f210cb6 100644
> > > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > > @@ -154,6 +154,31 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
> > >  
> > >  }
> > >  
> > > +void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
> > > +					 struct v4l2_fwnode_endpoint *vep,
> > > +					 u32 bus_type)
> > > +{
> > > +       struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
> > > +       u32 v;
> > > +
> > > +       if (!fwnode_property_read_u32(fwnode, "clock-inv", &v))
> > > +               bus->clock_inv = v;
> > > +
> > > +       if (!fwnode_property_read_u32(fwnode, "strobe", &v))
> > > +               bus->strobe = v;
> > > +
> > > +       if (!fwnode_property_read_u32(fwnode, "data-lanes", &v))
> > > +               bus->data_lane = v;
> > > +
> > > +       if (!fwnode_property_read_u32(fwnode, "clock-lanes", &v))
> > > +               bus->clock_lane = v;
> > > +
> > > +       if (bus_type == V4L2_FWNODE_BUS_TYPE_CCP2)
> > > +	       vep->bus_type = V4L2_MBUS_CCP2;
> > > +       else
> > > +	       vep->bus_type = V4L2_MBUS_CSI1;
> > > +}
> > > +  
> > 
> > This function is indented with whitespaces! Next time, please check with
> > checkpatch.
> > 
> > I fixed when merging it upstream.  
> 
> Well, what can I say?
> 
> Apologies for the collateral damage, and thanks! :-)

Nevermind. From time to time, I end fixing small things like this
while merging ;)

I suspect that you cut and paste this function from some other
place, as all lines inside it started with 7 spaces...

Regards,
Mauro
