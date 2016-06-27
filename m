Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36501 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbcF0IoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 04:44:01 -0400
Date: Mon, 27 Jun 2016 10:43:26 +0200
From: Carlo Caione <carlo@caione.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: b.galvani@gmail.com, linux-media@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
	mchehab@kernel.org, tobetter@gmail.com, devicetree@vger.kernel.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
Subject: Re: [PATCH v2 2/2] ARM: dts: meson: fixed size of the meson-ir
 registers
Message-ID: <20160627084326.GA1737@localhost>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160626210622.5257-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20160626210622.5257-3-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/16 23:06, Martin Blumenstingl wrote:
> According to the reference driver (and the datasheet of the newer
> Meson8b/S805 and GXBB/S905 SoCs) there are 14 registers, each 32 bit
> wide.

Then why are you modifying the DTS for the Meson6? As Neil already
suggested, it seems that the hardware has been slightly modified for the
latest SoCs, so this approach is clearly wrong.
Add a new compatible and use of_device_get_match_data() to get the SoC
specific data.

> Adjust the register size to reflect that, as register offset 0x20 is
> now also needed by the meson-ir driver.

According to the AML8726-MX (meson6) datasheet the value of 0x20 is
correct, at least for that hardware.

Cheers,

-- 
Carlo Caione
