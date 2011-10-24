Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1JXL3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 07:29:16 -0400
Received: by wwe6 with SMTP id 6so8792584wwe.1
        for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 04:29:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA54389.9040505@darkmike.ru>
References: <4EA54389.9040505@darkmike.ru>
Date: Mon, 24 Oct 2011 13:29:15 +0200
Message-ID: <CAL9G6WX1tTSLsm-iMNWnJdWJWQQ1m31WTTzrvG3eh9BYE8fnfw@mail.gmail.com>
Subject: Re: Problem with TeVii S-470
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Mike Mironov <subscribe@darkmike.ru>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/10/24 Mike Mironov <subscribe@darkmike.ru>:
> Hello!
>
> I have this card http://www.linuxtv.org/wiki/index.php/TeVii_S470
>
> I try to use it under Debian Squeeze, but I can't get channel data from it.
>
> I try to use drivers from 2.6.38, 2.6.39 kernels, s2-liplianin drivers with
> 2.6.32 kernel, last linux-media drivers with 2.6.32
>
> With all drivers I can scan channels, but then a I'll try to lock channel I
> get some error in syslog (module cx23885 loaded with debug=1)
>
> cx23885[0]/0: [f373ec80/27] cx23885_buf_queue - append to active
> cx23885[0]/0: [f373ebc0/28] wakeup reg=477 buf=477
> cx23885[0]/0: queue is not empty - append to active
>
> and finally a lot of
>
> cx23885[0]/0: [f42c4240/6] timeout - dma=0x03c5c000
> cx23885[0]/0: [f42c4180/7] timeout - dma=0x3322b000
> cx23885[0]/0: [f4374440/8] timeout - dma=0x33048000
> cx23885[0]/0: [f4374140/9] timeout - dma=0x03d68000
>
> In other machine this work under Windows. Under Linux I have same effects.
>
> It's problem in drivers or in card? That addition information need to
> resolve this problem?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>

Hello Mike, I have same device on same OS, try this:
mkdir /usr/local/src/dvbcd /usr/local/src/dvbwget
http://tevii.com/100315_Beta_linux_tevii_ds3000.rarunrar x
100315_Beta_linux_tevii_ds3000.rarcp dvb-fe-ds3000.fw
/lib/firmware/tar xjvf linux-tevii-ds3000.tar.bz2cd
linux-tevii-ds3000make && make install
Regards.
-- 
Josu Lazkano
