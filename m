Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1IEOtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 10:49:03 -0400
Subject: Re: [media-ctl][PATCHv4 3/3] libmediactl: get the device name via
 udev
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 05 Sep 2011 17:48:34 +0300
In-Reply-To: <201109051231.24430.laurent.pinchart@ideasonboard.com>
References: <201109021326.14340.laurent.pinchart@ideasonboard.com>
	 <6075971b959c2e808cd4ceec6540dc09b101346f.1314968925.git.andriy.shevchenko@linux.intel.com>
	 <62c72745987f6490497a54512d1569490c173af3.1314968925.git.andriy.shevchenko@linux.intel.com>
	 <201109051231.24430.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1315234114.28628.7.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-09-05 at 12:31 +0200, Laurent Pinchart wrote: 
> Hi Andy,
> 
> On Friday 02 September 2011 15:09:28 Andy Shevchenko wrote:
> > If configured with --with-libudev, the libmediactl is built with libudev
> > support. It allows to get the device name in right way in the modern linux
> > systems.
> 
> Thanks for the patch. We're nearly there :-)
I see.

> This will break binary compatibility if an application creates a struct 
> media_device instances itself. On the other hand applications are not supposed 
> to do that.
> 
> As the struct udev pointer is only used internally, what about passing it 
> around between functions explicitly instead ?
That we will break the API in media_close().
Might be I am a blind, but I can't see the way how to do both 1) don't
provide static global variable and 2) don't break the API/ABI.

So, I'll send 5th version of the patchset with API breakage.
Hope that what you could accept as a final version.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
