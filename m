Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43469 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752161AbbFXLXT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 07:23:19 -0400
Date: Wed, 24 Jun 2015 14:22:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v10.1] leds: aat1290: add support for V4L2 Flash
 sub-device
Message-ID: <20150624112247.GD5904@valkosipuli.retiisi.org.uk>
References: <1434699203-5822-1-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434699203-5822-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2015 at 09:33:22AM +0200, Jacek Anaszewski wrote:
> Add support for V4L2 Flash sub-device to the aat1290 LED Flash class
> driver. The support allows for V4L2 Flash sub-device to take the control
> of the LED Flash class device.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
