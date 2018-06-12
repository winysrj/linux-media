Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33082 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934377AbeFLWL2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 18:11:28 -0400
Date: Tue, 12 Jun 2018 16:11:25 -0600
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: mchehab@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: media: i2c: Document MT9V111 bindings
Message-ID: <20180612221125.GA22846@rob-hp-laptop>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528730253-25135-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528730253-25135-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 11, 2018 at 05:17:32PM +0200, Jacopo Mondi wrote:
> Add documentation for Aptina MT9V111 image sensor.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../bindings/media/i2c/aptina,mt9v111.txt          | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt

Reviewed-by: Rob Herring <robh@kernel.org>
