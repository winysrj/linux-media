Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab1IFKqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:46:39 -0400
Subject: Re: [media-ctl][PATCHv5 1/5] libmediactl: restruct error path
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 13:46:11 +0300
In-Reply-To: <201109061225.34125.laurent.pinchart@ideasonboard.com>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
	 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
	 <201109061225.34125.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1315305971.28628.11.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-09-06 at 12:25 +0200, Laurent Pinchart wrote: 
> I've slightly modified 1/5 and 3/5 (the first one returned -1 from 
> media_enum_entities(), which made media-ctl stop with a failure message) and 
> pushed the result to the repository.
Okay. I looked at them.
One minor comment: udef_unref is aware of NULL.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
