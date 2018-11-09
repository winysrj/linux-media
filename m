Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37883 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbeKIMBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 07:01:01 -0500
Subject: Re: [PATCH 0/2] sony-cxd2880: add optional vcc regulator
To: Neil Armstrong <narmstrong@baylibre.com>,
        Yasunari.Takiguchi@sony.com
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <5328b351-e768-6c4a-66c4-c5f6d5894244@gmail.com>
Date: Thu, 8 Nov 2018 18:22:32 -0800
MIME-Version: 1.0
In-Reply-To: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

On 11/8/18 4:50 AM, Neil Armstrong wrote:
> This patchset adds an optional VCC regulator to the bindings and driver to
> make sure power is enabled to the module before starting attaching to
> the device.
> 
> Neil Armstrong (2):
>   media: cxd2880-spi: Add optional vcc regulator
>   media: sony-cxd2880: add optional vcc regulator to bindings
> 
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt       |  4 ++++
>  drivers/media/spi/cxd2880-spi.c                          | 16 ++++++++++++++++
>  2 files changed, 20 insertions(+)
> 

Please see Documentation/devicetree/bindings/submitting-patches.txt
for some helpful information about submitting a series that includes
a bindings patch.

You will want to add 'dt-bindings:' into the subject line, along with the
current 'media:'.  And getmaintainer will give you Rob's and Mark's
emails.

Thanks,

Frank
