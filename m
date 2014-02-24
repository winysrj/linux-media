Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58278 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaBXR4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 12:56:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
Date: Mon, 24 Feb 2014 18:57:21 +0100
Message-ID: <1429446.JuNhcjlU1Y@avalon>
In-Reply-To: <530B6D0C.1020900@xs4all.nl>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <530B668D.6010903@iki.fi> <530B6D0C.1020900@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 24 February 2014 17:02:20 Hans Verkuil wrote:
> On 02/24/2014 04:34 PM, Sakari Ailus wrote:
> > Hans Verkuil wrote:
> >> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> >>> The buffer flags field is 32 bits but the defined only used 16. This is
> >>> fine, but as more than 16 bits will be used in the very near future,
> >>> define them as 32-bit numbers for consistency.
> >>> 
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >>> ---
> >>> 
> >>>  Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++-------------
> >>>  include/uapi/linux/videodev2.h         |   38 +++++++++++++++----------
> >>   2 files changed, 38 insertions(+), 30 deletions(-)
> >>> 
> >>> diff --git a/Documentation/DocBook/media/v4l/io.xml
> >>> b/Documentation/DocBook/media/v4l/io.xml index 8facac4..46d24b3 100644
> >>> --- a/Documentation/DocBook/media/v4l/io.xml
> >>> +++ b/Documentation/DocBook/media/v4l/io.xml
> >> 
> >> <snip>
> >> 
> >>> @@ -1115,7 +1115,7 @@ in which case caches have not been used.</entry>
> >>>  	  </row>
> >>>  	  <row>
> >>>  	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
> >>> -	    <entry>0x4000</entry>
> >>> +	    <entry>0x00004000</entry>
> >>>  	    <entry>The CAPTURE buffer timestamp has been taken from the
> >>>  	    corresponding OUTPUT buffer. This flag applies only to mem2mem
> >>>  	    devices.</entry>
> >>>  	  </row>
> >> 
> >> Should we add here that if TIMESTAMP_COPY is set and the TIMECODE flag is
> >> set, then drivers should copy the TIMECODE struct as well? This is
> >> happening already in various drivers and I think that is appropriate.
> >> Although to be honest nobody is actually using the timecode struct, but
> >> we plan to hijack that for hardware timestamps in the future anyway.
> > 
> > Is there a single driver which uses the timecode field? The fact is that
> > many m2m drivers copy it but that's probably mostly copying what one of
> > them happened to do by accident. :-)
> 
> No, there are no drivers that use this at the moment (other than for
> copying). However, it is part of the API and I'd like to close these little
> holes and define clearly what should be done.

What would you think about deprecating the timecode field ? There's no 
mainline driver using it, I'd rather avoid introducing a dependency on the 
timecode in M2M applications.

> I think given the purpose of the timecode field it makes sense to copy it.
> Note that it is the application that might be providing that data, it
> doesn't have to come from a driver at all.
> 
> I've been doing a lot of testing over the weekend and this is one of those
> little things that are not clearly defined.

-- 
Regards,

Laurent Pinchart

