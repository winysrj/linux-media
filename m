Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:35600 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2BZS5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 13:57:03 -0500
Message-ID: <4F4A806C.90804@iki.fi>
Date: Sun, 26 Feb 2012 20:56:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 08/33] v4l: Add subdev selections documentation: svg
 and dia files
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-8-git-send-email-sakari.ailus@iki.fi> <1392029.PES5QU0EJ7@avalon>
In-Reply-To: <1392029.PES5QU0EJ7@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Monday 20 February 2012 03:56:47 Sakari Ailus wrote:
>> Add svga and dia files for V4L2 subdev selections documentation.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The diagram look fine, although a bit complex. They could be simplified by 
> merging the identical rectangles (for instance moving the sink crop selection 
> label to the dotted blue rectangle, and removing the plain blue rectangle). 
> I'm not sure if that would be really more readable though, it's up to you.

I did that change, and I indeed think it improves readability. Now the
documentation has equal number of rectangles that there really are.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
