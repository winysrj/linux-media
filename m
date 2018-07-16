Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39023 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbeGPQbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:31:18 -0400
Date: Mon, 16 Jul 2018 19:03:11 +0300
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: "Chen, Ping-chung" <ping-chung.chen@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: Re: [PATCH] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180716160311.4m4pehiwsm5krmgn@paasikivi.fi.intel.com>
References: <1531206936-31447-1-git-send-email-ping-chung.chen@intel.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D704217@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D704217@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2018 at 07:37:54AM +0000, Yeh, Andy wrote:
> Hi PC,
> 
> Thanks for the patch.
> 
> Cc in Grant, and Intel Jim/Jason
> 
> > -----Original Message-----
> > From: Chen, Ping-chung
> > Sent: Tuesday, July 10, 2018 3:16 PM
> > To: linux-media@vger.kernel.org
> > Cc: sakari.ailus@linux.intel.com; Yeh, Andy <andy.yeh@intel.com>;
> > tfiga@chromium.org; Chen, Ping-chung <ping-chung.chen@intel.com>
> > Subject: [PATCH] media: imx208: Add imx208 camera sensor driver
> > +};
> > +
> > +static int imx208_enum_mbus_code(struct v4l2_subdev *sd,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_mbus_code_enum *code) {
> > +	/* Only one bayer order(GRBG) is supported */
> > +	if (code->index > 0)
> > +		return -EINVAL;
> > +
> 
> There is no limitation on using GRBG bayer order now. You can refer to imx355 driver as well.

It seems the rest of the driver uses RGGB.

The enumeration should only contain what is possible using the current
flipping configuration.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
