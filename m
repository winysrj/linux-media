Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39663 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755743AbdLTSo3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 13:44:29 -0500
Date: Wed, 20 Dec 2017 12:44:26 -0600
From: Rob Herring <robh@kernel.org>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 2/6] media: dt: bindings: Update binding documentation
 for sunxi IR controller
Message-ID: <20171220184426.ongfriuioq6weljh@rob-hp-laptop>
References: <20171219080747.4507-1-embed3d@gmail.com>
 <20171219080747.4507-3-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219080747.4507-3-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 09:07:43AM +0100, Philipp Rossak wrote:
> This patch updates documentation for Device-Tree bindings for sunxi IR
> controller and adds the new optional property for the base clock
> frequency.
> 
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/sunxi-ir.txt | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
