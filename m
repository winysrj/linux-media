Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47022 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755270AbcBWUYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 15:24:04 -0500
Date: Tue, 23 Feb 2016 22:24:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-utils PATCH 4/4] media-ctl: List supported media bus formats
Message-ID: <20160223202400.GA11084@valkosipuli.retiisi.org.uk>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160223161150.GA32612@valkosipuli.retiisi.org.uk>
 <56CC8593.6090005@xs4all.nl>
 <3174978.uNIbAnUxCz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3174978.uNIbAnUxCz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Feb 23, 2016 at 10:15:46PM +0200, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 23 February 2016 17:15:15 Hans Verkuil wrote:
> > On 02/23/2016 05:11 PM, Sakari Ailus wrote:
> > > On Tue, Feb 23, 2016 at 01:18:53PM +0100, Hans Verkuil wrote:
> > >> On 02/21/16 22:29, Sakari Ailus wrote:
> > >>> Add a new topic option for -h to allow listing supported media bus codes
> > >>> in conversion functions. This is useful in figuring out which media bus
> > >>> codes are actually supported by the library. The numeric values of the
> > >>> codes are listed as well.
> > >>> 
> > >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>> ---
> > >>> 
> > >>>  utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++++++----
> > >>>  1 file changed, 38 insertions(+), 4 deletions(-)
> > >>> 
> > >>> diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> > >>> index 0afc9c2..55cdd29 100644
> > >>> --- a/utils/media-ctl/options.c
> > >>> +++ b/utils/media-ctl/options.c
> > >>> @@ -22,7 +22,9 @@
> > >>>  #include <getopt.h>
> > >>>  #include <stdio.h>
> > >>>  #include <stdlib.h>
> > >>> +#include <string.h>
> > >>>  #include <unistd.h>
> > >>> +#include <v4l2subdev.h>
> > >>> 
> > >>>  #include <linux/videodev2.h>
> > >>> 
> > >>> @@ -45,7 +47,8 @@ static void usage(const char *argv0)
> > >>>  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to
> > >>>  	setup\n");
> > >>>  	printf("    --get-v4l2 pad	Print the active format on a given 
> pad\n");
> > >>>  	printf("    --set-dv pad	Configure DV timings on a given pad\n");
> > >>> -	printf("-h, --help		Show verbose help and exit\n");
> > >>> +	printf("-h, --help[=topic]	Show verbose help and exit\n");
> > >>> +	printf("			topics:	mbus-fmt: List supported media bus pixel 
> codes\n");
> > >> 
> > >> OK, this is ugly. It has nothing to do with usage help.
> > >> 
> > >> Just make a new option --list-mbus-fmts to list supported media bus pixel
> > >> codes.
> > >> 
> > >> That would make much more sense.
> > > 
> > > I added it as a --help option argument in order to imply it's a part of
> > > the program's usage instructions, which is what it indeed is. It's not a
> > > list of media bus formats supported by a device.
> > > 
> > > A separate option is fine, but it should be clear that it's about just
> > > listing supported formats. E.g. --list-supported-mbus-fmts. But that's a
> > > long one. Long options are loooong.
> > 
> > --list-known-mbus-fmts will do the trick.
> 
> That doesn't feel right. Isn't it a help option, really, given that it lists 
> the formats you can use as command line arguments ?
> 
> Another option would actually be to always print the formats when the -h 
> switch is given. We could print them in a comma-separated list with multiple 
> formats per line, possibly dropping the numerical value, it should hopefully 
> not be horrible.

I'd prefer to keep the numerical value as well; the link validation code in
drivers may print the media bus code at each end in case they do not match.
To debug that, it's easy to grep that from the list media-ctl prints.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
