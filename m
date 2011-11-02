Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44367 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1KBKEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:04:05 -0400
Date: Wed, 2 Nov 2011 12:04:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	robert.swain@collabora.co.uk
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102100401.GB22159@valkosipuli.localdomain>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111011324.36742.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 01, 2011 at 01:24:35PM +0100, Laurent Pinchart wrote:
> Hi everybody,
> 
> The V4L2 specification documents the v4l2_buffer timestamp field as
> 
> "For input streams this is the system time (as returned by the gettimeofday() 
> function) when the first data byte was captured."
> 
> The system time is a pretty bad clock source to timestamp buffers, as it can 
> jump back and forth in time. Using a monotonic clock, as returned by 
> clock_gettime(CLOCK_MONOTONIC) (or ktime_get_ts() in the kernel), would be 
> much more useful.
> 
> Several drivers already use a monotonic clock instead of the system clock, 
> which currently violates the V4L2 specification. As those drivers do the right 
> thing from a technical point of view, I'd really hate "fixing" them by making 
> them use gettimeofday().
> 
> We should instead fix the V4L2 specification to mandate the use of a monotonic 
> clock (which could then also support hardware timestamps when they are 
> available). Would such a change be acceptable ?

I'm in favour of that. I don't think wall clock timestamps are really useful
to begin with. If you really need them, you can always do gettimeofday() in
the user space.

For any kind of a/v synchronisation where precise timestamps matter the
monotonic clock is the way to go.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
