Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:17370 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbeJMCek (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 22:34:40 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "kieran.bingham+renesas@ideasonboard.com"
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
CC: "tfiga@chromium.org" <tfiga@chromium.org>
Subject: RE: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
Date: Fri, 12 Oct 2018 19:00:44 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5981515F2D@fmsmsx122.amr.corp.intel.com>
References: <20181009234245.25830-1-rajmohan.mani@intel.com>
 <33c53caf-633a-f359-4312-9c2dc317efc5@ideasonboard.com>
 <39c26dd4-4454-f557-f510-ae973f5d9c89@linux.intel.com>
In-Reply-To: <39c26dd4-4454-f557-f510-ae973f5d9c89@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu, Kieren,

> Subject: Re: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
> 
> 
> 
> On 10/11/2018 05:33 PM, Kieran Bingham wrote:
> > Hi Rajmohan
> >
> > Thank you for the patch,
> >
> > On 10/10/18 00:42, Rajmohan Mani wrote:
> >> Removed redundant CIO2_IMAGE_MAX_* definitions
> >>
> >> Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2
> >> driver")
> >>
> >> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > Reviewed-by: Kieran Bingham
> <kieran.bingham+renesas@ideasonboard.com>
> >
> > Looks like this {sh,c}ould be bundled in with  "[PATCH 0/2] Trivial
> > CIO2 patches" from Sakari at integration.
> Raj and Sakari, I think this change could be bundled into the Trivial patch sets,
> what do you think?
> >

Sounds good to me.
I will leave this up to Sakari.

Thanks
Raj
