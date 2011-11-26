Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:60415 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KZLjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 06:39:21 -0500
Date: Sat, 26 Nov 2011 13:39:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4][media] Exynos4 JPEG codec v4l2 driver
Message-ID: <20111126113916.GB29805@valkosipuli.localdomain>
References: <1322213893-5462-1-git-send-email-andrzej.p@samsung.com>
 <20111126095625.GA29805@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126095625.GA29805@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 26, 2011 at 11:56:25AM +0200, Sakari Ailus wrote:
> Hi Andrzej and others,
> 
> On Fri, Nov 25, 2011 at 10:38:13AM +0100, Andrzej Pietrasiewicz wrote:
> ...
> > +static int s5p_jpeg_s_jpegcomp(struct file *file, void *priv,
> > +			       struct v4l2_jpegcompression *compr)
> > +{
> > +	struct s5p_jpeg_ctx *ctx = priv;
> > +
> > +	if (ctx->mode == S5P_JPEG_DECODE)
> > +		return -ENOTTY;
> > +
> > +	compr->quality = clamp(compr->quality, S5P_JPEG_COMPR_QUAL_BEST,
> > +			       S5P_JPEG_COMPR_QUAL_WORST);
> > +
> > +	ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - compr->quality;
> > +
> > +	return 0;
> 
> The quality paramaeter of VIDIOC_S_JPEGCOMP is badly documented and its
> value range is unspecified. To make the matter worse, VIDIOC_S_JPEGCOMP is a
> write-only IOCTL, so the user won't be able to know the value the driver
> uses. This forces the user space to know the value range for quality. I
> think we have a good change to resolve the matter properly now.
> 
> I can think of two alternatives, both of which are very simple.
> 
> 1) Define the value range for v4l2_jpegcompression. The driver implements
> four, so they essentially would be 0, 33, 66 and 100, if 0--100 is chosen as
> the standard range. This is what I have seen is often used by jpeg
> compression programs.
> 
> 2) Define a new control for jpeg quality. Its value range can be what the
> hardware supports and the user space gets much better information on the
> capabilities of the hardware and the granularity of the quality setting.
> 
> I might even favour the second one. I also wonder how many user space
> applications use this IOCTL, so if we're breaking anything by not supporting
> it.
> 
> Or we could decide to do option 1 right now and implement 2) later on. I can
> write a patch to change the documentation.

Hi,

I later on figured out one _can_ get this information using
VIDIOC_G_JPEGCOMP. It's not a very good interface, but works. What do you
think?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
