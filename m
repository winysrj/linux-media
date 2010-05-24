Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28568 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704Ab0EXA0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 20:26:48 -0400
Subject: Re: [PATCH 03/15] [RFCv2] Documentation: add v4l2-controls.txt
 documenting the new controls API.
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <201005240117.35431.laurent.pinchart@ideasonboard.com>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
	 <c4116a8d705331ab8086902841bea31d4aa50a1f.1274015085.git.hverkuil@xs4all.nl>
	 <201005240117.35431.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 20:15:08 -0400
Message-ID: <1274660109.2275.51.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-05-24 at 01:17 +0200, Laurent Pinchart wrote:
> Hi Hans,
> 

> > +Proposals for Extensions
> > +========================
> > +
> > +Some ideas for future extensions to the spec:
> > +
> > +1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
> > +decimal. Useful for e.g. video_mute_yuv.
> 
> Shown where ?

In the output of `v4l2-ctl -L` or any other app that builds controls for
the user to see.  This is really just a formatting hint for the
application, analogous to "%x" in a printf() format.  I think there may
be a larger issue of control formatting hints here.



So now for a digression:

video_mute_yuv is both a very good and bad example:

$ v4l2-ctl -L
...
video_mute_yuv (int)  : min=0 max=16777215 step=1 default=32896 value=32896
...

The value is YUV values encoded as 0x00YYUUVV.  For the cx18 driver the
default is 32869 or 0x008080 (no luminance and neutral red and blue
chrominance).  A hex readout makes the control setting more readable.  

But even with improved formatting, this control is a still poor UI
element.  Most people can't map a color word, like "green", to a (Y, U,
V) coordinate easily.

I'll assert

a. a menu with a few human-readable color names would be more useful

or

b. the control could really be broken up into three separate sliders,
obviating the need for the HEX formatting hint. Just because the MPEG
encoding engine wants it set as one value, doesn't mean humans must set
it that way.

I suppose since it's in ivtv and cx18, it's mine to fix. :)

Regards,
Andy


> > +2) It is possible to mark in the controls array which controls have been
> > +successfully written and which failed by for example adding a bit to the
> > +control ID. Not sure if it is worth the effort, though.
> 


