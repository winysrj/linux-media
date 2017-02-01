Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33216 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbdBARrd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 12:47:33 -0500
Date: Wed, 1 Feb 2017 11:47:26 -0600
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-amlogic@lists.infradead.org, khilman@baylibre.com,
        carlo@caione.org, mchehab@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, mark.rutland@arm.com,
        narmstrong@baylibre.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation: devicetree: meson-ir: "linux,rc-map-name"
 is supported
Message-ID: <20170201174726.2vyvxpnie7qclrvk@rob-hp-laptop>
References: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131212112.5582-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 10:21:12PM +0100, Martin Blumenstingl wrote:
> The driver already parses the "linux,rc-map-name" property. Add this
> information to the documentation so .dts maintainers don't have to look
> it up in the source-code.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  Documentation/devicetree/bindings/media/meson-ir.txt | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
