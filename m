Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:36451 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbeIYQ6z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:58:55 -0400
Date: Tue, 25 Sep 2018 13:51:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "rajmohan.mani@intel.com" <rajmohan.mani@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "ricardo.ribalda@gmail.com" <ricardo.ribalda@gmail.com>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "snawrocki@kernel.org" <snawrocki@kernel.org>
Subject: Re: [PATCH 3/5] Documentation: media: Document control exponential
 bases, units, prefixes
Message-ID: <20180925105145.iypzuk2wt67kbva4@paasikivi.fi.intel.com>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-4-sakari.ailus@linux.intel.com>
 <20180925103956.ubo5ntdxvqdecgbv@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925103956.ubo5ntdxvqdecgbv@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 25, 2018 at 12:39:56PM +0200, Helmut Grohne wrote:
> On Tue, Sep 25, 2018 at 12:14:32PM +0200, Sakari Ailus wrote:
> > +    * - ``V4L2_CTRL_UNIT_PIXEL``
> > +      - 5
> > +      - A pixel in sensor's pixel matrix. This is a unit of time commonly used
> > +        by camera sensors in e.g. exposure control, i.e. the time it takes for
> > +	a sensor to read a pixel from the sensor's pixel matrix.
> > +
> > +    * - ``V4L2_CTRL_UNIT_PIXEL``
> > +      - 6
> 
> The latter V4L2_CTRL_UNIT_PIXEL looks like a typo that should say
> V4L2_CTRL_UNIT_PIXELS_PER_SEC.

Correct. I'll fix this for v2.

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
