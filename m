Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58730 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1GZJrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 05:47:14 -0400
Date: Tue, 26 Jul 2011 12:47:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: v4l2 api for flash drivers
Message-ID: <20110726094709.GA32507@valkosipuli.localdomain>
References: <1309431310.28887.12.camel@smile>
 <201106301306.09023.laurent.pinchart@ideasonboard.com>
 <20110630112617.GJ12671@valkosipuli.localdomain>
 <1311671522.3903.26.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311671522.3903.26.camel@smile>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Tue, Jul 26, 2011 at 12:12:02PM +0300, Andy Shevchenko wrote:
> On Thu, 2011-06-30 at 14:26 +0300, Sakari Ailus wrote: 
> > > > [1] http://www.spinics.net/lists/linux-media/msg32527.html
> > Yeah, that's my expectation as well unless there are further issues found
> > with them.
> I had not been subscribed to ML when you discussed the topic. So, might
> be I missed something. However, the question is why have you chosen
> hardware units for *_INTENSITY instead of, let say, hundredth of
> percents (like 0 .. 10000)?

Current is not that hardware specific.

There is some value in knowing the actual current. For example, if you have
two different flash controllers with the same LED, you can achieve the same
luminous output by choosing the same current on both controllers, without
knowing which one you're actually using.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
