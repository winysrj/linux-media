Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36711 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2AJKFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 05:05:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [ANN] Notes on IRC meeting on new sensor control interface, 2012-01-09 14:00 GMT+2
Date: Tue, 10 Jan 2012 11:05:48 +0100
Cc: linux-media@vger.kernel.org, tuukkat76@gmail.com,
	dacohen@gmail.com, g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	snjw23@gmail.com
References: <20120104085633.GM3677@valkosipuli.localdomain> <201201101050.52887.laurent.pinchart@ideasonboard.com> <4F0C0A5A.9060708@iki.fi>
In-Reply-To: <4F0C0A5A.9060708@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201101105.49477.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 10 January 2012 10:52:26 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 10 January 2012 10:42:58 Sakari Ailus wrote:
> >> Laurent Pinchart wrote:
> >>> On Tuesday 10 January 2012 00:26:46 Sakari Ailus wrote:
> >>>> Laurent Pinchart wrote:
> >>>>> On Monday 09 January 2012 23:32:06 Sakari Ailus wrote:
> >>>>>> Laurent Pinchart wrote:
> >>>>>>> On Monday 09 January 2012 18:38:25 Sakari Ailus wrote:
> >>>> ...
> >>>> 
> >>>>>>>> A fourth section may be required as well: at this level the frame
> >>>>>>>> rate (or frame time) range makes more sense than the low-level
> >>>>>>>> blanking values. The blanking values can be calculated from the
> >>>>>>>> frame time and a flag which tells whether either horizontal or
> >>>>>>>> vertical blanking should be preferred.
> >>>>>>> 
> >>>>>>> How does one typically select between horizontal and vertical
> >>>>>>> blanking ? Do mixed modes make sense ?
> >>>>>> 
> >>>>>> There are minimums and maximums for both. You can increase the frame
> >>>>>> time by increasing value for either or both of them --- to achieve
> >>>>>> very long frame times you may have to use both, but that's not very
> >>>>>> common in practice. I think we should have a flag to tell which one
> >>>>>> should be increased first --- the effect would be to have the
> >>>>>> minimum possible value on the other.
> >>>>> 
> >>>>> But how do you decide in practice which one to increase when you're
> >>>>> an application (or middleware) developer ?
> >>>> 
> >>>> I think it's the responsibility of this library to do that, unless the
> >>>> user wants really, really precise control in which case they have to
> >>>> deal with the blanking values directly. In general it should be the
> >>>> library.
> >>> 
> >>> And how does the library decide ? :-)
> >> 
> >> frame_time = pixel_rate / ((width + hblank) * (height + vblank))
> >> 
> >> The user gives you frame time and the configuration contains the
> >> information which one to prefer. Let's say the user prefers hblank (from
> > 
> >> the above):
> > That was my question, how does the user decide whether hblank or vblank
> > is preferred ?
> 
> I think that should be defined in the configuration itself. It's very
> unlikely there's any need to change this dynamically.

Sure, but that's not my point. How does the user decide in the first place 
when writing the configuration ?

-- 
Regards,

Laurent Pinchart
