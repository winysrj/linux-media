Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34481 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbeATAcU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 19:32:20 -0500
Date: Fri, 19 Jan 2018 18:32:18 -0600
From: Rob Herring <robh@kernel.org>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v6 1/4] dt-bindings: media: Add bindings for OV5695
Message-ID: <20180120003218.rstk2bwqh43vaxfi@rob-hp-laptop>
References: <1516094521-22708-1-git-send-email-zhengsq@rock-chips.com>
 <1516094521-22708-2-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516094521-22708-2-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 05:21:58PM +0800, Shunqian Zheng wrote:
> Add device tree binding documentation for the OV5695 sensor.
> 
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/media/i2c/ov5695.txt       | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt

Reviewed-by: Rob Herring <robh@kernel.org>
