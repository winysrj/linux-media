Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36445 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdGJDvk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 23:51:40 -0400
Date: Sun, 9 Jul 2017 22:51:37 -0500
From: Rob Herring <robh@kernel.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: media: Add Amlogic Meson AO-CEC bindings
Message-ID: <20170710035137.nd76qgjes5pwbk7d@rob-hp-laptop>
References: <1499336870-24118-1-git-send-email-narmstrong@baylibre.com>
 <1499336870-24118-3-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499336870-24118-3-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 06, 2017 at 12:27:50PM +0200, Neil Armstrong wrote:
> The Amlogic SoCs embeds a standalone CEC Controller, this patch adds this
> device bindings.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  .../devicetree/bindings/media/meson-ao-cec.txt     | 28 ++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt

Acked-by: Rob Herring <robh@kernel.org>
