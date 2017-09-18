Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33111 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdIRTIk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 15:08:40 -0400
Date: Mon, 18 Sep 2017 14:08:38 -0500
From: Rob Herring <robh@kernel.org>
To: Leon Luo <leonl@leopardimaging.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        soren.brinkmann@xilinx.com
Subject: Re: [PATCH v5 1/2] media:imx274 device tree binding file
Message-ID: <20170918190838.bjgvwgdlmgzpvu5l@rob-hp-laptop>
References: <20170915074952.22148-1-leonl@leopardimaging.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170915074952.22148-1-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 15, 2017 at 03:49:51PM +0800, Leon Luo wrote:
> The binding file for imx274 CMOS sensor V4l2 driver
> 
> Signed-off-by: Leon Luo <leonl@leopardimaging.com>
> ---
> v5:
>  - add 'port' and 'endpoint' information
> v4:
>  - no changes
> v3:
>  - remove redundant properties and references
>  - document 'reg' property
> v2:
>  - no changes
> ---
>  .../devicetree/bindings/media/i2c/imx274.txt       | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt

Acked-by: Rob Herring <robh@kernel.org>
