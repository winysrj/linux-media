Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47170 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757247Ab2IXS0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 14:26:51 -0400
Date: Mon, 24 Sep 2012 21:26:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
Message-ID: <20120924182645.GI12025@valkosipuli.retiisi.org.uk>
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
 <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
 <50608F9D.40304@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50608F9D.40304@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Sep 24, 2012 at 06:51:41PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 09/24/2012 03:44 PM, Sakari Ailus wrote:
> > How about useing a separate video buffer queue for the purpose? That would
> > provide a nice way to pass it to the user space where it's needed. It'd also
> > play nicely together with the frame layout descriptors.
> 
> It's tempting, but doing frame synchronisation in user space in this case
> would have been painful, if at all possible in reliable manner. It would 
> have significantly complicate applications and the drivers.

Let's face it: applications that are interested in this information have to
do exactly the same frame number matching with the statistics buffers. Just
stitching the data to the same video buffer isn't a generic solution.

> VIDIOC_STREAMON, VIDIOC_QBUF/DQBUF calls would have been at least roughly
> synchronized, and applications would have to know somehow which video nodes
> needs to be opened together. I guess things like that could be abstracted
> in a library, but what do we really gain for such effort ?
> And now I can just ask kernel for 2-planar buffers where everything is in
> place..

That's equally good --- some hardware can only do that after all, but do you
need the callback in that case, if there's a single destination buffer
anyway? Wouldn't the frame layout descriptor have enough information to do
this?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
