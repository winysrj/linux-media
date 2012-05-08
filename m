Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39470 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab2EHUVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 16:21:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH v2 1/2] New, more flexible syntax for format
Date: Tue, 08 May 2012 22:21:46 +0200
Message-ID: <1763414.OFvOj7o1m5@avalon>
In-Reply-To: <4FA97776.3030408@iki.fi>
References: <1336398396-31526-1-git-send-email-sakari.ailus@iki.fi> <1529968.u1eeiRTNpn@avalon> <4FA97776.3030408@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 08 May 2012 22:43:50 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Monday 07 May 2012 16:46:35 Sakari Ailus wrote:
> >> More flexible and extensible syntax for format which allows better usage
> >> of the selection API.

[snip]

> >> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> >> index a2ab0c4..6881553 100644
> >> --- a/src/v4l2subdev.c
> >> +++ b/src/v4l2subdev.c
> >> @@ -233,13 +233,13 @@ static int v4l2_subdev_parse_format(struct
> >> v4l2_mbus_framefmt *format, char *end;
> >> 
> >>  	for (; isspace(*p); ++p);
> >> 
> >> -	for (end = (char *)p; !isspace(*end) && *end != '\0'; ++end);
> >> +	for (end = (char *)p; *end != '/' && *end != '\0'; ++end);
> > 
> > I wouldn't change this to keep compatibility with the existing syntax.
> 
> Ok. How about allowing both '/' and ' '?

Do you hate the space that much ? :-) The format code and the resolution are 
not that closely related, / somehow doesn't look intuitive to me.

> >>  	code = v4l2_subdev_string_to_pixelcode(p, end - p);
> >>  	if (code == (enum v4l2_mbus_pixelcode)-1)
> >>  	
> >>  		return -EINVAL;
> >> 
> >> -	for (p = end; isspace(*p); ++p);
> >> +	p = end + 1;
> >> 
> >>  	width = strtoul(p, &end, 10);
> >>  	if (*end != 'x')
> >>  	
> >>  		return -EINVAL;
> >> 

[snip]

> >> @@ -326,30 +337,37 @@ static struct media_pad
> >> *v4l2_subdev_parse_pad_format( if (*p++ != '[')
> >> 
> >>  		return NULL;
> >> 
> >> -	for (; isspace(*p); ++p);
> >> +	for (;;) {
> >> +		for (; isspace(*p); p++);
> >> 
> >> -	if (isalnum(*p)) {
> >> -		ret = v4l2_subdev_parse_format(format, p, &end);
> >> -		if (ret < 0)
> >> -			return NULL;
> >> +		if (!strhazit("fmt:", &p)) {
> >> +			ret = v4l2_subdev_parse_format(format, p, &end);
> >> +			if (ret < 0)
> >> +				return NULL;
> >> 
> >> -		for (p = end; isspace(*p); p++);
> >> -	}
> >> +			p = end;
> >> +			continue;
> >> +		}
> > 
> > I'd like to keep compatibility with the existing syntax here. Checking
> > whether this is the first argument and whether it starts with an
> > uppercase letter should be enough, would you be OK with that ?
> 
> Right. I may have missed something related to keeping the compatibility.
> 
> Capital letter might not be enough in the future; for now it's ok
> though. How about this: if the string doesn't match with anything else,
> interpret it as format?

I've thought about this, but I'm not sure it's a good idea to introduce 
extensions to the existing syntax (we currently have no format starting with 
something else than an uppercase letter) as we're deprecating it.

-- 
Regards,

Laurent Pinchart

