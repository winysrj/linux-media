Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33006 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1IEO5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 10:57:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv4 3/3] libmediactl: get the device name via udev
Date: Mon, 5 Sep 2011 16:57:21 +0200
Cc: linux-media@vger.kernel.org
References: <201109021326.14340.laurent.pinchart@ideasonboard.com> <201109051231.24430.laurent.pinchart@ideasonboard.com> <1315234114.28628.7.camel@smile>
In-Reply-To: <1315234114.28628.7.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051657.21646.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Monday 05 September 2011 16:48:34 Andy Shevchenko wrote:
> On Mon, 2011-09-05 at 12:31 +0200, Laurent Pinchart wrote:
> > Hi Andy,
> > 
> > On Friday 02 September 2011 15:09:28 Andy Shevchenko wrote:
> > > If configured with --with-libudev, the libmediactl is built with
> > > libudev support. It allows to get the device name in right way in the
> > > modern linux systems.
> > 
> > Thanks for the patch. We're nearly there :-)
> 
> I see.
> 
> > This will break binary compatibility if an application creates a struct
> > media_device instances itself. On the other hand applications are not
> > supposed to do that.
> > 
> > As the struct udev pointer is only used internally, what about passing it
> > around between functions explicitly instead ?
> 
> That we will break the API in media_close().
> Might be I am a blind, but I can't see the way how to do both 1) don't
> provide static global variable and 2) don't break the API/ABI.

What about passing the udev pointer explictly to media_enum_entities() (which 
is static), and calling media_udev_close() in media_open() after the 
media_enum_entities() call ?

> So, I'll send 5th version of the patchset with API breakage.
> Hope that what you could accept as a final version.

Sorry for making it so difficult :-/

-- 
Regards,

Laurent Pinchart
