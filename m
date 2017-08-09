Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55619 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdHIQCt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 12:02:49 -0400
Date: Wed, 9 Aug 2017 18:02:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 1/1] omap3isp: Skip CSI-2 receiver initialisation in
 CCP2 configuration
Message-ID: <20170809160246.GB8711@atrey.karlin.mff.cuni.cz>
References: <20170718194303.20436-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718194303.20436-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If the CSI-2 receiver isn't part of the pipeline (or isn't there to begin
> with), skip its initialisation.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Looks good to me.

Acked-by: Pavel Machek <pavel@ucw.cz>

I should be able to test it later, but as Laurent already tested it, I
believe it is good to go.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
