Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57598 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaJaP4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:56:07 -0400
Received: by mail-qc0-f181.google.com with SMTP id w7so6191978qcr.12
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 08:56:06 -0700 (PDT)
MIME-Version: 1.0
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Fri, 31 Oct 2014 08:55:46 -0700
Message-ID: <CACsaVZLs6-iypj1ZU13iVqBdNWY63NCt3f_+SqdpaLjqupPiNQ@mail.gmail.com>
Subject: Hauppage HVR-2250 - No Free Sequences
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

So I've been using my tuner for a couple years now with tvheadend,
works great :-). However, eventually I encounter something like this
in my dmesg

[585870.001641] saa7164_cmd_send() No free sequences
[585870.001645] saa7164_api_i2c_write() error, ret(1) = 0xc
[585870.001650] tda10048_writereg: writereg error (ret == -5)
[585870.024809] saa7164_cmd_send() No free sequences
[585870.024820] saa7164_api_i2c_read() error, ret(1) = 0xc
[585870.024826] tda10048_readreg: readreg error (ret == -5)
[585870.024838] saa7164_cmd_send() No free sequences
[585870.024843] saa7164_api_i2c_read() error, ret(1) = 0xc
[585870.024848] tda10048_readreg: readreg error (ret == -5)
[585870.024856] saa7164_cmd_send() No free sequences
[585870.024861] saa7164_api_i2c_write() error, ret(1) = 0xc
[585870.024866] tda10048_writereg: writereg error (ret == -5)
[585870.024878] saa7164_cmd_send() No free sequences
[585870.024883] saa7164_api_i2c_write() error, ret(1) = 0xc

The result is the card stops accepting commands; won't tune to other
frequencies. Rebooting the box seems to resolve it. The time before
that starts occurring though varies wildly, usually when it's stormy
and the ATSC antenna starts cutting in and out (reflection off of the
tree).

Is there another way I can get around doing that? would rmmod/insmod work?

Looking on the Hauppage site it looks like they're still developing
drivers for it ( ftp://ftp.hauppauge.com/Support/HVR2250/ ). From
google-ing around, it looks like people are still using the firmware
that Steven Toth ripped in 2011.

Any tips? I've tried a couple horrible kernel patches but didn't get anywhere.
Kyle.
