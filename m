Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HPHVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 03:21:17 -0400
Subject: Re: [media-ctl][PATCH] libmediactl: engage udev to get devname
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201108151652.54417.laurent.pinchart@ideasonboard.com>
References: <4a6d0bf1e50189da0c02e2326c3413d9088926c1.1313410776.git.andriy.shevchenko@linux.intel.com>
	 <201108151652.54417.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Aug 2011 10:20:50 +0300
Message-ID: <1313479250.4898.16.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-08-15 at 16:52 +0200, Laurent Pinchart wrote: 
> Hi Andy,
> 
> Thank you for the patch.
> 
> What about making it a configuration option to still support systems that 
> don't provide libudev ? We could keep the current behaviour for those.
Good point.
Will do.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
