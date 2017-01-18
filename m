Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36139 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdARWX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 17:23:28 -0500
Date: Wed, 18 Jan 2017 16:23:21 -0600
From: Rob Herring <robh@kernel.org>
To: sean.wang@mediatek.com
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, matthias.bgg@gmail.com,
        andi.shyti@samsung.com, hverkuil@xs4all.nl, sean@mess.org,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH v3 2/3] Documentation: devicetree: Add document bindings
 for mtk-cir
Message-ID: <20170118222321.ec6p7oqwwqfiofhp@rob-hp-laptop>
References: <1484292939-9454-1-git-send-email-sean.wang@mediatek.com>
 <1484292939-9454-3-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484292939-9454-3-git-send-email-sean.wang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 13, 2017 at 03:35:38PM +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> This patch adds documentation for devicetree bindings for
> consumer Mediatek IR controller.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
>  .../devicetree/bindings/media/mtk-cir.txt          | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mtk-cir.txt

Acked-by: Rob Herring <robh@kernel.org>
