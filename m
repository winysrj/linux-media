Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53993 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751365Ab2G0V12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 17:27:28 -0400
Date: Sat, 28 Jul 2012 00:27:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] mt9v032: Export horizontal and vertical blanking as
 V4L2 controls
Message-ID: <20120727212723.GB26642@valkosipuli.retiisi.org.uk>
References: <1343068502-7431-4-git-send-email-laurent.pinchart@ideasonboard.com>
 <1343085042-19695-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120726205401.GA26136@valkosipuli.retiisi.org.uk>
 <4375414.cY8huNNgj1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4375414.cY8huNNgj1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Jul 27, 2012 at 01:02:04AM +0200, Laurent Pinchart wrote:
> On Thursday 26 July 2012 23:54:01 Sakari Ailus wrote:
> > On Tue, Jul 24, 2012 at 01:10:42AM +0200, Laurent Pinchart wrote:
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/video/mt9v032.c |   36 +++++++++++++++++++++++++++++++++---
> > >  1 files changed, 33 insertions(+), 3 deletions(-)
> > > 
> > > Changes since v1:
> > > 
> > > - Make sure the total horizontal time will not go below 660 when setting
> > >   the horizontal blanking control
> > > 
> > > - Restrict the vertical blanking value to 3000 as documented in the
> > >   datasheet. Increasing the exposure time actually extends vertical
> > >   blanking, as long as the user doesn't forget to turn auto-exposure
> > >   off...
> > 
> > Does binning either horizontally or vertically affect the blanking limits?
> > If the process is analogue then the answer is typically "yes".
> 
> The datasheet doesn't specify whether binning and blanking can influence each 
> other.

Vertical binning is often analogue since digital binning would require as
much temporary memory as the row holds pixels. This means the hardware
already does binning before a/d conversion and there's only need to actually
read half the number of rows, hence the effect on frame length.

> > It's not directly related to this patch, but the effect of the driver just
> > exposing one sub-device really shows better now. Besides lacking the way to
> > specify binning as in the V4L2 subdev API (compose selection target), the
> > user also can't use the crop bounds selection target to get the size of the
> > pixel array.
> > 
> > We could either accept this for the time being and fix it later on of fix it
> > now.
> > 
> > I prefer fixing it right now but admit that this patch isn't breaking
> > anything, it rather is missing quite relevant functionality to control the
> > sensor in a generic way.
> 
> I'd rather apply this patch first, as it doesn't break anything :-) Fixing the 
> problem will require discussions, and that will take time.

How so? There's nothing special in this sensor as far as I can see.

> Binning/skipping is a pretty common feature in sensors. Exposing two sub-
> devices like the SMIA++ driver does is one way to fix the problem, but do we 
> really want to do that for the vast majority of sensors ?

If we want to expose the sensor's functionality using the V4L2 subdev API
and not a sensor specific API, the answer is "yes". The bottom line is that
we have just one API to configure scaling and cropping and that API
(selections) is the same independently of where the operation is being
performed; whether it's the sensor or the ISP.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
