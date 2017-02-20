Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40728 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751082AbdBTVav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 16:30:51 -0500
Date: Mon, 20 Feb 2017 23:30:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] et8ek8: Export OF device ID as module aliases
Message-ID: <20170220213043.GW16975@valkosipuli.retiisi.org.uk>
References: <20170220201616.15028-1-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170220201616.15028-1-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2017 at 05:16:16PM -0300, Javier Martinez Canillas wrote:
> The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
> device was registered via OF, this means that exporting the OF device ID
> table device aliases in the module is not needed. But in order to change
> how the core reports modaliases to user-space, it's better to export it.
> 
> Before this patch:
> 
> $ modinfo drivers/media/i2c/et8ek8/et8ek8.ko | grep alias
> alias:          i2c:et8ek8
> 
> After this patch:
> 
> $ modinfo drivers/media/i2c/et8ek8/et8ek8.ko | grep alias
> alias:          i2c:et8ek8
> alias:          of:N*T*Ctoshiba,et8ek8C*
> alias:          of:N*T*Ctoshiba,et8ek8
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Thanks!

Applied to my tree (for-v4.12 branch).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
