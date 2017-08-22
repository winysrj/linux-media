Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33940 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754050AbdHVCYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 22:24:24 -0400
Date: Mon, 21 Aug 2017 21:24:23 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        rajmohan.mani@intel.com
Subject: Re: [PATCH 1/3] dt-bindings: Add bindings for Dongwoon DW9714 voice
 coil
Message-ID: <20170822022423.dardux2ok3sisdxd@rob-hp-laptop>
References: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
 <1502977376-22836-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502977376-22836-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 17, 2017 at 04:42:54PM +0300, Sakari Ailus wrote:
> Dongwoon DW9714 is a voice coil lens driver.
> 
> Also add a vendor prefix for Dongwoon for one did not exist previously.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt | 9 +++++++++
>  Documentation/devicetree/bindings/vendor-prefixes.txt           | 1 +
>  2 files changed, 10 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt

Acked-by: Rob Herring <robh@kernel.org>
