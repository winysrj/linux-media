Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750927AbcIMIb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 04:31:59 -0400
Date: Tue, 13 Sep 2016 11:31:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] ad5820: use __maybe_unused for PM functions
Message-ID: <20160913083146.GE5086@valkosipuli.retiisi.org.uk>
References: <20160912153322.3098750-1-arnd@arndb.de>
 <20160912175207.GB8285@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160912175207.GB8285@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 12, 2016 at 07:52:08PM +0200, Pavel Machek wrote:
> On Mon 2016-09-12 17:32:57, Arnd Bergmann wrote:
> > The new ad5820 driver uses #ifdef to hide the suspend/resume functions,
> > but gets it wrong when CONFIG_PM_SLEEP is disabled:
> > 
> > drivers/media/i2c/ad5820.c:286:12: error: 'ad5820_resume' defined but not used [-Werror=unused-function]
> > drivers/media/i2c/ad5820.c:274:12: error: 'ad5820_suspend' defined but not used [-Werror=unused-function]
> > 
> > This replaces the #ifdef with a __maybe_unused annotation that is
> > simpler and harder to get wrong, avoiding the warning.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: bee3d5115611 ("[media] ad5820: Add driver for auto-focus
> coil")
> 
> Thanks!
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks, Arnd and Pavel!

Added to my ad5820 branch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
