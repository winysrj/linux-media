Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33594 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbdCORNt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 13:13:49 -0400
Date: Wed, 15 Mar 2017 12:13:46 -0500
From: Rob Herring <robh@kernel.org>
To: Yasunari.Takiguchi@sony.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, tbird20d@gmail.com,
        frowand.list@gmail.com,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        Kota Yonezawa <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: Re: [RFC PATCH 1/5] Document: Add document file for Sony CXD2880
 DVB-T2/T tuner + demodulator
Message-ID: <20170315171346.s7eerxvh4umj3ucu@rob-hp-laptop>
References: <1488848865-8428-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488848865-8428-1-git-send-email-Yasunari.Takiguchi@sony.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 07, 2017 at 10:07:45AM +0900, Yasunari.Takiguchi@sony.com wrote:
> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> This is the driver for Sony CXD2880 DVB-T2/T tuner + demodulator.

Looks like a binding, not a driver to me.

For subject, use: dt-bindings: media: ...

> 
> Regarding this third Beta Release, the status is:

"third Beta Release" is not really meaningful to upstream kernel.

> - Tested on Raspberry Pi 3.
> - The DVB-API operates under dvbv5 tools.
> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
> ---
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> new file mode 100644
> index 0000000..bdbb047
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> @@ -0,0 +1,16 @@
> +Sony CXD2880 DVB-T2/T tuner + demodulator driver SPI adapter
> +
> +Required properties:
> +- compatible: Should be "sony,cxd2880".
> +- reg: SPI chip select number for the device.
> +- spi-max-frequency: Maximum bus speed, should be set to <55000000> (55MHz).
> +- status: Should be "okay"
> +
> +Example:
> +
> +cxd2880@0 {
> +	compatible = "sony,cxd2880";
> +	reg = <0>; /* CE0 */
> +	spi-max-frequency = <55000000>; /* 55MHz */
> +	status = "okay";

Don't show status in examples.

> +};
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
