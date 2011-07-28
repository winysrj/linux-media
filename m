Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab1G1H4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 03:56:09 -0400
Subject: Re: [PATCH] adp1653: check error code of adp1653_init_controls
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20110727081522.GH32629@valkosipuli.localdomain>
References: <1b238cd98e03909bc4955113ffbe7e0c9f0db4f8.1311753459.git.andriy.shevchenko@linux.intel.com>
	 <20110727081522.GH32629@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 28 Jul 2011 10:55:30 +0300
Message-ID: <1311839730.3903.37.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-07-27 at 11:15 +0300, Sakari Ailus wrote: 
> On Wed, Jul 27, 2011 at 10:58:02AM +0300, Andy Shevchenko wrote:
> > Potentially the adp1653_init_controls could return an error. In our case the
> > error was ignored, meanwhile it means incorrect initialization of V4L2
> > controls.
> 
> Hi, Andy!
> 
> Many thanks for the another patch! I'll add this to my next pull req as
> well.
Please, skip this version, I will send updated one.

> Just FYI: As this is clearly a regular patch for the V4L2 subsystem, I think
> cc'ing the linux-kernel list isn't necessary.
Sure. 


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
