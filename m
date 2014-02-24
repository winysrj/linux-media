Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22406 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaBXQNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 11:13:54 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1I00HDSD33A7C0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Feb 2014 16:13:51 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-3-git-send-email-sakari.ailus@iki.fi>
 <5309E05E.4030108@xs4all.nl> <530B668D.6010903@iki.fi>
In-reply-to: <530B668D.6010903@iki.fi>
Subject: RE: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
Date: Mon, 24 Feb 2014 17:13:49 +0100
Message-id: <125b01cf317b$67b61b80$37225280$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Monday, February 24, 2014 4:35 PM
> 
> Hans Verkuil wrote:
> > On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> >> The buffer flags field is 32 bits but the defined only used 16. This
> >> is fine, but as more than 16 bits will be used in the very near
> >> future, define them as 32-bit numbers for consistency.
> >>
> >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >> ---
> >>  Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++---------
> ----
> >>  include/uapi/linux/videodev2.h         |   38 +++++++++++++++++++--
> -----------
> >>  2 files changed, 38 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/io.xml
> >> b/Documentation/DocBook/media/v4l/io.xml
> >> index 8facac4..46d24b3 100644
> >> --- a/Documentation/DocBook/media/v4l/io.xml
> >> +++ b/Documentation/DocBook/media/v4l/io.xml
> >
> > <snip>
> >
> >> @@ -1115,7 +1115,7 @@ in which case caches have not been
> used.</entry>
> >>  	  </row>
> >>  	  <row>
> >>
> <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
> >> -	    <entry>0x4000</entry>
> >> +	    <entry>0x00004000</entry>
> >>  	    <entry>The CAPTURE buffer timestamp has been taken from the
> >>  	    corresponding OUTPUT buffer. This flag applies only to
> mem2mem devices.</entry>
> >>  	  </row>
> >
> > Should we add here that if TIMESTAMP_COPY is set and the TIMECODE
> flag
> > is set, then drivers should copy the TIMECODE struct as well? This is
> > happening already in various drivers and I think that is appropriate.
> > Although to be honest nobody is actually using the timecode struct,
> > but we plan to hijack that for hardware timestamps in the future
> anyway.
> 
> Is there a single driver which uses the timecode field? The fact is
> that many m2m drivers copy it but that's probably mostly copying what
> one of them happened to do by accident. :-)

Let's focus on not breaking m2m drivers with timestamp patches this time.
I'm sure it was a matter of accident with the initial timestamp patches.

I agree with Hans here, not sure about hijacking it in the future, though.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

