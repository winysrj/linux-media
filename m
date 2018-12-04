Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58268 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeLDOiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 09:38:09 -0500
Date: Tue, 4 Dec 2018 12:38:04 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, bingbu.cao@intel.com
Subject: Re: [PATCH 1/1] v4l uapi: Make "Vertical Colour Bars" menu item a
 little more generic
Message-ID: <20181204123804.1de564d1@coco.lan>
In-Reply-To: <20181204123232.7901ab7e@coco.lan>
References: <20181204134506.21529-1-sakari.ailus@linux.intel.com>
        <20181204123232.7901ab7e@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 4 Dec 2018 12:32:32 -0200
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Tue,  4 Dec 2018 15:45:06 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > The test pattern could contain a different number of colour bars than
> > eight, make the entry more useful by removing "Eight " from the name.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/uapi/linux/v4l2-controls.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index acb2a57fa5d6..88f2759c2ce4 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -1016,7 +1016,7 @@ enum v4l2_jpeg_chroma_subsampling {
> >  #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> >  #define V4L2_TEST_PATTERN_DISABLED		"Disabled"
> >  #define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
> > -#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Eight Vertical Colour Bars"
> > +#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Vertical Colour Bars"
> 
> No, we can't do that. This is on an uAPI file.
> 
> We should, instead, create another #define for non-eight vertical
> color bars.
> 
> Before you say, yeah, I agree that we messed this one, as the defined
> name doesn't mention 8 bars...
> 
> I would, instead, do something like:
> 
> -#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	"Eight Vertical Colour Bars"
> +#define V4L2_TEST_PATTERN_VERT_8_COLOUR_BARS	"Eight Vertical Colour Bars"
> +#define V4L2_TEST_PATTERN_VERT_N_COLOUR_BARS	"Vertical Colour Bars"
> +
> + /* Kept for backward-compatibility */
> +#define V4L2_TEST_PATTERN_VERT_COLOUR_BARS	V4L2_TEST_PATTERN_VERT_8_COLOUR_BARS
> 
> And, of course, update the documentation accordingly.

Please ignore this comment. I didn't realize that those definitions
don't exist yet at the uAPI file, and that this is a follow up for
another patch:
	
	Subject: [PATCH v2 1/1] media: Use common test pattern menu entries

Next time, please put them into a patch series, as it makes easier for
reviewers.

Thanks,
Mauro
