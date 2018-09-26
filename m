Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34294 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeI0Cok (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 22:44:40 -0400
Date: Wed, 26 Sep 2018 15:29:57 -0500
From: Rob Herring <robh@kernel.org>
To: Maxime Jourdan <mjourdan@baylibre.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Jourdan <mjourdan@baylibre.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2 1/3] dt-bindings: media: add Amlogic Video Decoder
 Bindings
Message-ID: <20180926202957.GA23380@bogus>
References: <20180911150938.3844-1-mjourdan@baylibre.com>
 <20180911150938.3844-2-mjourdan@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180911150938.3844-2-mjourdan@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 11 Sep 2018 17:09:36 +0200, Maxime Jourdan wrote:
> Add documentation for the meson vdec dts node.
> 
> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> ---
>  .../bindings/media/amlogic,vdec.txt           | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/amlogic,vdec.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
