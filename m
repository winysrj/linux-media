Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51043 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752049AbdHINAc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 09:00:32 -0400
Date: Wed, 9 Aug 2017 14:00:29 +0100
From: Sean Young <sean@mess.org>
To: Shawn Guo <shawnguo@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 3/3] rc: add zx-irdec remote control driver
Message-ID: <20170809130029.eneyqstlejfkotz2@gofer.mess.org>
References: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
 <1501420993-21977-4-git-send-email-shawnguo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501420993-21977-4-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 30, 2017 at 09:23:13PM +0800, Shawn Guo wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> It adds the remote control driver and corresponding keymap file for
> IRDEC block found on ZTE ZX family SoCs.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/media/rc/Kconfig               |  11 ++
>  drivers/media/rc/Makefile              |   1 +
>  drivers/media/rc/keymaps/Makefile      |   3 +-
>  drivers/media/rc/keymaps/rc-zx-irdec.c |  79 ++++++++++++++
>  drivers/media/rc/zx-irdec.c            | 183 +++++++++++++++++++++++++++++++++
>  include/media/rc-map.h                 |   1 +
>  6 files changed, 277 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/rc/keymaps/rc-zx-irdec.c
>  create mode 100644 drivers/media/rc/zx-irdec.c

We're missing an MAINTAINERS entry for this driver. Could this be added
please as a separate patch?

Thanks
Sean
