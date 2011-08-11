Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab1HKLeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 07:34:16 -0400
Subject: Re: adp1653 usage
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20110811071900.GC5926@valkosipuli.localdomain>
References: <1312974960.2183.15.camel@smile>
	 <20110811071900.GC5926@valkosipuli.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Aug 2011 14:33:49 +0300
Message-ID: <1313062429.14702.2.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-08-11 at 10:19 +0300, Sakari Ailus wrote:

> > - if the subdevice creates device node /dev/v4l-subdevX, how the user
> > space will know the X is corresponding to let say flash device?
> 
> The whole media device's entities (of which the flash in this case is one
> of) can be enumerated. The device is called /dev/mediaX.
> 
> The Media controller API is defined here:
> 
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html#media_common>
Thanks for the link and explanations.

I just noticed the adp1653 driver has not defined the type of the media
entity. I have attached a patch just in case.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
