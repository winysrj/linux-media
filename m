Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32905 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbdHJPnn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 11:43:43 -0400
Date: Thu, 10 Aug 2017 10:43:40 -0500
From: Rob Herring <robh@kernel.org>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Yakir Yang <ykk@rock-chips.com>
Subject: Re: [PATCH v5 6/6] dt-bindings: Document the Rockchip RGA bindings
Message-ID: <20170810154340.3ojgemwf64pyggek@rob-hp-laptop>
References: <1501643987-27847-1-git-send-email-jacob-chen@iotwrt.com>
 <1501643987-27847-7-git-send-email-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501643987-27847-7-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 02, 2017 at 11:19:47AM +0800, Jacob Chen wrote:
> Add DT bindings documentation for Rockchip RGA
> 
> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> Signed-off-by: Yakir Yang <ykk@rock-chips.com>
> ---
>  .../devicetree/bindings/media/rockchip-rga.txt     | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt

Acked-by: Rob Herring <robh@kernel.org>
