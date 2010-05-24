Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1324 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0EXKAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 06:00:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH 03/15] [RFCv2] Documentation: add v4l2-controls.txt documenting the new controls API.
Date: Mon, 24 May 2010 12:01:42 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <cover.1274015084.git.hverkuil@xs4all.nl> <201005240117.35431.laurent.pinchart@ideasonboard.com> <1274660109.2275.51.camel@localhost>
In-Reply-To: <1274660109.2275.51.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241201.42885.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 24 May 2010 02:15:08 Andy Walls wrote:
> On Mon, 2010-05-24 at 01:17 +0200, Laurent Pinchart wrote:
> > Hi Hans,
> > 
> 
> > > +Proposals for Extensions
> > > +========================
> > > +
> > > +Some ideas for future extensions to the spec:
> > > +
> > > +1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
> > > +decimal. Useful for e.g. video_mute_yuv.
> > 
> > Shown where ?
> 
> In the output of `v4l2-ctl -L` or any other app that builds controls for
> the user to see.  This is really just a formatting hint for the
> application, analogous to "%x" in a printf() format.  I think there may
> be a larger issue of control formatting hints here.
> 
> 
> 
> So now for a digression:
> 
> video_mute_yuv is both a very good and bad example:
> 
> $ v4l2-ctl -L
> ...
> video_mute_yuv (int)  : min=0 max=16777215 step=1 default=32896 value=32896
> ...
> 
> The value is YUV values encoded as 0x00YYUUVV.  For the cx18 driver the
> default is 32869 or 0x008080 (no luminance and neutral red and blue
> chrominance).  A hex readout makes the control setting more readable.  
> 
> But even with improved formatting, this control is a still poor UI
> element.  Most people can't map a color word, like "green", to a (Y, U,
> V) coordinate easily.
> 
> I'll assert
> 
> a. a menu with a few human-readable color names would be more useful

True, but not as flexible.
 
> or
> 
> b. the control could really be broken up into three separate sliders,
> obviating the need for the HEX formatting hint. Just because the MPEG
> encoding engine wants it set as one value, doesn't mean humans must set
> it that way.

Hmm, I don't really like this idea. What you really want to communicate
is that this is a color. How it is represented in a user interface is up
to the application.

So:

c. we add a V4L2_CTRL_FLAG_COLOR flag.

The problem is: how do you specify the colorspace and possibly color depth.

And perhaps there is an alpha channel as well.

The reason I went with a simple hex flag is that it is, well, simple. It
greatly improves the readability of colors and other values that are more
easily readable in hex format, without introducing the complexity that
you get once you start talking about colors.

Right now all the color controls that we have are in the 'advanced user'
category so I would be happy with just providing a hex flag.

Should color controls become much more important, then we can revisit this
and make true color controls.

Obviously, if someone wants to make a proposal for this now, then feel free.
But I don't think it's worth the time and effort.

Regards,

	Hans
 
> I suppose since it's in ivtv and cx18, it's mine to fix. :)
> 
> Regards,
> Andy
> 
> 
> > > +2) It is possible to mark in the controls array which controls have been
> > > +successfully written and which failed by for example adding a bit to the
> > > +control ID. Not sure if it is worth the effort, though.
> > 
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
