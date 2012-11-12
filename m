Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42592 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2KLMQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 07:16:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [RFC 4/4] v4l: Tell user space we're using monotonic timestamps
Date: Mon, 12 Nov 2012 13:17:31 +0100
Message-ID: <2245780.DkC4JqNsLp@avalon>
In-Reply-To: <20121108223340.GH25623@valkosipuli.retiisi.org.uk>
References: <20121024181602.GD23933@valkosipuli.retiisi.org.uk> <6798781.iK5M8mTgMg@avalon> <20121108223340.GH25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 09 November 2012 00:33:40 Sakari Ailus wrote:
> On Thu, Nov 08, 2012 at 01:18:15PM +0100, Laurent Pinchart wrote:
> > On Monday 05 November 2012 16:04:32 Sakari Ailus wrote:
> > > On Sun, Nov 04, 2012 at 01:07:25PM +0100, Laurent Pinchart wrote:
> > > > On Wednesday 24 October 2012 21:16:23 Sakari Ailus wrote:
> > > ...
> > > 
> > > > > @@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer
> > > > > *vb,
> > > > > struct v4l2_buffer *b) /*
> > > > > 
> > > > >  	 * Clear any buffer state related flags.
> > > > >  	 */
> > > > > 
> > > > > -	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
> > > > > +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> > > > > +	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > > > 
> > > > That's an issue. Drivers that use videobuf2 would always be restricted
> > > > to monotonic timestamps in the future, even if they provide support
> > > > for a device- specific clock.
> > > > 
> > > > Would it instead make sense to pass a v4l2_buffer pointer to
> > > > v4l2_get_timestamp() and set the monotonic flag there ? Not all
> > > > callers of v4l2_get_timestamp() might have a v4l2_buffer pointer
> > > > though.
> > > 
> > > For now, this patch assumes that all the VB2 users will use monotonic
> > > timestamps only. Once we have a good use case for different kind of
> > > timestamps and have agreed how to implement them, I was thinking of
> > > adding a similar function to v4l2_get_timestamp() but which would be
> > > VB2-aware, with one argument being the timestamp type. That function
> > > could then get the timestamp and apply the relevant flags.
> > > 
> > > Do you think it'd be enough to support changeable timestamp type for
> > > drivers using VB2 only?
> > 
> > Given that there's no reason to use anything else than VB2 in V4L2
> > drivers, I don't see any problem there.
> > 
> > How would that work in practice ? You won't be able to override the
> > timestamp type flag unconditionally in __fill_v4l2_buffer() anymore.
> 
> The vb2 already stores struct v4l2_buffer, but unfortunately driver's
> queue_setup() is called before alloctaing buffer objects, or after if less
> buffers can be allocated that way.
> 
> The information could be stored in the buffer queue itself. That'd likely
> make it the easies for the drivers: otherwise drivers need to be involed
> e.g. in querybuf.
> 
> What do you think?

I don't foresee any need for per-buffer timestamps for now, so I would be fine 
with a per-queue flag.

-- 
Regards,

Laurent Pinchart

