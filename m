Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:42639 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbeATAdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 19:33:10 -0500
Date: Fri, 19 Jan 2018 18:33:08 -0600
From: Rob Herring <robh@kernel.org>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v6 3/4] dt-bindings: media: Add bindings for OV2685
Message-ID: <20180120003308.bnnndccn4l3ew7mr@rob-hp-laptop>
References: <1516094521-22708-1-git-send-email-zhengsq@rock-chips.com>
 <1516094521-22708-4-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516094521-22708-4-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 05:22:00PM +0800, Shunqian Zheng wrote:
> Add device tree binding documentation for the OV2685 sensor.
> 
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/media/i2c/ov2685.txt       | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt

Reviewed-by: Rob Herring <robh@kernel.org>
