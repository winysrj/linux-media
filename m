Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42836 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcILRwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 13:52:10 -0400
Date: Mon, 12 Sep 2016 19:52:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] ad5820: use __maybe_unused for PM functions
Message-ID: <20160912175207.GB8285@amd>
References: <20160912153322.3098750-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160912153322.3098750-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2016-09-12 17:32:57, Arnd Bergmann wrote:
> The new ad5820 driver uses #ifdef to hide the suspend/resume functions,
> but gets it wrong when CONFIG_PM_SLEEP is disabled:
> 
> drivers/media/i2c/ad5820.c:286:12: error: 'ad5820_resume' defined but not used [-Werror=unused-function]
> drivers/media/i2c/ad5820.c:274:12: error: 'ad5820_suspend' defined but not used [-Werror=unused-function]
> 
> This replaces the #ifdef with a __maybe_unused annotation that is
> simpler and harder to get wrong, avoiding the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: bee3d5115611 ("[media] ad5820: Add driver for auto-focus
coil")

Thanks!

Acked-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
