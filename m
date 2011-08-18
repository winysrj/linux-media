Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:60266 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1HROIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 10:08:15 -0400
Date: Thu, 18 Aug 2011 17:08:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
Message-ID: <20110818140811.GF8872@valkosipuli.localdomain>
References: <20110818092158.GA8872@valkosipuli.localdomain>
 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
 <1313667122.25065.8.camel@smile>
 <20110818115131.GD8872@valkosipuli.localdomain>
 <1313674341.25065.17.camel@smile>
 <20110818135556.GE8872@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818135556.GE8872@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 18, 2011 at 04:55:56PM +0300, Sakari Ailus wrote:
[clip]
> I'm beginning to think we should require power() callback and fail in
> probe() if it doesn't exist, or directly make it a gpio.
> 
> My plan is to get the N900 board code with the rest of the subdev drivers to
> mainline at some point but that will likely take quite a bit of calendar
> time, unfortunately. The adp1653 driver and the flash interface was just a
> first part of it.

FYI: the code is available here:

	git://gitorious.org/omap3camera/mainline.git rx51-005/002-devel

-- 
Sakari Ailus
sakari.ailus@iki.fi
