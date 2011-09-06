Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16935 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1IFKuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:50:54 -0400
Subject: Re: [media-ctl][PATCHv5 1/5] libmediactl: restruct error path
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 13:50:25 +0300
In-Reply-To: <1315305971.28628.11.camel@smile>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
	 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
	 <201109061225.34125.laurent.pinchart@ideasonboard.com>
	 <1315305971.28628.11.camel@smile>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1315306225.28628.13.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-06 at 13:46 +0300, Andy Shevchenko wrote: 
> On Tue, 2011-09-06 at 12:25 +0200, Laurent Pinchart wrote: 
> > I've slightly modified 1/5 and 3/5 (the first one returned -1 from 
> > media_enum_entities(), which made media-ctl stop with a failure message) and 
> > pushed the result to the repository.
> Okay. I looked at them.
> One minor comment: udef_unref is aware of NULL.
Ah, and another. I don't get why you split snprintf() to that suboptimal
strncpy + x[sizeof(x)-1] = 0?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
