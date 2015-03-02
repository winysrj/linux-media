Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39025 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753759AbbCBWxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 17:53:43 -0500
Date: Tue, 3 Mar 2015 00:53:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 01/10] media: omap3isp: remove unused clkdev
Message-ID: <20150302225336.GV6539@valkosipuli.retiisi.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <E1YSTnC-0001JU-CX@rmk-PC.arm.linux.org.uk>
 <118780170.u6ZO5zJrEk@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118780170.u6ZO5zJrEk@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Russell,

On Tue, Mar 03, 2015 at 12:33:44AM +0200, Laurent Pinchart wrote:
> Hi Russell,
> 
> On Monday 02 March 2015 17:06:06 Russell King wrote:
> > No merged platform supplies xclks via platform data.  As we want to
> > slightly change the clkdev interface, rather than fixing this unused
> > code, remove it instead.
> >
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> There are quite a few out of tree users that I know of that might be impacted. 
> On the other hand, out of tree isn't an excuse, and OMAP3 platforms should 
> move to DT. The good news is that DT support for the omap3isp driver is about 
> to get submitted, and hopefully merged in v4.1. I thus have no objection to 
> this patch.
> 
> Sakari, does it conflict with the omap3isp DT support ? If so, how would you 
> prefer to resolve the conflict ? Russell, would it be fine to merge this 
> through Mauro's tree ?

I first thought it wouldn't conflict, but apparently it does. The
conflicting patches are here:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=commitdiff;h=a56c38208ee9200e57421b60b770fb8249935b95>
<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=commitdiff;h=72374c7a69a12afc76f220ef4de983be4583f164>
<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=commitdiff;h=0f0b86d64a555e308079f985812b011866e2c8f0>

Tne entire set:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=shortlog;h=refs/heads/rm696-051-upstream>

I haven't sent that to linux-media yet but I'll do that during the coming
couple of days.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
