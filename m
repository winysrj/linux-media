Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1GZJMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 05:12:30 -0400
Subject: Re: v4l2 api for flash drivers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20110630112617.GJ12671@valkosipuli.localdomain>
References: <1309431310.28887.12.camel@smile>
	 <201106301306.09023.laurent.pinchart@ideasonboard.com>
	 <20110630112617.GJ12671@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 12:12:02 +0300
Message-ID: <1311671522.3903.26.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-06-30 at 14:26 +0300, Sakari Ailus wrote: 
> > > [1] http://www.spinics.net/lists/linux-media/msg32527.html
> Yeah, that's my expectation as well unless there are further issues found
> with them.
I had not been subscribed to ML when you discussed the topic. So, might
be I missed something. However, the question is why have you chosen
hardware units for *_INTENSITY instead of, let say, hundredth of
percents (like 0 .. 10000)?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
