Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3227 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2KPP7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 10:59:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/4] v4l: Define video buffer flags for timestamp types
Date: Fri, 16 Nov 2012 16:58:54 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk> <201211161451.29922.hverkuil@xs4all.nl> <20121116152002.GD29863@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121116152002.GD29863@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161658.54968.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri November 16 2012 16:20:03 Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the comments!
> 
> On Fri, Nov 16, 2012 at 02:51:29PM +0100, Hans Verkuil wrote:
> > On Thu November 15 2012 23:06:44 Sakari Ailus wrote:
> > > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > > index 7e2f3d7..d598f2c 100644
> > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > @@ -938,6 +938,31 @@ Typically applications shall use this flag for output buffers if the data
> > >  in this buffer has not been created by the CPU but by some DMA-capable unit,
> > >  in which case caches have not been used.</entry>
> > >  	  </row>
> > > +	  <row>
> > > +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
> > > +	    <entry>0xe000</entry>
> > > +	    <entry>Mask for timestamp types below. To test the
> > > +	    timestamp type, mask out bits not belonging to timestamp
> > > +	    type by performing a logical and operation with buffer
> > > +	    flags and timestamp mask.</tt> </entry>
> > > +	  </row>
> > > +	  <row>
> > > +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN</constant></entry>
> > > +	    <entry>0x0000</entry>
> > > +	    <entry>Unknown timestamp type. This type is used by
> > > +	    drivers before Linux 3.8 and may be either monotonic (see
> > > +	    below) or realtime. Monotonic clock has been favoured in
> > > +	    embedded systems whereas most of the drivers use the
> > > +	    realtime clock.</entry>
> > 
> > Isn't 'wallclock time' a better expression? It is probably a good idea as
> > well to add the userspace call that gives the same clock: gettimeofday or
> > clock_gettime(CLOCK_REALTIME) for the wallclock time and
> > clock_gettime(CLOCK_MONOTONIC) for the monotonic time. That way apps can
> > do the same call and compare it to the timestamp received.
> 
> I'll add a reference to clock_gettime() and change realtime to wall clock
> time. I wonder if I should also add that the unknown timestamp means either
> of the two, or can we allow different kinds of unknown timestamps in the
> future.

No. UNKNOWN should never be used in the future. It is specific to the pre
timestamp flag era where the timestamp is really only one of two options.

Regards,

	Hans
