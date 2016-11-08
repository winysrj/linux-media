Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35692 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933039AbcKHSmG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 13:42:06 -0500
MIME-Version: 1.0
In-Reply-To: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Nov 2016 10:42:03 -0800
Message-ID: <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 6, 2016 at 7:40 AM, J=C3=B6rg Otte <jrg.otte@gmail.com> wrote:
> Since v4.9-rc4 I get following crash in dvb-usb-cinergyT2 module.

Looks like it's commit 5ef8ed0e5608f ("[media] cinergyT2-core: don't
do DMA on stack"), which movced the DMA data array from the stack to
the "private" pointer. In the process it also added serialization in
the form of "data_mutex", but and now it oopses on that mutex because
the private pointer is NULL.

It looks like the "->private" pointer is allocated in dvb_usb_adapter_init(=
)

cinergyt2_usb_probe ->
  dvb_usb_device_init ->
    dvb_usb_init() ->
      dvb_usb_adapter_init()

but the dvb_usb_init() function calls dvb_usb_device_power_ctrl()
(which calls the "power_ctrl" function, which is
cinergyt2_power_ctrl() for that drive) *before* it initializes the
private field.

Mauro, Patrick, could dvb_usb_adapter_init() be called earlier, perhaps?

                    Linus
