Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756888AbcBQJim (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 04:38:42 -0500
Date: Wed, 17 Feb 2016 11:38:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l2-async: Don't fail if registered_async
 isn't implemented
Message-ID: <20160217093808.GN32612@valkosipuli.retiisi.org.uk>
References: <1455653001-10043-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1455653001-10043-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 16, 2016 at 05:03:21PM -0300, Javier Martinez Canillas wrote:
> After sub-dev registration in v4l2_async_test_notify(), the v4l2-async
> core calls the registered_async callback but if a sub-dev driver does
> not implement it, v4l2_subdev_call() will return a -ENOIOCTLCMD which
> should not be considered an error.
> 
> Reported-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
