Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51848 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753710AbeDZGlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:41:17 -0400
Date: Thu, 26 Apr 2018 09:41:14 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Subject: Re: [PATCH v6 07/12] intel-ipu3: css: Add static settings for image
 pipeline
Message-ID: <20180426064113.raek5lh6lkfvpiix@paasikivi.fi.intel.com>
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-8-git-send-email-yong.zhi@intel.com>
 <CAAFQd5DL06QZc+fkN1uqcUNWjTf-miK_Do6cCybusdkm6pZqmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DL06QZc+fkN1uqcUNWjTf-miK_Do6cCybusdkm6pZqmg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 09:11:53AM +0000, Tomasz Figa wrote:
> Hi Yong,
> 
> On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
> 
> > This adds coeff, config parameters etc const definitions for
> > IPU3 programming.
> 
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >   drivers/media/pci/intel/ipu3/ipu3-tables.c | 9609
> ++++++++++++++++++++++++++++
> >   drivers/media/pci/intel/ipu3/ipu3-tables.h |   66 +
> >   2 files changed, 9675 insertions(+)
> >   create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
> >   create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h
> 
> I believe none of the 6 revisions of this patch actually reached the
> mailing lists. It's too big. Could we do something about it? Splitting into
> smaller patches might help, but we should provide a link in cover letter to
> a public git branch where the whole series can be found applied to current
> Linux.

Well spotted. I've applied the patches on media tree master here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ipu3-imgu>

The missing patch itself is here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=ipu3-imgu&id=1dc137803f4afaed8170fc2ee6f0da3d04c5e0f1>

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
