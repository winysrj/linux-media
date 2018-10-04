Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28054 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbeJDOAl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 10:00:41 -0400
Date: Thu, 4 Oct 2018 10:08:41 +0300
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Li, Chao C" <chao.c.li@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: Re: [PATCH v1 2/2] v4l: Document Intel IPU3 meta data uAPI
Message-ID: <20181004070841.cxfjsc5d5ul6l7pe@paasikivi.fi.intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
 <1529033373-15724-3-git-send-email-yong.zhi@intel.com>
 <749a58a4-24f7-672f-70a9-cfd584af0171@xs4all.nl>
 <20180813174950.6fd3915f@coco.lan>
 <6F87890CF0F5204F892DEA1EF0D77A5981514022@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5981514022@fmsmsx122.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj,

On Wed, Oct 03, 2018 at 10:56:19PM +0000, Mani, Rajmohan wrote:
...
> > From some comment you had later,
> > I guess you're meaning that only 3 or 7 are the valid values.
> > 
> > Yet, you're listing from 2^3 to 2^7, and that's confusing. Perhaps
> > you want to say, instead, that the valid values are at the 3..7 range?
> > If so, please use something like "values at the [3..7] range".
> > 
> 
> As Sakari pointed / preferred in the other thread, we will use the format
> [3, 7] to represent all integers between 3 and 7, including 3 and 7.

Feel free to add a reference to this in the format documentation:

<URL:https://en.wikipedia.org/wiki/Interval_(mathematics)>

I guess the right place would be the top parameter format ReST document.

...

> > > > + * All above has precision u0.4, range [0..0xF].
> > 
> > again, what do you mean by u0.4? 
> 
> unsigned integer with 0 bits used for representing whole number,
> with 4 least significant bits used to represent the fractional part.

You could refer to this:

<URL:https://en.wikipedia.org/wiki/Q_(number_format)>

The ux.y notation is more common in the context of software but I couldn't
find any decent document to refer to.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
