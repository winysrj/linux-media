Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36838 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750756AbdFNLBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 07:01:24 -0400
Date: Wed, 14 Jun 2017 14:01:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v1] [media] as3645a: Join string literals back
Message-ID: <20170614110119.GO12407@valkosipuli.retiisi.org.uk>
References: <20170604182918.31476-1-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170604182918.31476-1-andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 04, 2017 at 09:29:18PM +0300, Andy Shevchenko wrote:
> There is no need to split long string literals.
> Join them back.
> 
> No functional change intended.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Thanks, applied!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
