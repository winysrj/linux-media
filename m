Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36399 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1JOKHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 06:07:52 -0400
Date: Sat, 15 Oct 2011 13:07:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/1] ARM: EXYNOS4: JPEG: driver initial release
Message-ID: <20111015100747.GI10001@valkosipuli.localdomain>
References: <1318337492-21354-1-git-send-email-andrzej.p@samsung.com>
 <1318337492-21354-2-git-send-email-andrzej.p@samsung.com>
 <20111014224046.GH10001@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014224046.GH10001@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 15, 2011 at 01:40:46AM +0300, Sakari Ailus wrote:
> Hi Andrzej,
> 
> Thanks for the patch! Interesting to see a hardware jpeg encoder using V4L2!
> 
> I have a few comments below. As a whole, this driver looks quite good to me.
> 
> On Tue, Oct 11, 2011 at 02:51:32PM +0200, Andrzej Pietrasiewicz wrote:
...
> > +static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_fmt *formats,
> > +						 int n, struct v4l2_format *f)
> > +{
> > +	struct s5p_jpeg_fmt *fmt;
> > +	unsigned int k;
> > +	for (k = 0; k < n; k++) {
> 
> You can define fmt here.
> 
> > +		fmt = &formats[k];
> > +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> 
> If you're only interested in pixelformat then you should pass that to the
> function, not v4l2_format.

You could clean this up a lot if you just gave ctx->mode as the argument to
s5p_jpeg_find_format rather than the format table and it size: there are
only two alternatives for the table after all.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
