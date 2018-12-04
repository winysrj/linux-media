Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52858 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbeLDNlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 08:41:40 -0500
Date: Tue, 4 Dec 2018 15:41:35 +0200
From: sakari.ailus@iki.fi
To: Bingbu Cao <bingbu.cao@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, bingbu.cao@intel.com,
        luca@lucaceresoli.net, ady.yeh@intel.com, tfiga@chromium.org
Subject: Re: [PATCH 1/1] media: Use common test pattern menu entries
Message-ID: <20181204134135.3fpcpdcgu5bdtxr2@valkosipuli.retiisi.org.uk>
References: <20181127093341.8909-1-sakari.ailus@linux.intel.com>
 <e6b5e98d-0a32-baee-4be3-b67da97b2964@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b5e98d-0a32-baee-4be3-b67da97b2964@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 07:19:52PM +0800, Bingbu Cao wrote:
> 
> On 11/27/2018 05:33 PM, Sakari Ailus wrote:
> > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > index 998983a6e6b7..a74ff6f1ac88 100644
> > --- a/include/uapi/linux/v4l2-controls.h
> > +++ b/include/uapi/linux/v4l2-controls.h
> > @@ -1014,6 +1014,11 @@ enum v4l2_jpeg_chroma_subsampling {
> >   #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
> >   #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
> >   #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> > +#define V4L2_TEST_PATTERN_DISABLED		"Disabled"
> > +#define V4L2_TEST_PATTERN_SOLID_COLOUR		"Solid Colour"
> > +#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS		"Eight Vertical Colour Bars"
> > +#define V4L2_TEST_PATTERN_8_VERT_COLOUR_BARS_FADE_TO_GREY "Colour Bars With Fade to Grey"
> > +#define V4L2_TEST_PATTERN_PN9			"Pseudorandom Sequence (PN9)"
> More padding here for alignment?

Fixed in v2.

-- 
Sakari Ailus
