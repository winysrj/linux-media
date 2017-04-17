Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0109.outbound.protection.outlook.com ([104.47.32.109]:45121
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932157AbdDQE7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 00:59:01 -0400
From: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Subject: Re: [PATCH v2 01/15] [dt-bindings] [media] Add document file for
 CXD2880 SPI I/F
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
 <20170414020041.16897-1-Yasunari.Takiguchi@sony.com>
CC: "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
        <yasunari.takiguchi@sony.com>
Message-ID: <c669e485-41b5-71fe-5ef6-f1a181c168e6@sony.com>
Date: Mon, 17 Apr 2017 13:58:56 +0900
MIME-Version: 1.0
In-Reply-To: <20170414020041.16897-1-Yasunari.Takiguchi@sony.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> This is the document file for Sony CXD2880 DVB-T2/T tuner + demodulator.
> It contains the description of the SPI adapter binding.
> 
> Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
> Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
> Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
> Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
> Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
No changes since version 1, I should have carried the ack forward:

Acked-by: Rob Herring <robh@kernel.org>


> ---
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt         | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> new file mode 100644
> index 000000000000..fc5aa263abe5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
> @@ -0,0 +1,14 @@
> +Sony CXD2880 DVB-T2/T tuner + demodulator driver SPI adapter
> +
> +Required properties:
> +- compatible: Should be "sony,cxd2880".
> +- reg: SPI chip select number for the device.
> +- spi-max-frequency: Maximum bus speed, should be set to <55000000> (55MHz).
> +
> +Example:
> +
> +cxd2880@0 {
> +	compatible = "sony,cxd2880";
> +	reg = <0>; /* CE0 */
> +	spi-max-frequency = <55000000>; /* 55MHz */
> +};
> 

Takiguchi
