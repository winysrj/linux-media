Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42071 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaE2PAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:00:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 1/3] v4l: Add test pattern colour component controls
Date: Thu, 29 May 2014 17:01:10 +0200
Message-ID: <1559123.5XHCoOtRWQ@avalon>
In-Reply-To: <53874B33.5050109@linux.intel.com>
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <48325310.Ydj7bxFi9C@avalon> <53874B33.5050109@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 May 2014 17:58:59 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Thursday 29 May 2014 17:40:46 Sakari Ailus wrote:
> >> In many cases the test pattern has selectable values for each colour
> >> component. Implement controls for raw bayer components. Additional
> >> controls
> >> should be defined for colour components that are not covered by these
> >> controls.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> 
> >>   Documentation/DocBook/media/v4l/controls.xml | 34 +++++++++++++++++++++
> >>   drivers/media/v4l2-core/v4l2-ctrls.c         |  4 ++++
> >>   include/uapi/linux/v4l2-controls.h           |  4 ++++
> >>   3 files changed, 42 insertions(+)
> >> 
> >> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >> b/Documentation/DocBook/media/v4l/controls.xml index 47198ee..bf23994
> >> 100644
> >> --- a/Documentation/DocBook/media/v4l/controls.xml
> >> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >> @@ -4677,6 +4677,40 @@ interface and may change in the future.</para>
> >>   	    conversion.
> >>   	    </entry>
> >>   	  </row>
> >> +	  <row>
> >> +	    <entry
> >> spanname="id"><constant>V4L2_CID_TEST_PATTERN_RED</constant></entry>
> >> +       <entry>integer</entry>
> >> +	  </row>
> >> +	  <row>
> >> +	    <entry spanname="descr">Test pattern red colour component.
> >> +	    </entry>
> >> +	  </row>
> >> +	  <row>
> >> +	    <entry
> >> spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENR</constant></entry>
> >> +	    <entry>integer</entry>
> >> +	  </row>
> >> +	  <row>
> >> +	    <entry spanname="descr">Test pattern green (next to red)
> >> +	    colour component.
> > 
> > What about non-Bayer RGB sensors ? Should they use the GREENR or the
> > GREENB control for the green component ? Or a different control ?
> 
> A different one. It should be simply green. I could add it to the same
> patch if you wish.
> 
> > I'm wondering whether we shouldn't have a single test pattern color
> > control and create a color type using Hans' complex controls API.
> 
> A raw bayer four-pixel value, you mean?

Yes. I'll let Hans comment on that.

-- 
Regards,

Laurent Pinchart

