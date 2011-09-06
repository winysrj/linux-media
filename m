Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1IFIOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 04:14:35 -0400
Subject: Re: [media-ctl][PATCHv4 3/3] libmediactl: get the device name via
 udev
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Tue, 06 Sep 2011 11:14:06 +0300
In-Reply-To: <201109051657.21646.laurent.pinchart@ideasonboard.com>
References: <201109021326.14340.laurent.pinchart@ideasonboard.com>
	 <201109051231.24430.laurent.pinchart@ideasonboard.com>
	 <1315234114.28628.7.camel@smile>
	 <201109051657.21646.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1315296846.28628.8.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-09-05 at 16:57 +0200, Laurent Pinchart wrote: 
> > > This will break binary compatibility if an application creates a struct
> > > media_device instances itself. On the other hand applications are not
> > > supposed to do that.
> > > 
> > > As the struct udev pointer is only used internally, what about passing it
> > > around between functions explicitly instead ?
> > 
> > That we will break the API in media_close().
> > Might be I am a blind, but I can't see the way how to do both 1) don't
> > provide static global variable and 2) don't break the API/ABI.
> 
> What about passing the udev pointer explictly to media_enum_entities() (which 
> is static), and calling media_udev_close() in media_open() after the 
> media_enum_entities() call ?
I sent the patch series that incorporates your last comments.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
