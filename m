Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54692 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993AbaBYLov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 06:44:51 -0500
Date: Tue, 25 Feb 2014 13:44:46 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
Message-ID: <20140225114446.GE15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-3-git-send-email-sakari.ailus@iki.fi>
 <5309E05E.4030108@xs4all.nl>
 <530B668D.6010903@iki.fi>
 <125b01cf317b$67b61b80$37225280$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <125b01cf317b$67b61b80$37225280$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil and Hans,

On Mon, Feb 24, 2014 at 05:13:49PM +0100, Kamil Debski wrote:
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: Monday, February 24, 2014 4:35 PM
> > 
> > Hans Verkuil wrote:
> > > On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> > >> The buffer flags field is 32 bits but the defined only used 16. This
> > >> is fine, but as more than 16 bits will be used in the very near
> > >> future, define them as 32-bit numbers for consistency.
> > >>
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > >> ---
> > >>  Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++---------
> > ----
> > >>  include/uapi/linux/videodev2.h         |   38 +++++++++++++++++++--
> > -----------
> > >>  2 files changed, 38 insertions(+), 30 deletions(-)
> > >>
> > >> diff --git a/Documentation/DocBook/media/v4l/io.xml
> > >> b/Documentation/DocBook/media/v4l/io.xml
> > >> index 8facac4..46d24b3 100644
> > >> --- a/Documentation/DocBook/media/v4l/io.xml
> > >> +++ b/Documentation/DocBook/media/v4l/io.xml
> > >
> > > <snip>
> > >
> > >> @@ -1115,7 +1115,7 @@ in which case caches have not been
> > used.</entry>
> > >>  	  </row>
> > >>  	  <row>
> > >>
> > <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
> > >> -	    <entry>0x4000</entry>
> > >> +	    <entry>0x00004000</entry>
> > >>  	    <entry>The CAPTURE buffer timestamp has been taken from the
> > >>  	    corresponding OUTPUT buffer. This flag applies only to
> > mem2mem devices.</entry>
> > >>  	  </row>
> > >
> > > Should we add here that if TIMESTAMP_COPY is set and the TIMECODE
> > flag
> > > is set, then drivers should copy the TIMECODE struct as well? This is
> > > happening already in various drivers and I think that is appropriate.
> > > Although to be honest nobody is actually using the timecode struct,
> > > but we plan to hijack that for hardware timestamps in the future
> > anyway.
> > 
> > Is there a single driver which uses the timecode field? The fact is
> > that many m2m drivers copy it but that's probably mostly copying what
> > one of them happened to do by accident. :-)
> 
> Let's focus on not breaking m2m drivers with timestamp patches this time.
> I'm sure it was a matter of accident with the initial timestamp patches.

This patch extends the documentation of the buffer flags from 16 bits to 32
bits. There are no other changes in functionality nor documentation.

The patchset does indeed change the way timestamp and timestamp flags are
copied: from source to destination rather than the other way around. I'd
appreciate if you'd review especially that one (patch 5/7).

There are no other changes to the way timestamps (or timecode) are handled.

> I agree with Hans here, not sure about hijacking it in the future, though.

This patchset does not change the handling of the timecode field, other than
the fixes in patch 5/7. I would prefer to get this old patchset in and unify
the timecode field handling once it has been discussed and agreed on.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
