Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49708 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754047Ab3GBW5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 18:57:07 -0400
Date: Wed, 3 Jul 2013 01:57:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
Message-ID: <20130702225701.GN2064@valkosipuli.retiisi.org.uk>
References: <201305131414.43685.hverkuil@xs4all.nl>
 <1721198.ELRHSeN8Of@avalon>
 <20130622205800.GH2064@valkosipuli.retiisi.org.uk>
 <201306241540.14469.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306241540.14469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 24, 2013 at 03:40:14PM +0200, Hans Verkuil wrote:
...
> > Events that fit to regular 64 bytes will be delivered using that, and the
> > user-provided pointer will only be used in the case a large event is
> > delivered to the user. So in order to be able to receive large events, the
> > user must always provide the pointer even if it's not always used.
> 
> This is an option. The easiest approach would be to extend v4l2_kevent with
> a pointer to a struct v4l2_event_payload, which would be refcounted (it's
> basically a struct kref + size + payload). Since this would have to be allocated
> you can't use this in interrupt context.

Well, one can use GFP_NOWAIT. I would allow this. But surely better done
outside interrupt context.

> Since the payloads are larger I am less concerned about speed. There is one
> problem, though: if you dequeue the event and the buffer that should receive
> the payload is too small, then you have lost that payload. You can't allocate
> a new, larger, buffer and retry. So this approach can only work if you really
> know the maximum payload size.
> 
> The advantage is also that you won't lose payloads.
> 
> You are starting to convince me :-) Just don't change the current implementation
> for small payloads, that's one that really works very well.

I meant only large payload buffers above but failed to write it down.
Smaller ones could stay as they are.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
