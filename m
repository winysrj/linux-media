Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20377 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbeKFPOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 10:14:25 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v7 06/16] intel-ipu3: mmu: Implement driver
Date: Tue, 6 Nov 2018 05:50:53 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB2F0EB@ORSMSX106.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-7-git-send-email-yong.zhi@intel.com>
 <20181105115525.fuwuxnsyzsvl5oj7@kekkonen.localdomain>
In-Reply-To: <20181105115525.fuwuxnsyzsvl5oj7@kekkonen.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Thanks for the feedback.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Monday, November 5, 2018 3:55 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> mchehab@kernel.org; hans.verkuil@cisco.com;
> laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v7 06/16] intel-ipu3: mmu: Implement driver
> 
> Hi Yong,
> 
> On Mon, Oct 29, 2018 at 03:23:00PM -0700, Yong Zhi wrote:
> > From: Tomasz Figa <tfiga@chromium.org>
> >
> > This driver translates IO virtual address to physical address based on
> > two levels page tables.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> 
> ...
> 
> > +static void call_if_ipu3_is_powered(struct ipu3_mmu *mmu,
> > +				    void (*func)(struct ipu3_mmu *mmu)) {
> > +	pm_runtime_get_noresume(mmu->dev);
> > +	if (pm_runtime_active(mmu->dev))
> > +		func(mmu);
> > +	pm_runtime_put(mmu->dev);
> 
> How about:
> 
> 	if (!pm_runtime_get_if_in_use(mmu->dev))
> 		return;
> 
> 	func(mmu);
> 	pm_runtime_put(mmu->dev);
> 

Ack, unless Tomasz has different opinion.

> 
> > +}
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
