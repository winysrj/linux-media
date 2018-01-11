Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47410 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932483AbeAKSla (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 13:41:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, shuah@kernel.org, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-core: v4l2-mc: Add SPDX license identifier
Date: Thu, 11 Jan 2018 20:42:04 +0200
Message-ID: <1730571.xFN9zJKHcq@avalon>
In-Reply-To: <9e7fdf1e-64f5-093a-e1ad-a64653791429@osg.samsung.com>
References: <20180110163540.8396-1-shuahkh@osg.samsung.com> <2473844.IFKS5XRpDA@avalon> <9e7fdf1e-64f5-093a-e1ad-a64653791429@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday, 11 January 2018 17:45:15 EET Shuah Khan wrote:
> On 01/11/2018 05:55 AM, Laurent Pinchart wrote:
> > On Wednesday, 10 January 2018 18:35:36 EET Shuah Khan wrote:
> >> Replace GPL license statement with SPDX GPL-2.0 license identifier.
> >> 
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/v4l2-mc.c | 11 +----------
> >>  1 file changed, 1 insertion(+), 10 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/v4l2-mc.c
> >> b/drivers/media/v4l2-core/v4l2-mc.c index 303980b71aae..1297132acd4e
> >> 100644
> >> --- a/drivers/media/v4l2-core/v4l2-mc.c
> >> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> >> @@ -1,3 +1,4 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> > 
> > The header doesn't match the existing license.
> 
> When I added the file, I must have cut and pasted the license statement
> from another file. More on this below the deleted license lines.
> 
> > Furthermore, unless I'm mistaken, the standard comment style for SPDX
> > headers in the kernel is //, not /* ... */
> 
> Looks like we have 3 conventions for SPDX comment style.
> /* ... */ for headers and # ... for shell scripts and
> // for .c files.
> 
> I can update it it and send v2 provided we think the change is inline
> with the original license.

Personally I prefer the /* ... */ comment style, but I noticed that Greg used 
// in his large patch the adds SPDX license headers, so I think we should 
follow the established practice. I'll let you investigate to find what is 
preferred :)

> >>  /*
> >>  
> >>   * Media Controller ancillary functions
> >>   *
> >> 
> >> @@ -5,16 +6,6 @@
> >> 
> >>   * Copyright (C) 2016 Shuah Khan <shuahkh@osg.samsung.com>
> >>   * Copyright (C) 2006-2010 Nokia Corporation
> >>   * Copyright (c) 2016 Intel Corporation.
> >> 
> >> - *
> >> - *  This program is free software; you can redistribute it and/or modify
> >> - *  it under the terms of the GNU General Public License as published by
> >> - *  the Free Software Foundation; either version 2 of the License, or
> >> - *  (at your option) any later version.
> 
> Are you concerned about the "or (at your option) any later version." part
> that it doesn't match?

Yes, that's my concern. I'm personally fine with GPL-2.0-only, but you'll have 
a hard time contacting all the other copyright holders if you want to 
relicense this. Good luck getting hold of the appropriate legal department at 
Nokia :-)

On a related note, I nowadays encourage developers to keep their copyright on 
code they wrote when possible, and to at least negotiate that with their 
employers.

> >> - *
> >> - *  This program is distributed in the hope that it will be useful,
> >> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> - *  GNU General Public License for more details.
> >>   */
> >>  
> >>  #include <linux/module.h>

-- 
Regards,

Laurent Pinchart
