Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33623 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753705AbdBARpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 12:45:41 -0500
Date: Wed, 1 Feb 2017 11:45:34 -0600
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: mchehab@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, mark.rutland@arm.com,
        sean.wang@mediatek.com, sean@mess.org
Subject: Re: [PATCH] Documentation: devicetree: add the RC map name of the
 geekbox remote
Message-ID: <20170201174534.l7xaoqinlrfw3eda@rob-hp-laptop>
References: <20170131211342.3297-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131211342.3297-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 10:13:42PM +0100, Martin Blumenstingl wrote:
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> The geekbox keymap was added while the documentation patch was not
> applied yet (and I wasn't aware of this pending patch). This ensures
> that the documentation is in sync with the actual keymaps.
> 
>  Documentation/devicetree/bindings/media/rc.txt | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Rob Herring <robh@kernel.org>
