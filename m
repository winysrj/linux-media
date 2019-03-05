Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA48C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 07:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09C882082C
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 07:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfCEHxY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 02:53:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:44398 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfCEHxY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 02:53:24 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 23:53:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,443,1544515200"; 
   d="scan'208";a="304463482"
Received: from schmiger-mobl3.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.12])
  by orsmga005.jf.intel.com with ESMTP; 04 Mar 2019 23:53:20 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id C30A321E9B; Tue,  5 Mar 2019 09:53:18 +0200 (EET)
Date:   Tue, 5 Mar 2019 09:53:18 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     "Cao, Bingbu" <bingbu.cao@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
Message-ID: <20190305075317.4t32uyyhzftuoebp@kekkonen.localdomain>
References: <20190304202758.1802417-1-arnd@arndb.de>
 <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bingbu, Arnd,

On Tue, Mar 05, 2019 at 12:25:18AM +0000, Cao, Bingbu wrote:
...
> > @@ -1744,7 +1745,7 @@ int imgu_css_fmt_try(struct imgu_css *css,
> >  	struct v4l2_rect *const bds = &r[IPU3_CSS_RECT_BDS];
> >  	struct v4l2_rect *const env = &r[IPU3_CSS_RECT_ENVELOPE];
> >  	struct v4l2_rect *const gdc = &r[IPU3_CSS_RECT_GDC];
> > -	struct imgu_css_queue q[IPU3_CSS_QUEUES];
> > +	struct imgu_css_queue *q = kcalloc(IPU3_CSS_QUEUES, sizeof(struct
> > +imgu_css_queue), GFP_KERNEL);
> 
> Could you use the devm_kcalloc()? 

No, because this is not related to the device, called instead on
e.g. VIDIOC_TRY_FMT.

> >  	struct v4l2_pix_format_mplane *const in =
> >  					&q[IPU3_CSS_QUEUE_IN].fmt.mpix;
> >  	struct v4l2_pix_format_mplane *const out = @@ -1753,6 +1754,11 @@
> > int imgu_css_fmt_try(struct imgu_css *css,
> >  					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
> >  	int i, s, ret;
> > 
> > +	if (!q) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> [Cao, Bingbu] 
> The goto here is wrong, you can just report an error, and I prefer it is next to the alloc.

I agree, the goto is just not needed.

> > +
> >  	/* Adjust all formats, get statistics buffer sizes and formats */
> >  	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
> >  		if (fmts[i])
> > @@ -1766,7 +1772,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
> >  					IPU3_CSS_QUEUE_TO_FLAGS(i))) {
> >  			dev_notice(css->dev, "can not initialize queue %s\n",
> >  				   qnames[i]);
> > -			return -EINVAL;
> > +			ret = -EINVAL;
> > +			goto out;
> >  		}
> >  	}
> >  	for (i = 0; i < IPU3_CSS_RECTS; i++) { @@ -1788,7 +1795,8 @@ int
> > imgu_css_fmt_try(struct imgu_css *css,
> >  	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
> >  	    !imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
> >  		dev_warn(css->dev, "required queues are disabled\n");
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto out;
> >  	}
> > 
> >  	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) { @@ -1829,7
> > +1837,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
> >  	ret = imgu_css_find_binary(css, pipe, q, r);
> >  	if (ret < 0) {
> >  		dev_err(css->dev, "failed to find suitable binary\n");
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto out;
> >  	}
> >  	css->pipes[pipe].bindex = ret;
> > 
> > @@ -1843,7 +1852,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
> >  						IPU3_CSS_QUEUE_TO_FLAGS(i))) {
> >  				dev_err(css->dev,
> >  					"final resolution adjustment failed\n");
> > -				return -EINVAL;
> > +				ret = -EINVAL;
> > +				goto out;
> >  			}
> >  			*fmts[i] = q[i].fmt.mpix;
> >  		}
> > @@ -1859,7 +1869,10 @@ int imgu_css_fmt_try(struct imgu_css *css,
> >  		 bds->width, bds->height, gdc->width, gdc->height,
> >  		 out->width, out->height, vf->width, vf->height);
> > 
> > -	return 0;
> > +	ret = 0;
> > +out:
> > +	kfree(q);
> > +	return ret;
> >  }
> > 
> >  int imgu_css_fmt_set(struct imgu_css *css,

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
