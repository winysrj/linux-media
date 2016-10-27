Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39436 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752696AbcJ0H22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 03:28:28 -0400
Date: Thu, 27 Oct 2016 10:28:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] smiapp: make PM functions as __maybe_unused
Message-ID: <20161027072818.GQ9460@valkosipuli.retiisi.org.uk>
References: <20161026203814.1904690-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026203814.1904690-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, Oct 26, 2016 at 10:38:01PM +0200, Arnd Bergmann wrote:
> The rework of the PM support has caused two functions to
> be orphaned when CONFIG_PM is disabled:
> 
> media/i2c/smiapp/smiapp-core.c:1352:12: error: 'smiapp_power_off' defined but not used [-Werror=unused-function]
> media/i2c/smiapp/smiapp-core.c:1206:12: error: 'smiapp_power_on' defined but not used [-Werror=unused-function]
> 
> This changes all four PM entry points to __maybe_unused and
> removes the #ifdef markers for consistency. This avoids the
> warnings even when something changes again.
> 
> Fixes: cbba45d43631 ("[media] smiapp: Use runtime PM")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The power-on sequence is in fact mandatory as it involves writing the
initial configuration to the sensor as well.

Instead, I believe the correct fix is to make the driver depend on
CONFIG_PM.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
