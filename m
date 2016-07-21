Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54728 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751568AbcGUKGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 06:06:02 -0400
Date: Thu, 21 Jul 2016 13:05:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] vb2: check for NULL device pointer
Message-ID: <20160721100527.GI7976@valkosipuli.retiisi.org.uk>
References: <8a2effdb-355f-de34-b4c7-7c9eaa3c7873@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a2effdb-355f-de34-b4c7-7c9eaa3c7873@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jul 21, 2016 at 11:19:11AM +0200, Hans Verkuil wrote:
> Check whether the struct device pointer is NULL and return -EINVAL in that
> case.
> 
> This also required a small change to vb2-core where it didn't call PTR_ERR to
> get the real error code.
> 
> I have seen several new driver submissions that forgot to set the vb2_queue
> dev field, so add these checks to prevent this from happening again.
> 
> The dev field is passed on to the dma-contig/sg drivers in the alloc, get_userptr
> and attach_dmabuf callbacks, so this check has to be done in those three places.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Considering this is here just to notify driver developers they're doing
something wrong, I'd just have a WARN_ON() so they can see what's wrong and
fix their code. The debug print contains no additional information.
Readability should be the preference instead --- and extra debug prints
don't really help with that.

It'd be nice if the functions always returned either NULL or an error code.
That's not really an issue with this patch, but it extends the use of both
of the options in favour of either one.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
