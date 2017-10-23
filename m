Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:33528 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdJWVYw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 17:24:52 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Date: Mon, 23 Oct 2017 21:24:50 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2BC75@ORSMSX106.amr.corp.intel.com>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
 <20171020090949.nhv74sfb5jjrtxhx@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171020090949.nhv74sfb5jjrtxhx@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, October 20, 2017 2:10 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> arnd@arndb.de; hch@lst.de; robin.murphy@arm.com; iommu@lists.linux-
> foundation.org
> Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
> 
> Hi Yong,
> 
> On Tue, Oct 17, 2017 at 10:46:48PM -0500, Yong Zhi wrote:
> > This patchset adds support for the Intel IPU3 (Image Processing Unit)
> > ImgU which is essentially a modern memory-to-memory ISP. It implements
> > raw Bayer to YUV image format conversion as well as a large number of
> > other pixel processing algorithms for improving the image quality.
> >
> > Meta data formats are defined for image statistics (3A, i.e. automatic
> > white balance, exposure and focus, histogram and local area contrast
> > enhancement) as well as for the pixel processing algorithm parameters.
> > The documentation for these formats is currently not included in the
> > patchset but will be added in a future version of this set.
> >
> > The algorithm parameters need to be considered specific to a given
> > frame and typically a large number of these parameters change on frame
> > to frame basis. Additionally, the parameters are highly structured
> > (and not a flat space of independent configuration primitives). They
> > also reflect the data structures used by the firmware and the
> > hardware. On top of that, the algorithms require highly specialized
> > user space to make meaningful use of them. For these reasons it has
> > been chosen video buffers to pass
> 
> Do you have a to-do list for this patchset? I think it would be useful to
> maintain one, in case not all the comments have been addressed.
> 

Sure, will add in next update.

> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
