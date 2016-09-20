Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34005 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbcITBXp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 21:23:45 -0400
Received: by mail-oi0-f54.google.com with SMTP id a62so3566718oib.1
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2016 18:23:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKTMqxtREAB--eBQrQZJ7zH5BDnD=VmOkhrGfQgoU5-euwVvRw@mail.gmail.com>
References: <CAKTMqxtREAB--eBQrQZJ7zH5BDnD=VmOkhrGfQgoU5-euwVvRw@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 19 Sep 2016 21:23:31 -0400
Message-ID: <CAGoCfiwDCoY3zGRkufab0CX4dBR2hcYksuuv5Nq4DJNR==HR1w@mail.gmail.com>
Subject: Re: Null pointer dereference in ngene-core.c
To: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 19, 2016 at 8:51 PM, Alexandre-Xavier Labont=C3=A9-Lamoureux
<axdoomer@gmail.com> wrote:
> Hi people,
>
> In the file "/linux/drivers/media/pci/ngene/ngene-core.c", there is a
> null pointer dereference at line 1480.
>
> Code in the function "static int init_channel(struct ngene_channel *chan)=
"
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> if (io & NGENE_IO_TSIN) {
>     chan->fe =3D NULL;                      // Set to NULL
>     if (ni->demod_attach[nr]) {         // First condition
>        ret =3D ni->demod_attach[nr](chan);
>             if (ret < 0)                           // Another condition
>                 goto err;                         // Goto that avoids
> the problem
>     }
>     if (chan->fe && ni->tuner_attach[nr]) {     // Condition that
> tests the null pointer
>         ret =3D ni->tuner_attach[nr](chan);
>         if (ret < 0)
>             goto err;
>     }
> }
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> "chan->fe" is set to NULL, then it tests for something (I have no idea
> what it's doing, I know nothing about this driver), if the results of
> the first two if conditions fail to reach the goto, then it will test
> the condition with the null pointer, which will cause a crash. I don't
> know if the kernel can recover from null pointers, I think not.

This looks fine to me.  It's a simple test to see if chan->fe got set
to null (presumably in the above block of code).  A null pointer
dereference would be if the first block set *chan* to NULL (as opposed
to chan->fe) and then the if() statement then attempted to inspect
chan->fe.

LGTM.

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
