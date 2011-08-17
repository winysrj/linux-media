Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1HQKyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 06:54:14 -0400
Subject: Re: [PATCH] Media controller: Define media_entity_init() and
 media_entity_cleanup() conditionally
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	Vaibhav Hiremath <hvaibhav@ti.com>
In-Reply-To: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>
References: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Aug 2011 13:53:46 +0300
Message-ID: <1313578426.25065.1.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-08-17 at 16:04 +0530, Deepthy Ravi wrote: 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Defines the two functions only when CONFIG_MEDIA_CONTROLLER
> is enabled.
Is it not a driver's option to be dependent on MEDIA_CONTROLLER?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
