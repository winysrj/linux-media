Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:37411 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752230AbeBTPWG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 10:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <5a8c18fe.594a620a.7443c.50c7@mx.google.com>
References: <5a8c18fe.594a620a.7443c.50c7@mx.google.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 20 Feb 2018 16:22:04 +0100
Message-ID: <CAK8P3a3ma6aO_rBCj5e4AhUMhxRH383Ag2KzKQ9qfk2=Nkx-oQ@mail.gmail.com>
Subject: Re: stable-rc build: 3 warnings 0 failures (stable-rc/v4.14.20-119-g1b1ab1d)
To: stable <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>,
        Kernel Build Reports Mailman List
        <kernel-build-reports@lists.linaro.org>,
        "Olof's autobuilder" <build@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 20, 2018 at 1:47 PM, Olof's autobuilder <build@lixom.net> wrote:

> Warnings:
>
>         arm64.allmodconfig:
> drivers/media/tuners/r820t.c:1334:1: warning: the frame size of 2896 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Hi Greg,

please add

16c3ada89cff ("media: r820t: fix r820t_write_reg for KASAN")

This is an old bug, but hasn't shown up before as the stack warning
limit was turned off
in allmodconfig kernels. The fix is also on the backport lists I sent
for 4.9 and 4.4.

        Arnd
