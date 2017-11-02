Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51652 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750836AbdKBIn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 04:43:26 -0400
Date: Thu, 2 Nov 2017 10:43:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Subject: Re: [PATCH v4 11/12] intel-ipu3: Add imgu v4l2 driver
Message-ID: <20171102084323.lbgz4nyr6ld3csv4@valkosipuli.retiisi.org.uk>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <1508298896-26096-8-git-send-email-yong.zhi@intel.com>
 <20171020112940.2ptehi2ejl5mhjez@valkosipuli.retiisi.org.uk>
 <C193D76D23A22742993887E6D207B54D1AE2BFC9@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D1AE2BFC9@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 23, 2017 at 10:41:57PM +0000, Zhi, Yong wrote:
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int ipu3_try_fmt(struct file *file, void *fh, struct
> > > +v4l2_format *f) {
> > > +	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
> > > +	const struct ipu3_fmt *fmt;
> > > +
> > > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > > +		fmt = find_format(f, M2M_CAPTURE);
> > > +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > > +		fmt = find_format(f, M2M_OUTPUT);
> > > +	else
> > > +		return -EINVAL;
> > > +
> > > +	pixm->pixelformat = fmt->fourcc;
> > > +
> > > +	memset(pixm->plane_fmt[0].reserved, 0,
> > > +	       sizeof(pixm->plane_fmt[0].reserved));
> > 
> > No need for the memset here, the framework handles this.
> > 
> > Are there limits on the image size?
> > 
> 
> The memset is added to fix v4l2-compliance failure here.

Oops. Indeed, this is about the plane format. Please ignore the comment.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
