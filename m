Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33749 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752763AbdDJSX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 14:23:57 -0400
Date: Mon, 10 Apr 2017 13:23:51 -0500
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
Subject: Re: [PATCH 1/5] dt-bindings: media: Add document file for CXD2880
 SPI I/F
Message-ID: <20170410182351.wkbaj46t3eomohwd@rob-hp-laptop>
References: <1491465273-9338-1-git-send-email-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491465273-9338-1-git-send-email-Yasunari.Takiguchi@sony.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 06, 2017 at 04:54:33PM +0900, Yasunari.Takiguchi@sony.com wrote:
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
> ---
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt

Acked-by: Rob Herring <robh@kernel.org>
