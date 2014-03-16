Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64261 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCPLwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 07:52:38 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so3600188wgh.17
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 04:52:37 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 9/9] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback
Date: Sun, 16 Mar 2014 11:52:21 +0000
Message-ID: <2076172.6KyOpsnAqT@radagast>
In-Reply-To: <CAKv9HNZN6hWgYnWmD3zgEABjNMxzMsAoaCT4Mgb7EKF4r5zjdg@mail.gmail.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <1394838259-14260-10-git-send-email-james@albanarts.com> <CAKv9HNZN6hWgYnWmD3zgEABjNMxzMsAoaCT4Mgb7EKF4r5zjdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2323710.yqxCSamatO"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2323710.yqxCSamatO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 16 March 2014 10:39:39 Antti Sepp=E4l=E4 wrote:
> > +static int nvt_write_wakeup_codes(struct rc_dev *dev,
> > +                                 const u8 *wakeup_sample_buf, int =
count)
> > +{
> > +       int i =3D 0;
> > +       u8 reg, reg_learn_mode;
> > +       unsigned long flags;
> > +       struct nvt_dev *nvt =3D dev->priv;
> > +
> > +       nvt_dbg_wake("writing wakeup samples");
> > +
> > +       reg =3D nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
> > +       reg_learn_mode =3D reg & ~CIR_WAKE_IRCON_MODE0;
> > +       reg_learn_mode |=3D CIR_WAKE_IRCON_MODE1;
> > +
> > +       /* Lock the learn area to prevent racing with wake-isr */
> > +       spin_lock_irqsave(&nvt->nvt_lock, flags);
> > +
> > +       /* Enable fifo writes */
> > +       nvt_cir_wake_reg_write(nvt, reg_learn_mode, CIR_WAKE_IRCON)=
;
> > +
> > +       /* Clear cir wake rx fifo */
> > +       nvt_clear_cir_wake_fifo(nvt);
> > +
> > +       if (count > WAKE_FIFO_LEN) {
> > +               nvt_dbg_wake("HW FIFO too small for all wake sample=
s");
> > +               count =3D WAKE_FIFO_LEN;
> > +       }
>=20
> Now that the encoders support partial encoding the above check agains=
t
> WAKE_FIFO_LEN never triggers and can be removed.

Yep, good point

Thanks
James
--nextPart2323710.yqxCSamatO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTJZB8AAoJEGwLaZPeOHZ6W6AQAIEpfE85+KO6yT8xQO9RGG67
8/iysTeeLXPQyXRrymjdCfQNO5lme9Dn/TZcFVy8w/k0dV56Zmb26QwS69dcnVyF
4a/FyhbbWGFX03Z+bW6o1mrJ/eJUA1snLST8p1GaeKyIZRhTQUHFw72JaD0kjEwf
HYv93d5SFpgXJK/NxHWqP/uxzEqulCn4VRdPemQFHuponeGoyxfsqDpezpT242WS
PmGGwWfmKsBSG/KSE59m7RAd3xjCxdbWQn/5HeevbUEKJVZcZQO8jYkMbr61+kVd
RYgnNEQBWQNo5K9NUqouWHg2zyoQmttoFLva7Cwvn9FHsHON49ckiTvnSyZaZHTC
pW5wR4QSej5PEXpFo5v+XdDt4BaIqKIPGpg2WTjh42XGGhQOSSP7UE5CE5JLhewg
tHzRQO55UswKMVwSmrdim+O2bxclVIRoyatnnLCAPog436kQWid5YFooPCQAJsmV
xNTdP67Da8xnkZbZtGd7c94XD7xQxk/NNbD3RB6yGSJejkfUReK+nJRpVZq49070
unf4SBO9T374Hef3T/eY2Vq8atduAnBcPm+p/UiKrswX8VYimTU0qDnvMJba8Loz
x7JNmiO77zyNqOZSQ1WrPnLUpWLNlp8gR1ki75PrLCTyuFQ1vz68PReMuWOYFTTs
sU/MQAvOIvltEwXrCbJk
=nW18
-----END PGP SIGNATURE-----

--nextPart2323710.yqxCSamatO--

