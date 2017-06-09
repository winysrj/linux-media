Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59488 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751601AbdFIJnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 05:43:35 -0400
Date: Fri, 9 Jun 2017 12:43:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: Re: [PATCH 05/12] intel-ipu3: css: tables
Message-ID: <20170609094303.GN1019@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-6-git-send-email-yong.zhi@intel.com>
 <CAAFQd5BH-MwPBdsJEmz1-fF3W0rQ5HwSbHWuu24RSeP7EjhR5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BH-MwPBdsJEmz1-fF3W0rQ5HwSbHWuu24RSeP7EjhR5Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 08, 2017 at 05:29:48PM +0900, Tomasz Figa wrote:
> Hi Yong,
> 
> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> > Coeff, config parameters etc const definitions for
> > IPU3 programming.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-tables.c | 9621 ++++++++++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3-tables.h |   82 +
> >  2 files changed, 9703 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-tables.h
> 
> I wonder if this patch really reached the mailing list. It seems to
> not be present on patchwork.linuxtv.org. Possibly due to size
> restrictions.

Thanks for pointing this out.

I'm pushing the CIO2 and ImgU driver patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ipu3>

It'll take some time still to get there...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
