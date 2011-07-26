Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3687 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1GZJsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 05:48:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] Binning on sensors
Date: Tue, 26 Jul 2011 11:47:59 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <20110714113201.GD27451@valkosipuli.localdomain> <201107151338.35639.laurent.pinchart@ideasonboard.com> <20110715124626.GK27451@valkosipuli.localdomain>
In-Reply-To: <20110715124626.GK27451@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261147.59890.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 15, 2011 14:46:26 Sakari Ailus wrote:
> On Fri, Jul 15, 2011 at 01:38:35PM +0200, Laurent Pinchart wrote:
> > On Thursday 14 July 2011 19:56:10 Guennadi Liakhovetski wrote:
> > > On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > > > Hi all,
> > > > 
> > > > I was thinking about the sensor binning controls.
> > > 
> > > What wrong with just doing S_FMT on the subdev pad? Binning does in fact
> > > implement scaling.
> > 
> > That's indeed one solution. The downside, compared to controls, is that a 
> > sensor that implements binning, skipping and scaling would need to expose 3 
> > entities, to let applications configure them 3 "scalers" independently. If 
> > binning and skipping were implemented as controls (which might not be a good 
> > idea, I still haven't made up my mind on this), a single entity would 
> > (probably) be enough.
> 
> Different hardware may do these operations in a different order. Scaling
> should be the last, but I'm not sure if that holds for all hardware. The
> order will affect the end result, and likely also to user's decision on
> configuration.
> 
> However, when one considers such decisions (s)he typically has otherwise a
> very good understanding of the hardware and thus knows the order of these
> operations.
> 
> 

Hmm, this was discussed already during the cropping/pipeline configuration
brainstorm:

http://www.spinics.net/lists/linux-media/msg34541.html

The suggestion was to add an S_FRAMESIZE ioctl to select one size in the
ENUM_FRAMESIZES list. Each size in that list defines a specific binning and
skipping combination. With S_FMT you can select the output size (and thus
the scaler if there is one).

This approach does not allow you to select whether you want binning or
skipping. It should select what gives the best results. If there is a
need to select between binning or skipping, then controls can be added
that select which approach should be used.

An alternative approach might be to add a flags field to struct
v4l2_frmsize_discrete that shows whether binning or skipping is used and
add the same flags to the S_FRAMESIZE ioctl.

Actually, I think that is nicer than adding more controls.

Regards,

	Hans
