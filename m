Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54789 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750890AbdE3KRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 06:17:38 -0400
Message-ID: <1496139454.5485.2.camel@pengutronix.de>
Subject: Re: [PATCH v7 2/3] [media] add mux and video interface bridge
 entity functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Rosin <peda@axentia.se>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 30 May 2017 12:17:34 +0200
In-Reply-To: <20170529203826.GJ29527@valkosipuli.retiisi.org.uk>
References: <1496070731-12611-1-git-send-email-p.zabel@pengutronix.de>
         <1496070731-12611-2-git-send-email-p.zabel@pengutronix.de>
         <20170529203826.GJ29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Mon, 2017-05-29 at 23:38 +0300, Sakari Ailus wrote:
[...]
> > diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
> > index 2a5164aea2b40..1d15542f447c1 100644
> > --- a/Documentation/media/uapi/mediactl/media-types.rst
> > +++ b/Documentation/media/uapi/mediactl/media-types.rst
> > @@ -299,6 +299,28 @@ Types and flags used to represent the media graph elements
> >  	  received on its sink pad and outputs the statistics data on
> >  	  its source pad.
> >  
> > +    -  ..  row 29
> > +
> > +       ..  _MEDIA-ENT-F-VID-MUX:
> > +
> > +       -  ``MEDIA_ENT_F_VID_MUX``
> > +
> > +       - Video multiplexer. An entity capable of multiplexing must have at
> > +         least two sink pads and one source pad, and must pass the video
> > +         frame(s) received from the active sink pad to the source pad. Video
> > +         frame(s) from the inactive sink pads are discarded.
> 
> I don't think the last sentence is needed, I'd drop it as redundant. Up to
> you.

Thanks, I'll drop this sentence ...

> > +
> > +    -  ..  row 30
> > +
> > +       ..  _MEDIA-ENT-F-VID-IF-BRIDGE:
> > +
> > +       -  ``MEDIA_ENT_F_VID_IF_BRIDGE``
> > +
> > +       - Video interface bridge. A video interface bridge entity must have at
> > +         least one sink pad and one source pad. It receives video frames on
> 
> It's not clear whether there must be at least one source pad or one source
> pad. How about either:
> 
> "must have at least one sink pad and at least one source pad" or

... and change this to specify "at least one source pad".

> "must have at least one sink pad and exactly one source pad"?
> 
> With this considered,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[...]

regards
Philipp
