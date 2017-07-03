Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35872 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753804AbdGCJ54 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:57:56 -0400
Received: by mail-ua0-f174.google.com with SMTP id g40so106378084uaa.3
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 02:57:56 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?=
        <bernhard.rosenkranzer@linaro.org>
Date: Mon, 3 Jul 2017 11:57:35 +0200
Message-ID: <CAJcDVWMAq6QReuMWgA-X7n7CDqNreAOjdEHwt331gW41eDSo9w@mail.gmail.com>
Subject: [PATCH] Hauppauge HVR-1975 support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Hauppauge HVR-1975 is a USB DVB receiver box,
http://www.hauppauge.co.uk/site/products/data_hvr1900.html

It is currently not supported by v4l; Hauppauge provides a patch for
kernel 3.19 at http://www.hauppauge.com/site/support/linux.html

As expected, the patch doesn't work with more recent kernels, so I've
ported it (verified to work on 4.11.8). Due to the size of the patch,
I've uploaded my patch to
http://lindev.ch/hauppauge-hvr-1975.patch

While it works well, there's a potential license problem in one of the files:
>From drivers/media/dvb-frontend/silg.c:

/* MODULE_LICENSE("Proprietary"); */
/* GPL discussion for silg not finished. Set to GPL for internal usage only. */
/* The module uses GPL functions and is rejected by the kernel build if the */
/* license is set to 'Proprietary'. */
MODULE_LICENSE("GPL");

I'm not a lawyer, but my understanding is that by Hauppauge actually
releasing that file to the public (and it being so clearly a derivate
of GPL code that they even have to acknowledge it), their claim that
it is anything but GPL is null and void - but we may have to make
sure.

ttyl
bero
