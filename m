Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37684 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753234AbdFPJWG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 05:22:06 -0400
Date: Fri, 16 Jun 2017 12:21:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
Message-ID: <20170616092131.GM12407@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-3-git-send-email-yong.zhi@intel.com>
 <8aa29682-4d09-6c4f-f867-9b135ddacb57@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa29682-4d09-6c4f-f867-9b135ddacb57@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jun 06, 2017 at 10:07:45AM +0200, Hans Verkuil wrote:
> On 05/06/17 22:39, Yong Zhi wrote:
> > From: Tuukka Toivonen <tuukka.toivonen@intel.com>
> > 
> > This driver translates Intel IPU3 internal virtual
> > address to physical address.
> > 
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/Kconfig    |  11 +
> >  drivers/media/pci/intel/ipu3/Makefile   |   1 +
> >  drivers/media/pci/intel/ipu3/ipu3-mmu.c | 423 ++++++++++++++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3-mmu.h |  73 ++++++
> >  4 files changed, 508 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
> > 
> 
> Why is this patch and the next patch (03/12) in drivers/media? I wonder
> what the reasoning is behind that since it doesn't seem very media
> specific.

The MMU is specific to the IPU3 (and possibly to some other IPUs).

Device specific MMUs must be a rarity anyway, there doesn't seem to be any
under drivers/iommu either.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
