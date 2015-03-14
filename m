Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38728 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752527AbbCNOrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 10:47:51 -0400
Date: Sat, 14 Mar 2015 16:47:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: omap3isp: video: Don't call vb2 mmap with queue
 lock held
Message-ID: <20150314144748.GY11954@valkosipuli.retiisi.org.uk>
References: <1426206815-15503-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426206815-15503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2015 at 02:33:35AM +0200, Laurent Pinchart wrote:
> videobuf2 has long been subject to AB-BA style deadlocks due to the
> queue lock and mmap_sem being taken in different orders for the mmap
> operation. The problem has been fixed by making this operation callable
> without taking the queue lock, using an mmap_lock internal to videobuf2.
> 
> The omap3isp driver still calls the mmap operation with the queue lock
> held, resulting in a potential deadlock. As the operation can now be
> called without locking the queue, fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
