Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46515 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbeKRCeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 21:34:23 -0500
Date: Sat, 17 Nov 2018 10:17:11 -0600
From: Rob Herring <robh@kernel.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: Yasunari.Takiguchi@sony.com, devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: sony-cxd2880: add optional vcc regulator to
 bindings
Message-ID: <20181117161711.GA19169@bogus>
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
 <1541681410-8187-3-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541681410-8187-3-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  8 Nov 2018 13:50:10 +0100, Neil Armstrong wrote:
> This patchset adds an optional VCC regulator to the bindings of the Sony
> CXD2880 DVB-T2/T tuner + demodulator adapter.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
