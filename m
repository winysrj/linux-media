Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54648 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077AbcBOPc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 10:32:26 -0500
Date: Mon, 15 Feb 2016 17:32:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 4/4] media-ctl: List supported media bus formats
Message-ID: <20160215153223.GM32612@valkosipuli.retiisi.org.uk>
References: <1453725585-4165-1-git-send-email-sakari.ailus@linux.intel.com>
 <1453725585-4165-5-git-send-email-sakari.ailus@linux.intel.com>
 <1476638.kPuICUNqPa@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476638.kPuICUNqPa@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2016 at 04:44:35PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Monday 25 January 2016 14:39:45 Sakari Ailus wrote:
> > Add a new topic option for -h to allow listing supported media bus codes
> > in conversion functions. This is useful in figuring out which media bus
> > codes are actually supported by the library. The numeric values of the
> > codes are listed as well.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  utils/media-ctl/options.c | 42 ++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 38 insertions(+), 4 deletions(-)
> > 
> > diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
> > index 0afc9c2..c67052d 100644
> > --- a/utils/media-ctl/options.c
> > +++ b/utils/media-ctl/options.c
> > @@ -22,7 +22,9 @@
> >  #include <getopt.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> > +#include <string.h>
> >  #include <unistd.h>
> > +#include <v4l2subdev.h>
> > 
> >  #include <linux/videodev2.h>
> > 
> > @@ -45,7 +47,8 @@ static void usage(const char *argv0)
> >  	printf("-V, --set-v4l2 v4l2	Comma-separated list of formats to setup\n");
> >  	printf("    --get-v4l2 pad	Print the active format on a given pad\n");
> >  	printf("    --set-dv pad	Configure DV timings on a given pad\n");
> > -	printf("-h, --help		Show verbose help and exit\n");
> > +	printf("-h, --help[=topic]	Show verbose help and exit\n");
> > +	printf("			topics:	mbus-fmt: List supported media bus pixel 
> codes\n");
> >  	printf("-i, --interactive	Modify links interactively\n");
> >  	printf("-l, --links links	Comma-separated list of link descriptors to
> > setup\n"); printf("-p, --print-topology	Print the device topology\n");
> > @@ -100,7 +103,7 @@ static struct option opts[] = {
> >  	{"get-format", 1, 0, OPT_GET_FORMAT},
> >  	{"get-v4l2", 1, 0, OPT_GET_FORMAT},
> >  	{"set-dv", 1, 0, OPT_SET_DV},
> > -	{"help", 0, 0, 'h'},
> > +	{"help", 2, 0, 'h'},
> >  	{"interactive", 0, 0, 'i'},
> >  	{"links", 1, 0, 'l'},
> >  	{"print-dot", 0, 0, OPT_PRINT_DOT},
> > @@ -110,6 +113,27 @@ static struct option opts[] = {
> >  	{ },
> >  };
> > 
> > +void list_mbus_formats(void)
> > +{
> > +	unsigned int i;
> > +
> > +	printf("Supported media bus pixel codes\n");
> > +
> > +	for (i = 0; ; i++) {
> > +		unsigned int code = v4l2_subdev_pixelcode_list()[i];
> 
> How about calling the function outside of the loop ?

The function only returns an existing array. I could change it, but please
give a reason why. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
