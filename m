Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35227 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbcITByC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 21:54:02 -0400
Received: by mail-oi0-f45.google.com with SMTP id w11so4211332oia.2
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2016 18:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKTMqxtREAB--eBQrQZJ7zH5BDnD=VmOkhrGfQgoU5-euwVvRw@mail.gmail.com>
References: <CAKTMqxtREAB--eBQrQZJ7zH5BDnD=VmOkhrGfQgoU5-euwVvRw@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 19 Sep 2016 21:54:00 -0400
Message-ID: <CAGoCfixDna2AJ2MKTGaEm-SUPTFBfotD6BVzUYqFKYruW52E5w@mail.gmail.com>
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

I would have to actually look at the code, but my guess is because the
call to ni-ni->demod_attach[nr](chan) will actually set chan->fe if
successful.

The code path your describing is actually the primary use case.  The
cases where you see "goto err" will only be followed if there was some
sort of error condition, which means the driver essentially will
*always* hit the if() statement you are referring to during normal
operation (assuming nothing was broken in the hardware).

In short, the code makes sure chan->fe is NULL, then it calls the
demod_attach, then it checks both for the demod_attach returning an
error *and* making sure demod_attach set chan->fe to some non-NULL
value.  If both are the case, then it calls tuner_attach().

This is a pretty standard workflow -- you should see it in many other
drivers, although it's not uncommon in other drivers for something
like chan->fe to actually be the value returned by the demod_attach(),
and the demod attach routine would return NULL if there was some
failure condition.  The problem with that approach is that you can
only report one type of failure to the caller (all the caller knows is
a failure occured, it has no visibility as to the nature of the
failure), whereas with this approach you can return different values
for different error conditions.

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
