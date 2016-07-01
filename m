Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36631 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbcGABe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 21:34:57 -0400
Date: Thu, 30 Jun 2016 20:34:10 -0500
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
	mark.rutland@arm.com, carlo@caione.org, khilman@baylibre.com,
	mchehab@kernel.org, devicetree@vger.kernel.org,
	narmstrong@baylibre.com
Subject: Re: [PATCH v3 1/4] dt-bindings: media: meson-ir: Add Meson8b and
 GXBB compatible strings
Message-ID: <20160701013410.GA23375@rob-hp-laptop>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160628191802.21227-2-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 28, 2016 at 09:17:59PM +0200, Martin Blumenstingl wrote:
> From: Neil Armstrong <narmstrong@baylibre.com>
> 
> New bindings are needed as the register layout on the newer platforms
> is slightly different compared to Meson6b.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  Documentation/devicetree/bindings/media/meson-ir.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
