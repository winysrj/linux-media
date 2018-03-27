Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:59937 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbeC0XqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 19:46:09 -0400
Subject: Re: [PATCH v4] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and
 merge with gl861
To: tskd08@gmail.com, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180327174730.1887-1-tskd08@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <f1ce1268-e918-a12f-959e-98644cafb2fe@iki.fi>
Date: Wed, 28 Mar 2018 02:46:06 +0300
MIME-Version: 1.0
In-Reply-To: <20180327174730.1887-1-tskd08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2018 08:47 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Friio device contains "gl861" bridge and "tc90522" demod,
> for which the separate drivers are already in the kernel.
> But friio driver was monolithic and did not use them,
> practically copying those features.
> This patch decomposes friio driver into sub drivers and
> re-uses existing ones, thus reduces some code.
> 
> It adds some features to gl861,
> to support the friio-specific init/config of the devices
> and implement i2c communications to the tuner via demod
> with USB vendor requests.

You should implement i2c adapter to demod driver and not add such glue 
to that USB-bridge. I mean that "relayed" stuff, i2c communication to 
tuner via demod. I2C-mux may not work I think as there is no gate-style 
multiplexing so you probably need plain i2c adapter. There is few 
examples already on some demod drivers.

regards
Antti

-- 
http://palosaari.fi/
