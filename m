Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56046
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750897AbdCJUms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 15:42:48 -0500
Date: Fri, 10 Mar 2017 17:42:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170310174228.3fe39100@vento.lan>
In-Reply-To: <20170310155708.GX21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
        <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
        <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
        <20170303230645.GR21222@n2100.armlinux.org.uk>
        <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
        <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
        <20170310130733.GU21222@n2100.armlinux.org.uk>
        <20170310122634.0ffda7c6@vento.lan>
        <20170310155708.GX21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Mar 2017 15:57:09 +0000
Russell King - ARM Linux <linux@armlinux.org.uk> escreveu:

> On Fri, Mar 10, 2017 at 12:26:34PM -0300, Mauro Carvalho Chehab wrote:
> > Hi Russell,
> > 
> > Em Fri, 10 Mar 2017 13:07:33 +0000
> > Russell King - ARM Linux <linux@armlinux.org.uk> escreveu:
> >   
> > > The idea that the v4l libraries should intercept the format negotiation
> > > between the application and kernel is a particularly painful one - the
> > > default gstreamer build detects the v4l libraries, and links against it.
> > > That much is fine.
> > > 
> > > However, the problem comes when you're trying to use bayer formats. The
> > > v4l libraries "helpfully" (or rather unhelpfully) intercept the format
> > > negotiation, and decide that they'll invoke v4lconvert to convert the
> > > bayer to RGB for you, whether you want them to do that or not.
> > > 
> > > v4lconvert may not be the most efficient way to convert, or even what
> > > is desired (eg, you may want to receive the raw bayer image.)  However,
> > > since the v4l libraries/v4lconvert gives you no option but to have its
> > > conversion forced into the pipeline, other options (such as using the
> > > gstreamer neon accelerated de-bayer plugin) isn't an option   
> > 
> > That's not true. There is an special flag, used only by libv4l2
> > emulated formats, that indicates when a video format is handled
> > via v4lconvert:  
> 
> I'm afraid that my statement comes from trying to use gstreamer with
> libv4l2 and _not_ being able to use the 8-bit bayer formats there at
> all - they are simply not passed across to the application through
> libv4l2/v4lconvert.
> 
> Instead, the formats that are passed across are the emulated formats.
> As I said above, that forces applications to use only the v4lconvert
> formats, the raw formats are not available.
> 
> So, the presence or absence of the V4L2_FMT_FLAG_EMULATED is quite
> meaningless if you can't even enumerate the non-converted formats.
> 
> The problem comes from the "always needs conversion" stuff in
> v4lconvert coupled with the way this subdev stuff works - since it
> requires manual configuration of all the pads within the kernel
> media pipeline, the kernel ends up only advertising _one_ format
> to userspace - in my case, that's RGGB8.
> 
> When v4lconvert_create_with_dev_ops() enumerates the formats from
> the kernel, it gets only RGGB8.  That causes always_needs_conversion
> in there to remain true, so the special v4l control which enables/
> disables conversion gets created with a default value of "true".
> The RGGB8 bit is also set in data->supported_src_formats.
> 
> This causes v4lconvert_supported_dst_fmt_only() to return true.
> 
> What this all means is that v4lconvert_enum_fmt() will _not_ return
> any of the kernel formats, only the faked formats.
> 
> Ergo, the RGGB8 format from the kernel is completely hidden from the
> application, and only the emulated format is made available.  As I
> said above, this forces v4lconvert's debayering on the application,
> whether you want it or not.
> 
> In the gstreamer case, it knows nothing about this special control,
> which means that trying to use this gstreamer pipeline:
> 
> $ gst-launch-1.0 v4l2src device=/dev/video6 ! bayer2rgbneon ! xvimagesink
> 
> is completely impossible without first rebuilding gstreamer _without_
> libv4l support.  Build gstreamer without libv4l support, and the above
> works.
> 
> Enabling debug output in gstreamer's v4l2src plugin confirms that
> the kernel's bayer format are totally hidden from gstreamer when
> linked with libv4l2, but are present when it isn't linked with
> libv4l2.

Argh! that is indeed a bug at libv4l (and maybe at gstreamer).

I guess that the always_needs_conversion logic was meant to be used to
really odd proprietary formats, e. g:
	
/*  Vendor-specific formats   */
#define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
#define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /* Winnov hw compress */
#define V4L2_PIX_FMT_SN9C10X  v4l2_fourcc('S', '9', '1', '0') /* SN9C10x compression */
...

I suspect that nobody uses libv4l2 with MC-based V4L2 devices. That's
likely why nobody reported this bug before (that I know of).

In any case, for non-proprietary formats, the default should be to
always offer both the emulated format and the original one.

I suspect that the enclosed patch should fix the issue with bayer formats.

> 

Thanks,
Mauro

[PATCH RFC] libv4lconvert: by default, offer the original format to the client

Applications should have the right to decide between using a
libv4lconvert emulated format or to implement the decoding themselves,
as this may have significative performance impact.

So, change the default to always show both formats.

Change also the default for Bayer encoded formats, as userspace
likely will want to handle it directly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index da718918b030..2e5458fa420d 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -118,10 +118,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_OV511,		 0,	 7,	 7,	1 },
 	{ V4L2_PIX_FMT_OV518,		 0,	 7,	 7,	1 },
 	/* uncompressed bayer */
-	{ V4L2_PIX_FMT_SBGGR8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SBGGR8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
@@ -178,7 +178,7 @@ struct v4lconvert_data *v4lconvert_create_with_dev_ops(int fd, void *dev_ops_pri
 	/* This keeps tracks of devices which have only formats for which apps
 	   most likely will need conversion and we can thus safely add software
 	   processing controls without a performance impact. */
-	int always_needs_conversion = 1;
+	int always_needs_conversion = 0;
 
 	if (!data) {
 		fprintf(stderr, "libv4lconvert: error: out of memory!\n");
@@ -208,8 +208,8 @@ struct v4lconvert_data *v4lconvert_create_with_dev_ops(int fd, void *dev_ops_pri
 		if (j < ARRAY_SIZE(supported_src_pixfmts)) {
 			data->supported_src_formats |= 1ULL << j;
 			v4lconvert_get_framesizes(data, fmt.pixelformat, j);
-			if (!supported_src_pixfmts[j].needs_conversion)
-				always_needs_conversion = 0;
+			if (supported_src_pixfmts[j].needs_conversion)
+				always_needs_conversion = 1;
 		} else
 			always_needs_conversion = 0;
 	}
