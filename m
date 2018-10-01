Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:29077 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbeJAQFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:05:03 -0400
Date: Mon, 1 Oct 2018 11:27:58 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
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
Subject: Re: [PATCH 2/5] v4l: controls: Add support for exponential bases,
 prefixes and units
Message-ID: <20181001092758.ionkxntgduvq2puv@laureti-dev>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-3-sakari.ailus@linux.intel.com>
 <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 28, 2018 at 04:00:17PM +0200, Hans Verkuil wrote:
> On 09/25/2018 12:14 PM, Sakari Ailus wrote:
> > +/* V4L2 control unit prefixes */
> > +#define V4L2_CTRL_PREFIX_NANO		-9
> > +#define V4L2_CTRL_PREFIX_MICRO		-6
> > +#define V4L2_CTRL_PREFIX_MILLI		-3
> > +#define V4L2_CTRL_PREFIX_1		0
> 
> I would prefer PREFIX_NONE, since there is no prefix in this case.
> 
> I assume this prefix is only valid if the unit is not UNDEFINED and not
> NONE?

Why should it? The prefix is concerned with rescaling a value prior to
presenting it to a user. Even a unitless quantity or a value of
undefined unit can be reasonably scaled. Displaying a unit and scaling
look like orthogonal concepts to me.

> Is 'base' also dependent on a valid unit? (it doesn't appear to be)

I'd argue it should not depend on a valid unit like the prefix.

Helmut
