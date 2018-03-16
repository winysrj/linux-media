Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f41.google.com ([209.85.160.41]:36242 "EHLO
        mail-pl0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbeCPOuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:50:35 -0400
Received: by mail-pl0-f41.google.com with SMTP id 61-v6so6052287plf.3
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 07:50:35 -0700 (PDT)
Subject: Re: I2C media binding model
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <20180307122547.6c38f600@vento.lan>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <30147ff6-d0c2-a337-86d2-75fa5454c86c@gmail.com>
Date: Fri, 16 Mar 2018 23:50:31 +0900
MIME-Version: 1.0
In-Reply-To: <20180307122547.6c38f600@vento.lan>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en_US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As the new i2c binding helper was introduced,
I am now re-writing the following patches to use new helper functions.

> 5. Jan,16 2015: [v2,1/2] dvb: tua6034: add a new driver for Infineon tua6034 tuner
>         http://patchwork.linuxtv.org/patch/27927 
> 6. Jan,16 2015: [v2,2/2] dvb-usb-friio: split and merge into dvb-usbv2-gl861
>         http://patchwork.linuxtv.org/patch/27928 

But I noticed that the tua6034 (used in Friio devices) can be supported
by "tuner-simple" driver.
Since "tuner-simple" is not an i2c driver,
I am wondering if
1) I should use/modify "tuner-simple" driver without adding new one
    but with one more dvb_attach un-replaced, or,
2) I should make a new i2c driver as my previous patch #27927
   but with the duplicated function with tuner-simple.

Re-writing tuner-simple into a new i2c driver does not seem to be
an option to me, because that would affect lots of dvb/v4l drivers,
and I cannot test them.

In addition, I also intend to re-write "earth-pt1" driver in the future
by decomposing the current monolithic module into component drivers:
  bridge: earth-pt1 (cut down one)
  demod:  tc90522
  TERR-tuner: tda6654 (NEW?)
  SAT-tuner:  qm1d1b0004 (NEW)

There exists a "tda665x" tuner driver (in dvb-frontends/),
but it does not use the new i2c binding helpers either,
and it seems that it can be supported by "tuner-simple" as well.
So the similar situation here, though the tda665x driver is
used only by "mantis" currently.

So, which way should I go?
modify/use "tuner-simple" for now and update to a i2c driver later?
or introduce a new & redundant i2c driver?

regards,
Akihiro
