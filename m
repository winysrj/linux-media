Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34259 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdARWXE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 17:23:04 -0500
Date: Wed, 18 Jan 2017 16:22:38 -0600
From: Rob Herring <robh@kernel.org>
To: sean.wang@mediatek.com
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, matthias.bgg@gmail.com,
        andi.shyti@samsung.com, hverkuil@xs4all.nl, sean@mess.org,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH v3 1/3] Documentation: devicetree: move shared property
 used by rc into a common place
Message-ID: <20170118222238.7iqt7joopu45dq46@rob-hp-laptop>
References: <1484292939-9454-1-git-send-email-sean.wang@mediatek.com>
 <1484292939-9454-2-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484292939-9454-2-git-send-email-sean.wang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 13, 2017 at 03:35:37PM +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> Most IR drivers uses the same label to identify the
> scancdoe/key table they used by multiple bindings and lack
> explanation well. So move the shared property into a common
> place and give better explanation.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
>  .../devicetree/bindings/media/gpio-ir-receiver.txt |   3 +-
>  .../devicetree/bindings/media/hix5hd2-ir.txt       |   2 +-
>  Documentation/devicetree/bindings/media/rc.txt     | 116 +++++++++++++++++++++
>  .../devicetree/bindings/media/sunxi-ir.txt         |   2 +-
>  4 files changed, 120 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/rc.txt

Acked-by: Rob Herring <robh@kernel.org>

Thanks for doing this.

Rob
