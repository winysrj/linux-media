Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38823 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdKURV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 12:21:57 -0500
Date: Tue, 21 Nov 2017 19:21:54 +0200
From: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Subject: Re: [PATCH v4 04/12] intel-ipu3: Add user space ABI definitions
Message-ID: <20171121172154.h6bzixu4phmqiria@paasikivi.fi.intel.com>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <20171020093020.jo2vktc62sx52w4v@valkosipuli.retiisi.org.uk>
 <6F87890CF0F5204F892DEA1EF0D77A5972FD24A5@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5972FD24A5@FMSMSX114.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rajmohan,

My apologies for the late reply.

On Sat, Nov 11, 2017 at 04:07:22AM +0000, Mani, Rajmohan wrote:
> Hi Sakari,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: Friday, October 20, 2017 2:30 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu
> > <jian.xu.zheng@intel.com>; Mani, Rajmohan <rajmohan.mani@intel.com>;
> > Toivonen, Tuukka <tuukka.toivonen@intel.com>; Hu, Jerry W
> > <jerry.w.hu@intel.com>
> > Subject: Re: [PATCH v4 04/12] intel-ipu3: Add user space ABI definitions
> > 
> > Hi Yong,
> > 
> > On Tue, Oct 17, 2017 at 10:54:49PM -0500, Yong Zhi wrote:

...

> > > +struct ipu3_uapi_params {
> > > +	__u32 fourcc;			/* V4L2_PIX_FMT_IPU3_PARAMS */
> > > +	__u32 version;			/* Must be 0x100 */
> > 
> > These were called padding1 and padding2 in the previous version. What
> > happened?
> > 
> > I'd just call them reserved, and maybe also make the use field the first
> > member of the struct.
> > 
> 
> These fields were repurposed after v3 of this patch series. Please see the user space code that uses these fields.
> https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master/hal/intel/psl/ipu3/workers/IPU3AicToFwEncoder.cpp

They were fourcc and version in the beginning, and then replaced by
padding1 and padding 2. Is there a particular reason for changing them
back?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
