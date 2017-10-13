Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:46636 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753413AbdJMK07 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 06:26:59 -0400
MIME-Version: 1.0
In-Reply-To: <eab5bd7b-d909-343d-7078-842e3d0d9ab9@sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171013055928.21132-1-Yasunari.Takiguchi@sony.com> <CAJbz7-0T=LUSTr59kPDk4kVkHLh5XEeNEkA2T=hG=P_fXrrU=g@mail.gmail.com>
 <eab5bd7b-d909-343d-7078-842e3d0d9ab9@sony.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 13 Oct 2017 12:26:58 +0200
Message-ID: <CAJbz7-1Ad6L60KCmwtFDPzYH-vcBnzT5vDf-63YMRbyFQRDk+g@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] [media] cxd2880-spi: Add support for CXD2880 SPI interface
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Takiguchi,

>> If I understand it right, it uses SPI bus also for passing transport stream
>> to the host system (also having some pid piltering inside!), isn't it?
>> It would be interesting to know what is the max throughput of the CXD's SPI?
>
> Yes, max clock rate of spi is written in sony-cxd2880.txt of [patch v4 01/12].
>
>   spi-max-frequency = <55000000>; /* 55MHz */

Ehh, I overlooked this! Thanks for pointing me out.

BTW, is there any device, preferable some devboard with this silicon
on the market?

/Honza
