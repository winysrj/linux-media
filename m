Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55474 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752279AbdJTJJx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 05:09:53 -0400
Date: Fri, 20 Oct 2017 12:09:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com, arnd@arndb.de,
        hch@lst.de, robin.murphy@arm.com, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Message-ID: <20171020090949.nhv74sfb5jjrtxhx@valkosipuli.retiisi.org.uk>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Tue, Oct 17, 2017 at 10:46:48PM -0500, Yong Zhi wrote:
> This patchset adds support for the Intel IPU3 (Image Processing Unit)
> ImgU which is essentially a modern memory-to-memory ISP. It implements
> raw Bayer to YUV image format conversion as well as a large number of
> other pixel processing algorithms for improving the image quality.
> 
> Meta data formats are defined for image statistics (3A, i.e. automatic
> white balance, exposure and focus, histogram and local area contrast
> enhancement) as well as for the pixel processing algorithm parameters.
> The documentation for these formats is currently not included in the
> patchset but will be added in a future version of this set.
> 
> The algorithm parameters need to be considered specific to a given frame
> and typically a large number of these parameters change on frame to frame
> basis. Additionally, the parameters are highly structured (and not a flat
> space of independent configuration primitives). They also reflect the
> data structures used by the firmware and the hardware. On top of that,
> the algorithms require highly specialized user space to make meaningful
> use of them. For these reasons it has been chosen video buffers to pass

Do you have a to-do list for this patchset? I think it would be useful to
maintain one, in case not all the comments have been addressed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
