Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:52006 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933572AbcJ0Hng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 03:43:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] [media] smiapp: make PM functions as __maybe_unused
Date: Thu, 27 Oct 2016 09:43:16 +0200
Message-ID: <3736433.WSCIHGPKQU@wuerfel>
In-Reply-To: <20161027072818.GQ9460@valkosipuli.retiisi.org.uk>
References: <20161026203814.1904690-1-arnd@arndb.de> <20161027072818.GQ9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 27, 2016 10:28:18 AM CEST Sakari Ailus wrote:
> 
> On Wed, Oct 26, 2016 at 10:38:01PM +0200, Arnd Bergmann wrote:
> > The rework of the PM support has caused two functions to
> > be orphaned when CONFIG_PM is disabled:
> > 
> > media/i2c/smiapp/smiapp-core.c:1352:12: error: 'smiapp_power_off' defined but not used [-Werror=unused-function]
> > media/i2c/smiapp/smiapp-core.c:1206:12: error: 'smiapp_power_on' defined but not used [-Werror=unused-function]
> > 
> > This changes all four PM entry points to __maybe_unused and
> > removes the #ifdef markers for consistency. This avoids the
> > warnings even when something changes again.
> > 
> > Fixes: cbba45d43631 ("[media] smiapp: Use runtime PM")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> The power-on sequence is in fact mandatory as it involves writing the
> initial configuration to the sensor as well.
> 
> Instead, I believe the correct fix is to make the driver depend on
> CONFIG_PM.

(adding linux-pm list)

That would be a rather unusual dependency, though it's possible that
a lot of drivers in fact need it but never listed this explictly in
Kconfig.

What do other drivers do that need to have their runtime_resume
function called at probe time when CONFIG_PM is disabled?

	Arnd
