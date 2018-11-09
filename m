Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39924 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbeKIS3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 13:29:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id u13-v6so1177712wmc.4
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 00:50:14 -0800 (PST)
Subject: Re: [PATCH 0/2] sony-cxd2880: add optional vcc regulator
To: Frank Rowand <frowand.list@gmail.com>, Yasunari.Takiguchi@sony.com
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
 <5328b351-e768-6c4a-66c4-c5f6d5894244@gmail.com>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <b1a8f0c4-de98-5c8e-bfce-84c8f32789aa@baylibre.com>
Date: Fri, 9 Nov 2018 09:50:11 +0100
MIME-Version: 1.0
In-Reply-To: <5328b351-e768-6c4a-66c4-c5f6d5894244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On 09/11/2018 03:22, Frank Rowand wrote:
> Hi Neil,
> 
> On 11/8/18 4:50 AM, Neil Armstrong wrote:
>> This patchset adds an optional VCC regulator to the bindings and driver to
>> make sure power is enabled to the module before starting attaching to
>> the device.
>>
>> Neil Armstrong (2):
>>   media: cxd2880-spi: Add optional vcc regulator
>>   media: sony-cxd2880: add optional vcc regulator to bindings
>>
>>  .../devicetree/bindings/media/spi/sony-cxd2880.txt       |  4 ++++
>>  drivers/media/spi/cxd2880-spi.c                          | 16 ++++++++++++++++
>>  2 files changed, 20 insertions(+)
>>
> 
> Please see Documentation/devicetree/bindings/submitting-patches.txt
> for some helpful information about submitting a series that includes
> a bindings patch.
> 
> You will want to add 'dt-bindings:' into the subject line, along with the
> current 'media:'.  And getmaintainer will give you Rob's and Mark's
> emails.

I'll re-spin with dt-bindings, but some maintainers don't want or don't care,
so it's always a wild guess at some point !

> 
> Thanks,
> 
> Frank
> 

Neil
