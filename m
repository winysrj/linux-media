Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37936 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755285Ab2DXPOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 11:14:25 -0400
Date: Tue, 24 Apr 2012 18:14:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] omap3isp: ccdc: Add crop support on output
 formatter source pad
Message-ID: <20120424151420.GC7913@valkosipuli.localdomain>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1335180595-27931-4-git-send-email-laurent.pinchart@ideasonboard.com>
 <4F95D64A.10505@iki.fi>
 <14838654.TrzCLImese@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14838654.TrzCLImese@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 24, 2012 at 11:08:12AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 24 April 2012 01:23:06 Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > The patch looks good as such on the first glance, but I have another
> > question: why are you not using the selections API instead? It's in
> > Mauro's tree already.
> 
> You're totally right, we need to convert the selection API. The reason why 
> I've implemented crop support at the CCDC output was simply that I needed it 
> for a project and didn't have time to implement the selection API. As the code 
> works, I considered it would be good to have it upstream until we switch to 
> the selection API.

"Until we switch to the selection API"? The subdev selection API is in
Mauro's tree already so I see no reason not to use it. Implementing new
functionality in a driver using API we've just marked obsolete is... not
pretty.

The compatibility code for the old crop ioctls exist, too, so you get
exactly the same functionality as well.

> > Also, the old S_CROP IOCTL only has been defined for sink pads, not source.
> 
> We're already using crop on source pads on sensors ;-)

Is that supposed to work? At the very least least it does not follow the
spec.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
