Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35653 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbeC3NVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 09:21:06 -0400
Received: by mail-pf0-f175.google.com with SMTP id u86so5391078pfd.2
        for <linux-media@vger.kernel.org>; Fri, 30 Mar 2018 06:21:05 -0700 (PDT)
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
 <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
 <e861a533-5517-2089-52af-ce720174e3ae@gmail.com>
 <db8f370c-20f5-e9fe-9d2e-d12c1475dc33@iki.fi>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <30d0270b-852a-39df-14e5-4c12d59aeac7@gmail.com>
Date: Fri, 30 Mar 2018 22:21:01 +0900
MIME-Version: 1.0
In-Reply-To: <db8f370c-20f5-e9fe-9d2e-d12c1475dc33@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I simply cannot see why it cannot work. Just add i2c adapter and
> suitable logic there. Transaction on your example is simply and there is
> no problem to implement that kind of logic to demod i2c adapter.

I might be totally wrong, but...

i2c transactions to a tuner must use:
1. usb_control_msg(request:3) for the first half (write) of reads
2. usb_control_msg(request:1) for the other writes
3. usb_control_msg(request:2) for (all) reads

How can the demod driver control the 'request' argument of USB messages
that are sent to its parent (not to the demod itself),
when the bridge of tc90522 cannot be limited to gl861 (or even to USB) ?

Akihiro
