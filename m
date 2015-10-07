Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbJGKtm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 06:49:42 -0400
Date: Wed, 7 Oct 2015 12:49:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	sakari.ailus@linux.intel.com, andrew@lunn.ch,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/10] media: flash: use led_set_brightness_sync for
 torch brightness
Message-ID: <20151007104938.GA3725@xo-6d-61-c0.localdomain>
References: <1444209048-29415-1-git-send-email-j.anaszewski@samsung.com>
 <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 2015-10-07 11:10:48, Jacek Anaszewski wrote:
> LED subsystem shifted responsibility for choosing between SYNC or ASYNC
> way of setting brightness from drivers to the caller. Adapt the wrapper
> to those changes.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

7-10 of the series:

Acked-by: Pavel Machek <pavel@ucw.cz>
