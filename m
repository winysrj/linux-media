Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36457 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbdFFIHs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 04:07:48 -0400
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
To: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-3-git-send-email-yong.zhi@intel.com>
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8aa29682-4d09-6c4f-f867-9b135ddacb57@xs4all.nl>
Date: Tue, 6 Jun 2017 10:07:45 +0200
MIME-Version: 1.0
In-Reply-To: <1496695157-19926-3-git-send-email-yong.zhi@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/17 22:39, Yong Zhi wrote:
> From: Tuukka Toivonen <tuukka.toivonen@intel.com>
> 
> This driver translates Intel IPU3 internal virtual
> address to physical address.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/Kconfig    |  11 +
>  drivers/media/pci/intel/ipu3/Makefile   |   1 +
>  drivers/media/pci/intel/ipu3/ipu3-mmu.c | 423 ++++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-mmu.h |  73 ++++++
>  4 files changed, 508 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
> 

Why is this patch and the next patch (03/12) in drivers/media? I wonder
what the reasoning is behind that since it doesn't seem very media
specific.

Regards,

	Hans
