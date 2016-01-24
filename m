Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33636 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbcAYGVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 01:21:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH v2 2/3] libv4l2subdev: Add a function to list library supported pixel codes
Date: Sun, 24 Jan 2016 22:27:29 +0200
Message-ID: <2165577.6ioLVgiXqI@avalon>
In-Reply-To: <56A2306F.4070808@linux.intel.com>
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com> <1686411.P10t21bMUM@avalon> <56A2306F.4070808@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 22 January 2016 15:36:47 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 08 December 2015 17:15:15 Sakari Ailus wrote:
> >> Also mark which format definitions are compat definitions for the
> >> pre-existing codes. This way we don't end up listing the same formats
> >> twice.
> > 
> > Wouldn't it be easier to add a function to return the whole array (and
> > terminate it with an empty entry to avoid having to return both the array
> > and the length=) ?
> 
> Now that I'm actually thinking about making that change, I have a few
> concerns:
> 
> - This is not in line with the other APIs in the library, they mirror
> the IOCTL behaviour (it's another debate whether this is a good idea or
> not).

A function to list the library's supported pixel codes wouldn't be either, so 
I don't really see that as a big issue. A bigger issue, that needs to be fixed 
to release a version of the library as a shared object, is that the API hasn't 
really been thought of properly.

> - I need a new statically allocated array for that. I think I'll change
> my sed script. Allocating an array when the function is called the first
> time isn't a great idea either, there's a problem with re-entrancy and
> it's a memory leak, too.

In a shared object we could make use the _init and _fini functions. Is there 
something similar available for static libraries ? A different sed script 
should be fine too.

> So don't complain about these when I send an updated version. ;-)

-- 
Regards,

Laurent Pinchart

