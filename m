Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38528 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752998AbdGCM7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 08:59:50 -0400
Received: by mail-it0-f45.google.com with SMTP id k192so55860666ith.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 05:59:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJcDVWMAq6QReuMWgA-X7n7CDqNreAOjdEHwt331gW41eDSo9w@mail.gmail.com>
References: <CAJcDVWMAq6QReuMWgA-X7n7CDqNreAOjdEHwt331gW41eDSo9w@mail.gmail.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Mon, 3 Jul 2017 08:59:44 -0400
Message-ID: <CALzAhNXCS53oT+H0zrbsU59gizxr88nA6WS9Rqygt-xPqWkYjg@mail.gmail.com>
Subject: Re: [PATCH] Hauppauge HVR-1975 support
To: =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?=
        <bernhard.rosenkranzer@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending)

Bernhard, thank you for sharing.

Mauro,

I've reviewed this patch, it has a host of problems.

Ignoring the fact it contains patches to all sorts of different cards
(saa7164, CX231xx, PVR-USB2)... the patch also contains materials that
I suspect Silicon Labs would consider proprietary and confidential,
its definitely derived works from proprietary SILABS drivers.

Proceed with caution.

- Steve

--=20
Steven Toth - Kernel Labs
http://www.kernellabs.com

On Mon, Jul 3, 2017 at 5:57 AM, Bernhard Rosenkr=C3=A4nzer
<bernhard.rosenkranzer@linaro.org> wrote:
> Hi,
> Hauppauge HVR-1975 is a USB DVB receiver box,
> http://www.hauppauge.co.uk/site/products/data_hvr1900.html
>
> It is currently not supported by v4l; Hauppauge provides a patch for
> kernel 3.19 at http://www.hauppauge.com/site/support/linux.html
>
> As expected, the patch doesn't work with more recent kernels, so I've
> ported it (verified to work on 4.11.8). Due to the size of the patch,
> I've uploaded my patch to
> http://lindev.ch/hauppauge-hvr-1975.patch
>
> While it works well, there's a potential license problem in one of the fi=
les:
> From drivers/media/dvb-frontend/silg.c:
>
> /* MODULE_LICENSE("Proprietary"); */
> /* GPL discussion for silg not finished. Set to GPL for internal usage on=
ly. */
> /* The module uses GPL functions and is rejected by the kernel build if t=
he */
> /* license is set to 'Proprietary'. */
> MODULE_LICENSE("GPL");
>
> I'm not a lawyer, but my understanding is that by Hauppauge actually
> releasing that file to the public (and it being so clearly a derivate
> of GPL code that they even have to acknowledge it), their claim that
> it is anything but GPL is null and void - but we may have to make
> sure.
>
> ttyl
> bero
