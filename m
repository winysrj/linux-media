Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55190 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751738AbdFHMtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 08:49:18 -0400
Date: Thu, 8 Jun 2017 15:49:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[media] et8ek8: Export OF device ID as module
 aliases"
Message-ID: <20170608124910.GG1019@valkosipuli.retiisi.org.uk>
References: <20170608090156.2373326-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608090156.2373326-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 08, 2017 at 11:01:37AM +0200, Arnd Bergmann wrote:
> This one got applied twice, causing a build error with clang:
> 
> drivers/media/i2c/et8ek8/et8ek8_driver.c:1499:1: error: redefinition of '__mod_of__et8ek8_of_table_device_table'
> 
> Fixes: 9ae05fd1e791 ("[media] et8ek8: Export OF device ID as module aliases")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
