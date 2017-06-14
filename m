Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9630 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751600AbdFNVqj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 17:46:39 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
CC: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH 07/12] intel-ipu3: css: firmware management
Date: Wed, 14 Jun 2017 21:46:33 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D0799F2DB@ORSMSX106.amr.corp.intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-8-git-send-email-yong.zhi@intel.com>
 <f065881d-1024-2e06-f2d4-382f3cbefbab@xs4all.nl>
In-Reply-To: <f065881d-1024-2e06-f2d4-382f3cbefbab@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> Sent: Tuesday, June 6, 2017 1:39 AM
> To: Zhi, Yong <yong.zhi@intel.com>; linux-media@vger.kernel.org;
> sakari.ailus@linux.intel.com
> Cc: Zheng, Jian Xu <jian.xu.zheng@intel.com>; tfiga@chromium.org; Mani,
> Rajmohan <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>
> Subject: Re: [PATCH 07/12] intel-ipu3: css: firmware management
> 
> On 05/06/17 22:39, Yong Zhi wrote:
> > Functions to load and install imgu FW blobs
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-abi.h    | 1572
> ++++++++++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3-css-fw.c |  272 +++++
> > drivers/media/pci/intel/ipu3/ipu3-css-fw.h |  215 ++++
> >  drivers/media/pci/intel/ipu3/ipu3-css.h    |   54 +
> >  4 files changed, 2113 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h
> 
> Has this been tested for both i686 and x86_64 modes?
> 
> Regards,
> 
> 	Hans

Sorry for the late response, the above code has been tested for x86_64 mode only.
