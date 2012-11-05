Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34317 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751088Ab2KEOEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 09:04:37 -0500
Date: Mon, 5 Nov 2012 16:04:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [RFC 4/4] v4l: Tell user space we're using monotonic timestamps
Message-ID: <20121105140432.GD25623@valkosipuli.retiisi.org.uk>
References: <20121024181602.GD23933@valkosipuli.retiisi.org.uk>
 <1351102583-682-4-git-send-email-sakari.ailus@iki.fi>
 <6800416.KHKIF7a4Tv@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6800416.KHKIF7a4Tv@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Nov 04, 2012 at 01:07:25PM +0100, Laurent Pinchart wrote:
> On Wednesday 24 October 2012 21:16:23 Sakari Ailus wrote:
...
> > @@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb,
> > struct v4l2_buffer *b) /*
> >  	 * Clear any buffer state related flags.
> >  	 */
> > -	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
> > +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> > +	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 
> That's an issue. Drivers that use videobuf2 would always be restricted to 
> monotonic timestamps in the future, even if they provide support for a device-
> specific clock.
> 
> Would it instead make sense to pass a v4l2_buffer pointer to 
> v4l2_get_timestamp() and set the monotonic flag there ? Not all callers of 
> v4l2_get_timestamp() might have a v4l2_buffer pointer though.

For now, this patch assumes that all the VB2 users will use monotonic
timestamps only. Once we have a good use case for different kind of
timestamps and have agreed how to implement them, I was thinking of adding a
similar function to v4l2_get_timestamp() but which would be VB2-aware, with
one argument being the timestamp type. That function could then get the
timestamp and apply the relevant flags.

Do you think it'd be enough to support changeable timestamp type for drivers
using VB2 only?

Alternatively we could make v4l2_get_timestamp() v4l2_buffer-aware, and for
drivers that can't provide the buffer pointer we could just set the pointer
to NULL, and v4l2_get_timestamp() could ignore it. The driver would then be
responsible for setting the right flags to the buffer on its own. As far as
I understand, this is essentially what you proposed.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
