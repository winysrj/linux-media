Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1ILKTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 06:19:46 -0400
Subject: Re: [RFC][PATCH] as3645a: introduce new LED Flash driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Ivan T . Ivanov" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org, Tuukka Toivonen <tuukkat76@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 12 Sep 2011 13:19:15 +0300
In-Reply-To: <201109091708.02328.laurent.pinchart@ideasonboard.com>
References: <020b9977ca7e8f0eabfe1b52b7f37a2105611605.1315580169.git.andriy.shevchenko@linux.intel.com>
	 <201109091708.02328.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1315822755.28628.49.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-09-09 at 17:08 +0200, Laurent Pinchart wrote: 
> Hi Andy,
> 
> On Friday 09 September 2011 16:59:31 Andy Shevchenko wrote:
> > The driver supports the AS3645A, LM3555 chips and their clones.
> > 
> > Accordingly to datasheet the AS3645 chip is a "1000/720mA Ultra Small High
> > efficient single/dual LED Flash Driver with Safety Features". LM3555 is
> > similar one, that has following difference - the current in the torch mode
> > is the same (60mA) for the levels 0, 1, and 2.
> > 
> > This driver is a huge rework of the previously published driver which could
> > be found in the MeeGo kernel package.
> 
> Thank you for the patch.
> 
> I was about to send a new AS3645A driver version that supports more chip 
> features. I will CC you.
It's nice to hear this, however, I have some comments and questions I
will ask.

And just out of curiosity, how many drivers do you have already done,
but not published yet? I would like (and I hope you too) to avoid such
double effort in the future.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
