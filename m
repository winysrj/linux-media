Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49512 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754030AbdECUf7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 16:35:59 -0400
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4a486cd9-48f8-fcab-6abb-4e89671c95fe@xs4all.nl>
Date: Wed, 3 May 2017 22:35:50 +0200
MIME-Version: 1.0
In-Reply-To: <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2017 01:34 AM, Yong Zhi wrote:
> This patch adds CIO2 CSI-2 device driver for
> Intel's IPU3 camera sub-system support.
> 
> The V4L2 fwnode matching depends on the following work:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/Kconfig          |    2 +
>  drivers/media/pci/Makefile         |    3 +-
>  drivers/media/pci/ipu3/Kconfig     |   17 +
>  drivers/media/pci/ipu3/Makefile    |    1 +
>  drivers/media/pci/ipu3/ipu3-cio2.c | 1813 ++++++++++++++++++++++++++++++++++++
>  drivers/media/pci/ipu3/ipu3-cio2.h |  425 +++++++++
>  6 files changed, 2260 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/ipu3/Kconfig
>  create mode 100644 drivers/media/pci/ipu3/Makefile
>  create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.c
>  create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.h

Not a review (yet), just something I noticed: I would recommend calling
the directory intel-ipu3. The ipu3 name is a bit obscure.

Is it likely that there will be more Intel PCI drivers? If so, then we
can consider putting it in pci/intel/ipu3/.

Also, can you post as a reply to the cover letter of this patch series the
output of 'v4l2-compliance' and 'v4l2-compliance -f'. Make sure you use the
latest v4l2-compliance code from the master branch of the v4l-utils repository
(https://git.linuxtv.org/v4l-utils.git/).

Regards,

	Hans
