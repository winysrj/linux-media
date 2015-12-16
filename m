Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60972 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752816AbbLPODg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 09:03:36 -0500
Date: Wed, 16 Dec 2015 16:03:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, javier@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v3 00/23] Unrestricted media entity ID range support
Message-ID: <20151216140301.GO17128@valkosipuli.retiisi.org.uk>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wed, Dec 16, 2015 at 03:32:15PM +0200, Sakari Ailus wrote:
> This is the third version of the unrestricted media entity ID range
> support set. I've taken Mauro's comments into account and fixed a number
> of bugs as well (omap3isp memory leak and omap4iss stream start).

Javier: Mauro told me you might have OMAP4 hardware. Would you be able to
test the OMAP4 ISS with these patches?

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
