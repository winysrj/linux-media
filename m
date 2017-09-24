Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33024 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752753AbdIXTjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 15:39:52 -0400
Date: Sun, 24 Sep 2017 14:39:49 -0500
From: Rob Herring <robh@kernel.org>
To: Leon Luo <leonl@leopardimaging.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        soren.brinkmann@xilinx.com
Subject: Re: [PATCH v6 1/2] media:imx274 device tree binding file
Message-ID: <20170924193949.el6gtsbxx5c3gd3v@rob-hp-laptop>
References: <20170924075329.9927-1-leonl@leopardimaging.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170924075329.9927-1-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 24, 2017 at 12:53:28AM -0700, Leon Luo wrote:
> The binding file for imx274 CMOS sensor V4l2 driver
> 
> Signed-off-by: Leon Luo <leonl@leopardimaging.com>
> ---
> v6:
>  - no changes
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

Please add acks when posting new versions.

Rob
