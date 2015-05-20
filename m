Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60408 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751341AbbETI7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 04:59:54 -0400
Date: Wed, 20 May 2015 11:59:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sebastian Reichel <sre@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
Message-ID: <20150520085950.GA8365@valkosipuli.retiisi.org.uk>
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
 <20150519234143.GA20959@earth>
 <17465326.j5hDPLALfu@avalon>
 <3563083.vlSqH6VOBV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3563083.vlSqH6VOBV@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, May 20, 2015 at 10:14:53AM +0300, Laurent Pinchart wrote:
> On Wednesday 20 May 2015 09:57:33 Laurent Pinchart wrote:
> > On Wednesday 20 May 2015 01:41:43 Sebastian Reichel wrote:
> > > On Wed, May 20, 2015 at 02:08:05AM +0300, Sakari Ailus wrote:
> > > > The async notifier was registered before the v4l2_device was registered
> > > > and before the notifier callbacks were set. This could lead to missing
> > > > the bound() and complete() callbacks and to attempting to spin_lock()
> > > > and uninitialised spin lock.
> > > > 
> > > > Also fix unregistering the async notifier in the case of an error ---
> > > > the function may not fail anymore after the notifier is registered.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > 
> > > I already noticed this during my Camera for N900 work and solved it
> > > the same way, so:
> > > 
> > > Reviewed-By: Sebastian Reichel <sre@kernel.org>
> > > 
> > > You may want to add a Fixes Tag against the patch implementing the
> > > async notifier support in omap3isp, since its quite easy to run into
> > > the callback problems (at least I did) and the missing resource
> > > freeing (due to EPROBE_AGAIN).
> > 
> > Applied to my tree with the Reviewed-by and Fixes tags.
> 
> I spoke too soon. I think you forgot to remove the 
> v4l2_async_notifier_unregister() call from isp_register_entities(). I can fix 
> while applying if you agree with the change.

Please do. Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
