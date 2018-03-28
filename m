Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:46282 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeC1Mhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 08:37:31 -0400
Received: by mail-io0-f176.google.com with SMTP id q80so3330452ioi.13
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 05:37:30 -0700 (PDT)
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
 <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
Date: Wed, 28 Mar 2018 21:37:26 +0900
MIME-Version: 1.0
In-Reply-To: <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
thanks for the comment.

> You should implement i2c adapter to demod driver and not add such glue
> to that USB-bridge. I mean that "relayed" stuff, i2c communication to
> tuner via demod. I2C-mux may not work I think as there is no gate-style
> multiplexing so you probably need plain i2c adapter. There is few
> examples already on some demod drivers.

I am afraid that the glue is actually necessary.

host - USB -> gl861 - I2C(1) -> tc90522 (addr:X)
                                  \- I2C(2) -> tua6034 (addr:Y)

To send an i2c read message to tua6034,
one has to issue two transactions:
 1. write via I2C(1) to addr:X, [ reg:0xfe, val: Y ]
 2. read via I2C(1) from addr:X, [ out_data0, out_data1, ....]

The problem is that the transaction 1 is (somehow) implemented with
the different USB request than the other i2c transactions on I2C(1).
(this is confirmed by a packet capture on Windows box).

Although tc90522 already creats the i2c adapter for I2C(2),
tc90522 cannot know/control the USB implementation of I2C(1),
only the bridge driver can do this.

regards,
Akihiro
