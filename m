Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52620 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753936AbbDOIcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 04:32:47 -0400
Date: Wed, 15 Apr 2015 11:32:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: [PATCH v5 01/10] leds: unify the location of led-trigger API
Message-ID: <20150415083239.GE27451@valkosipuli.retiisi.org.uk>
References: <1429080520-10687-1-git-send-email-j.anaszewski@samsung.com>
 <1429080520-10687-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429080520-10687-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2015 at 08:48:31AM +0200, Jacek Anaszewski wrote:
> Part of led-trigger API was in the private drivers/leds/leds.h header.
> Move it to the include/linux/leds.h header to unify the API location
> and announce it as public. It has been already exported from
> led-triggers.c with EXPORT_SYMBOL_GPL macro. The no-op definitions are
> changed from macros to inline to match the style of the surrounding code.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
