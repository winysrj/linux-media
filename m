Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34652 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdFFIip (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 04:38:45 -0400
Subject: Re: [PATCH 07/12] intel-ipu3: css: firmware management
To: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-8-git-send-email-yong.zhi@intel.com>
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f065881d-1024-2e06-f2d4-382f3cbefbab@xs4all.nl>
Date: Tue, 6 Jun 2017 10:38:32 +0200
MIME-Version: 1.0
In-Reply-To: <1496695157-19926-8-git-send-email-yong.zhi@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/17 22:39, Yong Zhi wrote:
> Functions to load and install imgu FW blobs
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-abi.h    | 1572 ++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.c |  272 +++++
>  drivers/media/pci/intel/ipu3/ipu3-css-fw.h |  215 ++++
>  drivers/media/pci/intel/ipu3/ipu3-css.h    |   54 +
>  4 files changed, 2113 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-abi.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-fw.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css.h

Has this been tested for both i686 and x86_64 modes?

Regards,

	Hans
