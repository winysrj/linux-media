Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34306 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaIDHDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 03:03:49 -0400
Date: Thu, 4 Sep 2014 10:03:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 16/46] [media] smiapp-core: use true/false for boolean
 vars
Message-ID: <20140904070340.GJ30024@valkosipuli.retiisi.org.uk>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <64a4483b3c2e3864dfdc0029497c9e4188a88887.1409775488.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64a4483b3c2e3864dfdc0029497c9e4188a88887.1409775488.git.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 03, 2014 at 05:32:48PM -0300, Mauro Carvalho Chehab wrote:
> Instead of using 0 or 1 for boolean, use the true/false
> defines.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Would you like me to pick this patch to my tree, or would you like to apply
it directly? I'm fine with either.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
