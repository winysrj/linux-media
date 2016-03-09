Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54620 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753143AbcCIJou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 04:44:50 -0500
Date: Wed, 9 Mar 2016 11:44:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c/adp1653: fix check of devm_gpiod_get() error
 code
Message-ID: <20160309094415.GJ11084@valkosipuli.retiisi.org.uk>
References: <1457375972-9923-1-git-send-email-vz@mleia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457375972-9923-1-git-send-email-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On Mon, Mar 07, 2016 at 08:39:32PM +0200, Vladimir Zapolskiy wrote:
> The devm_gpiod_get() function returns either a valid pointer to
> struct gpio_desc or ERR_PTR() error value, check for NULL is bogus.
> 
> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>

Thanks! Applied to my fixes branch.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
