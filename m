Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:7196 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbeA3Mp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 07:45:28 -0500
Date: Tue, 30 Jan 2018 14:45:23 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v1] media: ov13858: Avoid possible null first frame
Message-ID: <20180130124523.m5sikm3gvrktcnuh@kekkonen.localdomain>
References: <1516854879-15029-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <20180125102958.dxky4qrzv5ags6av@paasikivi.fi.intel.com>
 <8408A4B5C50F354EA5F62D9FC805153D2C53637E@ORSMSX115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8408A4B5C50F354EA5F62D9FC805153D2C53637E@ORSMSX115.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 25, 2018 at 05:36:44PM +0000, Rapolu, Chiranjeevi wrote:
> Hi Sakari,
> 
> >I'll apply this now, however I see that most of the registers in the
> > four modes are the same. In the future it'd be good to separate the
> > parts that are common in all of them (to be written in sensor power-on)
> > to make this (slightly) more maintainable.
> 
> Thanks for the review. Makes sense. Not sure how it impacts because the
> sequence of writes will be different, need thorough testing to confirm
> nothing is broken.

Yeah, that's a fair consideration. Most registers still have no side
effects apart of streaming control or such.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
