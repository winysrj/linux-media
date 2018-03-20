Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:65192 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbeCTLgi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 07:36:38 -0400
Date: Tue, 20 Mar 2018 13:36:35 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Andy Yeh <andy.yeh@intel.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, alanx.chiang@intel.com
Subject: Re: RESEND[PATCH v6 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180320113634.3tdtvrnbb6cqcnio@kekkonen.localdomain>
References: <1521219926-15329-1-git-send-email-andy.yeh@intel.com>
 <1521219926-15329-3-git-send-email-andy.yeh@intel.com>
 <20180320102817.GB5372@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320102817.GB5372@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Mar 20, 2018 at 11:28:17AM +0100, jacopo mondi wrote:
...
> > +static int dw9807_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> > +{
> > +	int rval;
> > +
> > +	rval = pm_runtime_get_sync(sd->dev);
> > +	if (rval < 0) {
> > +		pm_runtime_put_noidle(sd->dev);
> 
> If you fail to get pm context, no need to put it back (I presume)

pm_runtime_get() must be followed by pm_runtime_put() whether the former
succeeds or not.

...

> > +static const struct of_device_id dw9807_of_table[] = {
> > +	{ .compatible = "dongwoon,dw9807" },
> > +	{ { 0 } }
> 
> { } is enough.

{ } is GCC specific while { { 0 } } isn't.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
