Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40072 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbcEAJD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2016 05:03:58 -0400
Date: Sun, 1 May 2016 11:03:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?=
	<ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160501090355.GB14243@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <1461777170.18568.2.camel@Nokia-N900>
 <20160429000551.GA29312@earth>
 <20160429174559.GA6431@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160429174559.GA6431@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2016-04-29 19:45:59, Sebastian Reichel wrote:

> Ok, I found the problem. CONFIG_VIDEO_OMAP3=y does not work,
> due to missing -EPROBE_DEFER handling for vdds_csib. I added
> it and just got a test image with builtin CONFIG_VIDEO_OMAP3.
> The below patch fixes the problem.
> 
> commit 9d8333b29207de3a9b6ac99db2dfd91e2f8c0216
> Author: Sebastian Reichel <sre@kernel.org>
> Date:   Fri Apr 29 19:23:02 2016 +0200
> 
>     omap3isp: handle -EPROBE_DEFER for vdds_csib
>     
>     omap3isp may be initialized before the regulator's driver has been
>     loaded resulting in vdds_csib=NULL. Fix this by handling -EPROBE_DEFER
>     for vdds_csib.
>     
>     Signed-Off-By: Sebastian Reichel <sre@kernel.org>

Tested-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Pavel Machek <pavel@ucw.cz>

...and... thanks :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
