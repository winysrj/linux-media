Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42686 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751504AbdBMKFv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 05:05:51 -0500
Date: Mon, 13 Feb 2017 12:05:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v2 4/4] media-ctl: add colorimetry support
Message-ID: <20170213100547.GH16975@valkosipuli.retiisi.org.uk>
References: <1486978408-28580-1-git-send-email-p.zabel@pengutronix.de>
 <1486978408-28580-4-git-send-email-p.zabel@pengutronix.de>
 <1958d6aa-b5ba-9e8f-aa34-d08a54843c47@xs4all.nl>
 <20170213094823.GG16975@valkosipuli.retiisi.org.uk>
 <1486980162.2873.33.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486980162.2873.33.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 13, 2017 at 11:02:42AM +0100, Philipp Zabel wrote:
> On Mon, 2017-02-13 at 11:48 +0200, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Mon, Feb 13, 2017 at 10:40:41AM +0100, Hans Verkuil wrote:
> > ...
> > > > @@ -839,6 +951,157 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string)
> > > >  	return (enum v4l2_field)-1;
> > > >  }
> > > >  
> > > > +static struct {
> > > > +	const char *name;
> > > > +	enum v4l2_colorspace colorspace;
> > > > +} colorspaces[] = {
> > > > +	{ "default", V4L2_COLORSPACE_DEFAULT },
> > > > +	{ "smpte170m", V4L2_COLORSPACE_SMPTE170M },
> > > > +	{ "smpte240m", V4L2_COLORSPACE_SMPTE240M },
> > > > +	{ "rec709", V4L2_COLORSPACE_REC709 },
> > > > +	{ "bt878", V4L2_COLORSPACE_BT878 },
> > > 
> > > Drop this, it's no longer used in the kernel.
> > 
> > What about older kernels? Were there drivers that reported it?
> 
> Has there ever been a v4l2 subdevice that reported bt878 colorspace on a
> pad via VIDIOC_SUBDEV_G_FMT?

Based on Hans's reply, no. So let's remove that.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
