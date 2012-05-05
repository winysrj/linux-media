Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43145 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2EEWy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 18:54:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 2/3] New, more flexible syntax for media-ctl
Date: Sun, 06 May 2012 00:54:54 +0200
Message-ID: <2542901.vLyHxKHSqR@avalon>
In-Reply-To: <20120505130933.GI852@valkosipuli.localdomain>
References: <1336119883-14978-1-git-send-email-sakari.ailus@iki.fi> <14849350.mp0nWfDsvJ@avalon> <20120505130933.GI852@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 05 May 2012 16:09:33 Sakari Ailus wrote:
> On Sat, May 05, 2012 at 02:22:26PM +0200, Laurent Pinchart wrote:
> > On Friday 04 May 2012 11:24:42 Sakari Ailus wrote:
> > > More flexible and extensible syntax for media-ctl which allows better
> > > usage
> > > of the selection API.
> > 
> > [snip]
> > 
> > > diff --git a/src/options.c b/src/options.c
> > > index 60cf6d5..4d9d48f 100644
> > > --- a/src/options.c
> > > +++ b/src/options.c
> > > @@ -53,12 +53,15 @@ static void usage(const char *argv0, int verbose)
> > > 
> > >  	printf("\n");
> > >  	printf("Links and formats are defined as\n");
> > >  	printf("\tlink            = pad, '->', pad, '[', flags, ']' ;\n");
> > > 
> > > -	printf("\tformat          = pad, '[', fcc, ' ', size, [ ' ', crop ], 
[
> > > '
> > > ', '@', frame interval ], ']' ;\n");
> > > +	printf("\tformat          = pad, '[', formats ']' ;\n");
> > > +	printf("\tformats         = formats ',' formats ;\n");
> > > +	printf("\tformats         = fmt | crop | frame interval ;\n");
> > 
> > That's not a valid EBNF. I'm not an expert on the subject, but I think the
> > following is better.
> > 
> > formats = format { ' ', formats }
> > format = fmt | crop | frame interval
> 
> I'm fine with that change.
> 
> > > +	printf("\fmt              = 'fmt:', fcc, '/', size ;\n");
> > 
> > format, formats and fmt are becoming confusing. A different name for
> > 'formats' would be good.
> 
> I agree but I didn't immediately come up with something better.

I haven't found a better option at first sight either, let's try to sleep on 
it.

> The pixel format and the image size at the pad are clearly format
> (VIDIOC_SUBDEV_S_FMT) but the other things are related to pads but not
> format.
> 
> I see them different kinds of properties of pads. That suggests we might be
> better renaming the option (-f) to something else as well.

You like breaking interfaces, don't you ? :-D

> > I find the '/' a bit confusing compared to the ' ' (but I think you find
> > the space confusing compared to '/' :-)). I also wonder whether we
> > shouldn't just drop 'fmt:', as there can be a single format only.
> 
> You can set it multiple times, or you may not set it at all. That's why I
> think we should explicitly say it's the format.

Not at all makes sense, but why would you set it multiple times ?

> > >  	printf("\tpad             = entity, ':', pad number ;\n");
> > >  	printf("\tentity          = entity number | ( '\"', entity name, '\"'
> > >  	)
> > > 
> > > ;\n");
> > > 
> > >  	printf("\tsize            = width, 'x', height ;\n");
> > > 
> > > -	printf("\tcrop            = '(', left, ',', top, ')', '/', size ;
\n");
> > > -	printf("\tframe interval  = numerator, '/', denominator ;\n");
> > > +	printf("\tcrop            = 'crop.actual:', left, ',', top, '/', size
> > > ;\n");
> > 
> > Would it make sense to make .actual implicit ? Both 'crop' and
> > 'crop.actual' would be supported by the parser. The code would be more
> > generic if the target was parsed in a generic way, not associated with
> > the rectangle name.
> I've been also thinking does the actual / active really signify something,
> or should that be even dropped form the V4L2 / V4L2 subdev interface
> definitions.
> 
> > I would keep the parenthesis around the (top,left) coordinates. You could
> > then define
> > 
> > rectangle = '(', left, ',', top, ')', '/', size
> > crop = 'crop' [ '.', target ] ':', rectangle
> > target = 'actual'
> > 
> > or something similar.
> 
> Sounds good to me.
> 
> > What about also keeping compatibility with the existing syntax (both for
> > formats and crop rectangles) ? That shouldn't be too difficult in the
> > parser, crop rectangles start with a '(', and formats come first. We
> > would then have
> > 
> > rectangle = '(', left, ',', top, ')', '/', size
> > crop = [ 'crop' [ '.', target ] ':' ], rectangle
> > target = 'actual'
> 
> I'll see what I can do. We still should drop the documentation for this so
> that people will stop writing rules that look like that.

Good point, I agree.

-- 
Regards,

Laurent Pinchart

