Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:37573 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbeHVLqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 07:46:22 -0400
Date: Wed, 22 Aug 2018 11:22:28 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Yong Zhi <yong.zhi@intel.com>,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com, chao.c.li@intel.com,
        tian.shu.qiu@intel.com
Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Message-ID: <20180822082228.mqwv34et7z53d2lw@paasikivi.fi.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <20180813174950.6fd3915f@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813174950.6fd3915f@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Aug 13, 2018 at 05:50:00PM -0300, Mauro Carvalho Chehab wrote:
...
> > > +
> > > +/******************* ipu3_uapi_stats_3a *******************/
> > > +
> > > +#define IPU3_UAPI_MAX_STRIPES				2
> > > +#define IPU3_UAPI_MAX_BUBBLE_SIZE			10
> > > +
> > > +#define IPU3_UAPI_GRID_START_MASK			(BIT(12) - 1)
> > > +#define IPU3_UAPI_GRID_Y_START_EN			BIT(15)
> > > +
> > > +/* controls generation of meta_data (like FF enable/disable) */
> > > +#define IPU3_UAPI_AWB_RGBS_THR_B_EN			BIT(14)
> > > +#define IPU3_UAPI_AWB_RGBS_THR_B_INCL_SAT		BIT(15)
> > > +
> > > +/**
> > > + * struct ipu3_uapi_grid_config - Grid plane config
> > > + *
> > > + * @width:	Grid horizontal dimensions, in number of grid blocks(cells).
> > > + * @height:	Grid vertical dimensions, in number of grid cells.
> > > + * @block_width_log2:	Log2 of the width of each cell in pixels.
> > > + *			for (2^3, 2^4, 2^5, 2^6, 2^7), values [3, 7].
> 
> What are you meaning by [3, 7] here? From some comment you had later,
> I guess you're meaning that only 3 or 7 are the valid values.

This is a notation for a closed interval. Please see:

<URL:https://en.wikipedia.org/wiki/Interval_(mathematics)>

> 
> Yet, you're listing from 2^3 to 2^7, and that's confusing. Perhaps
> you want to say, instead, that the valid values are at the 3..7 range?
> If so, please use something like "values at the [3..7] range".

I'd prefer either 3..7 or [3, 7], but the latter is formal. Whether a range
is closed or (partially) open matters less with integers though.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
