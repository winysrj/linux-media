Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57254 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932711AbcA0Ojn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 09:39:43 -0500
Date: Wed, 27 Jan 2016 16:39:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] v4l: Add generic pipeline power management code
Message-ID: <20160127143939.GI14876@valkosipuli.retiisi.org.uk>
References: <1453902658-29783-1-git-send-email-sakari.ailus@iki.fi>
 <1453902658-29783-4-git-send-email-sakari.ailus@iki.fi>
 <56A8CE9C.8090302@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56A8CE9C.8090302@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 27, 2016 at 03:05:16PM +0100, Hans Verkuil wrote:
> On 01/27/16 14:50, Sakari Ailus wrote:
> > When the Media controller framework was merged, it was decided not to add
> > pipeline power management code for it was not seen generic. As a result, a
> > number of drivers have copied the same piece of code, with same bugfixes
> > done to them at different points of time (or not at all).
> > 
> > Add these functions to V4L2. Their use is optional for drivers.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-common.c | 174 ++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-common.h           |  37 ++++++++
> 
> I think I would prefer to see a v4l2-mc.c source rather than adding it to common.
> Since this is specific to both v4l2 and MC it only has to be compiled
> if both config options are set.
> 
> Besides, I think we need to move more common mc code to such a file.

Ok. I'll move these to a separate file.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
