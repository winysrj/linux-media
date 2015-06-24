Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43452 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203AbbFXLWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 07:22:53 -0400
Date: Wed, 24 Jun 2015 14:22:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH] leds: aat1290: Add 'static' modifier to
 init_mm_current_scale
Message-ID: <20150624112217.GC5904@valkosipuli.retiisi.org.uk>
References: <1434699164-5750-1-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434699164-5750-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2015 at 09:32:44AM +0200, Jacek Anaszewski wrote:
> Fix sparse warning by adding static modifier to the function
> init_mm_current_scale.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
