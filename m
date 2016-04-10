Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52768 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbcDJAAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2016 20:00:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 01/54] media: Add video processing entity functions
Date: Sun, 10 Apr 2016 03:00:18 +0300
Message-ID: <3329244.VKgFfDBBoD@avalon>
In-Reply-To: <5885130.y4A9fxS5bx@avalon>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160328230155.GE32125@valkosipuli.retiisi.org.uk> <5885130.y4A9fxS5bx@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Do you still have issues with this patch ?

On Tuesday 29 Mar 2016 10:40:05 Laurent Pinchart wrote:
> On Tuesday 29 Mar 2016 02:01:55 Sakari Ailus wrote:
> > On Fri, Mar 25, 2016 at 12:43:35PM +0200, Laurent Pinchart wrote:
> > > Add composer, format converter and scaler functions, as well as generic
> > > video processing to be used when no other processing function is
> > > applicable.
> > 
> > How are these intended to be used?
> > 
> > Say, if a sub-device implements functionality that matches more than one
> > of these, do you pick one?
> 
> The whole point of functions is that they're not mutually exclusive, and the
> full list of functions will be reported as properties for the entity. The
> function field of the media entity structure stores the main function only.
>
> > Supposedly you control at least some of this functionality using the
> > selections API, and frankly, I think the way it's currently defined in the
> > spec worked okay-ish for the devices at hand at the time, but defining
> > that the order of processing from the sink towards the source is sink
> > crop, sink compose and then source crop is not generic. We should have a
> > better way to tell this, using a similar API which is used to control the
> > functionality, just as is done with V4L2 controls.
> 
> Sure, but how is that related to this patch ? :-)
> 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/media-types.xml | 34 ++++++++++++++++++
> > >  include/uapi/linux/media.h                      |  8 ++++++
> > >  2 files changed, 42 insertions(+)

-- 
Regards,

Laurent Pinchart

