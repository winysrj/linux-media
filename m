Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:37436 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932637AbeEaDVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:21:44 -0400
Date: Wed, 30 May 2018 22:21:42 -0500
From: Rob Herring <robh@kernel.org>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, tian.shu.qiu@intel.com,
        rajmohan.mani@intel.com, tfiga@chromium.org
Subject: Re: [RESEND PATCH V2 1/2] dt-bindings: Add bindings for AKM ak7375
 voice coil lens
Message-ID: <20180531032142.GA12586@rob-hp-laptop>
References: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 05:55:34PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Add device tree bindings for AKM ak7375 voice coil lens
> driver. This chip is used to drive a lens in a camera module.
> 
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
> Changes since v1:
>  - remove the vendor prefix change
> ---
>  Documentation/devicetree/bindings/media/i2c/ak7375.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ak7375.txt

Reviewed-by: Rob Herring <robh@kernel.org>
