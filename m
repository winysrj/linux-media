Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:32900 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbcKNRLK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 12:11:10 -0500
Date: Mon, 14 Nov 2016 11:11:08 -0600
From: Rob Herring <robh@kernel.org>
To: Rick Chang <rick.chang@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: mediatek: Add a binding for Mediatek
 JPEG Decoder
Message-ID: <20161114171108.vmihebue2pocm6jt@rob-hp-laptop>
References: <1478586880-3923-1-git-send-email-rick.chang@mediatek.com>
 <1478586880-3923-2-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478586880-3923-2-git-send-email-rick.chang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 08, 2016 at 02:34:38PM +0800, Rick Chang wrote:
> Add a DT binding documentation for Mediatek JPEG Decoder of
> MT2701 SoC.
> 
> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  .../bindings/media/mediatek-jpeg-decoder.txt       | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt

Acked-by: Rob Herring <robh@kernel.org>
