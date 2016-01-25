Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34392 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbcAYTkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 14:40:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/1] v4l: libv4l2subdev: Precisely convert media bus string to code
Date: Mon, 25 Jan 2016 21:41:12 +0200
Message-ID: <1490379.zWhzdjB0Zz@avalon>
In-Reply-To: <20160125113909.GA14876@valkosipuli.retiisi.org.uk>
References: <1449674087-19122-1-git-send-email-sakari.ailus@linux.intel.com> <32957783.JQTylZjONc@avalon> <20160125113909.GA14876@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 25 January 2016 13:39:10 Sakari Ailus wrote:
> On Sun, Dec 13, 2015 at 11:33:45PM +0200, Laurent Pinchart wrote:
> > On Wednesday 09 December 2015 17:14:47 Sakari Ailus wrote:
> >> The length of the string was ignored, making it possible for the
> >> conversion to fail due to extra characters in the string.
> > 
> > I'm not sure to follow you there. Is the issue that passing a string such
> > as "SBGGR10" would match "SBGGR10_DPCM8" if it was listed before
> > "SBGGR10" ? If that's the case I'd write the commit message as
> 
> Yes, that's the problem.
> 
> > Any character beyond the fist `length' characters in the mbus_formats
> > strings are ignored, causing incorrect matches if the format entry starts
> > with but isn't equal to the passed format.
> 
> I'll use this commit message then.
> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> This patch should be applied before the set "[v4l-utils PATCH v2 0/3]
> >> List supported formats in libv4l2subdev":
> >> 
> >> <URL:http://www.spinics.net/lists/linux-media/msg95377.html>
> >> 
> >>  utils/media-ctl/libv4l2subdev.c | 10 ++++------
> >>  1 file changed, 4 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/utils/media-ctl/libv4l2subdev.c
> >> b/utils/media-ctl/libv4l2subdev.c index 33c1ee6..cce527d 100644
> >> --- a/utils/media-ctl/libv4l2subdev.c
> >> +++ b/utils/media-ctl/libv4l2subdev.c
> >> @@ -769,14 +769,12 @@ enum v4l2_mbus_pixelcode
> >> v4l2_subdev_string_to_pixelcode(const char *string,
> >> 	unsigned int i;
> >> 
> >>  	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
> >> -		if (strncmp(mbus_formats[i].name, string, length) == 0)
> >> -			break;
> >> +		if (strncmp(mbus_formats[i].name, string, length) == 0
> >> +		    && strlen(mbus_formats[i].name) == length)
> > 
> > How about mbus_formats[i].name[length] == '\0' instead ? That should be
> > more efficient.
> 
> Fine for me.
> 
> > I also wonder whether we shouldn't just get rid of the length argument and
> > force the passed format string to be zero-terminated.
> 
> I believe the reason is that the current user (media-ctl test program)
> parses the user input and passes a portion of that to this function to
> convert the string to a numeric value. That'd be a bit more cumbersome as
> we'd either require copying the string elsewhere or changing the input by
> the program. I wouldn't change the behaviour, at least not now.

Yes that's the reason, and I think it's an API design mistake (or just a lack 
of proper API design :-)). Wouldn't it be better to copy the string in the 
caller ?

> >> +			return mbus_formats[i].code;
> >>  	}
> >> 
> >> -	if (i == ARRAY_SIZE(mbus_formats))
> >> -		return (enum v4l2_mbus_pixelcode)-1;
> >> -
> >> -	return mbus_formats[i].code;
> >> +	return (enum v4l2_mbus_pixelcode)-1;
> >>  }
> >>  
> >>  static struct {

-- 
Regards,

Laurent Pinchart

