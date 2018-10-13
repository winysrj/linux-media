Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33922 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725734AbeJNEkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Oct 2018 00:40:21 -0400
Date: Sun, 14 Oct 2018 00:01:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: Bing Bu Cao <bingbu.cao@linux.intel.com>,
        "kieran.bingham+renesas@ideasonboard.com"
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: Re: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
Message-ID: <20181013210148.pulqs6vhfuea4q6h@valkosipuli.retiisi.org.uk>
References: <20181009234245.25830-1-rajmohan.mani@intel.com>
 <33c53caf-633a-f359-4312-9c2dc317efc5@ideasonboard.com>
 <39c26dd4-4454-f557-f510-ae973f5d9c89@linux.intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A5981515F2D@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5981515F2D@fmsmsx122.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2018 at 07:00:44PM +0000, Mani, Rajmohan wrote:
> Hi Bingbu, Kieren,
> 
> > Subject: Re: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
> > 
> > 
> > 
> > On 10/11/2018 05:33 PM, Kieran Bingham wrote:
> > > Hi Rajmohan
> > >
> > > Thank you for the patch,
> > >
> > > On 10/10/18 00:42, Rajmohan Mani wrote:
> > >> Removed redundant CIO2_IMAGE_MAX_* definitions
> > >>
> > >> Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2
> > >> driver")
> > >>
> > >> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> > > Reviewed-by: Kieran Bingham
> > <kieran.bingham+renesas@ideasonboard.com>
> > >
> > > Looks like this {sh,c}ould be bundled in with  "[PATCH 0/2] Trivial
> > > CIO2 patches" from Sakari at integration.
> > Raj and Sakari, I think this change could be bundled into the Trivial patch sets,
> > what do you think?
> > >
> 
> Sounds good to me.
> I will leave this up to Sakari.

Yes, these are all in my branch for 4.21.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
