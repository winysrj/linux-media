Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52806 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbcD2NWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 09:22:50 -0400
Date: Fri, 29 Apr 2016 15:22:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 07/24] v4l: of: Call CSI2 bus csi2, not csi
Message-ID: <20160429132246.GA21251@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-8-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-8-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2016-04-25 00:08:07, Ivaylo Dimitrov wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The function to parse CSI2 bus parameters was called
> v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
> anticipation of CSI1/CCP2 support.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
