Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56508 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756021AbcAYLjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 06:39:13 -0500
Date: Mon, 25 Jan 2016 13:39:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/1] v4l: libv4l2subdev: Precisely convert
 media bus string to code
Message-ID: <20160125113909.GA14876@valkosipuli.retiisi.org.uk>
References: <1449674087-19122-1-git-send-email-sakari.ailus@linux.intel.com>
 <32957783.JQTylZjONc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32957783.JQTylZjONc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Dec 13, 2015 at 11:33:45PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Wednesday 09 December 2015 17:14:47 Sakari Ailus wrote:
> > The length of the string was ignored, making it possible for the
> > conversion to fail due to extra characters in the string.
> 
> I'm not sure to follow you there. Is the issue that passing a string such as 
> "SBGGR10" would match "SBGGR10_DPCM8" if it was listed before "SBGGR10" ? If 
> that's the case I'd write the commit message as

Yes, that's the problem.

> 
> Any character beyond the fist `length' characters in the mbus_formats strings
> are ignored, causing incorrect matches if the format entry starts with but 
> isn't equal to the passed format.

I'll use this commit message then.

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > This patch should be applied before the set "[v4l-utils PATCH v2 0/3] List
> > supported formats in libv4l2subdev":
> > 
> > <URL:http://www.spinics.net/lists/linux-media/msg95377.html>
> > 
> >  utils/media-ctl/libv4l2subdev.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/utils/media-ctl/libv4l2subdev.c
> > b/utils/media-ctl/libv4l2subdev.c index 33c1ee6..cce527d 100644
> > --- a/utils/media-ctl/libv4l2subdev.c
> > +++ b/utils/media-ctl/libv4l2subdev.c
> > @@ -769,14 +769,12 @@ enum v4l2_mbus_pixelcode
> > v4l2_subdev_string_to_pixelcode(const char *string, unsigned int i;
> > 
> >  	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
> > -		if (strncmp(mbus_formats[i].name, string, length) == 0)
> > -			break;
> > +		if (strncmp(mbus_formats[i].name, string, length) == 0
> > +		    && strlen(mbus_formats[i].name) == length)
> 
> How about mbus_formats[i].name[length] == '\0' instead ? That should be more 
> efficient.

Fine for me.

> 
> I also wonder whether we shouldn't just get rid of the length argument and 
> force the passed format string to be zero-terminated.

I believe the reason is that the current user (media-ctl test program)
parses the user input and passes a portion of that to this function to
convert the string to a numeric value. That'd be a bit more cumbersome as
we'd either require copying the string elsewhere or changing the input by
the program. I wouldn't change the behaviour, at least not now.

> 
> > +			return mbus_formats[i].code;
> >  	}
> > 
> > -	if (i == ARRAY_SIZE(mbus_formats))
> > -		return (enum v4l2_mbus_pixelcode)-1;
> > -
> > -	return mbus_formats[i].code;
> > +	return (enum v4l2_mbus_pixelcode)-1;
> >  }
> > 
> >  static struct {
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
