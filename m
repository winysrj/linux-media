Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:42260 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeERSXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:23:40 -0400
Received: by mail-qk0-f196.google.com with SMTP id b22-v6so7164425qkj.9
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 11:23:40 -0700 (PDT)
Message-ID: <ca6b027256ee591fbcb98f84c95e466d718e46ef.camel@ndufresne.ca>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based
 cameras on generic apps
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>
Date: Fri, 18 May 2018 14:23:37 -0400
In-Reply-To: <CAAoAYcN-9zrbLWZULZM9emF5G8=stssQy04QgrguSYi4g6dQxw@mail.gmail.com>
References: <20180517160708.74811cfb@vento.lan> <1731086.UqanYK9fHS@avalon>
         <20180518120522.79b36f77@vento.lan>
         <CAAoAYcN-9zrbLWZULZM9emF5G8=stssQy04QgrguSYi4g6dQxw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-xhoTHRgaJmbwFJJgqAqq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xhoTHRgaJmbwFJJgqAqq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 18 mai 2018 =C3=A0 16:37 +0100, Dave Stevenson a =C3=A9crit :
> On 18 May 2018 at 16:05, Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> > Em Fri, 18 May 2018 15:27:24 +0300
>=20
> <snip>
> > >=20
> > > > There, instead of an USB camera, the hardware is equipped with a
> > > > MC-based ISP, connected to its camera. Currently, despite having
> > > > a Kernel driver for it, the camera doesn't work with any
> > > > userspace application.
> > > >=20
> > > > I'm also aware of other projects that are considering the usage of
> > > > mc-based devices for non-dedicated hardware.
> > >=20
> > > What are those projects ?
> >=20
> > Well, cheap ARM-based hardware like RPi3 already has this issue: they
> > have an ISP (or some GPU firmware meant to emulate an ISP). While
> > those hardware could have multiple sensors, typically they have just
> > one.
>=20
> Slight hijack, but a closely linked issue for the Pi.
> The way I understand the issue of V4L2 / MC on Pi is a more
> fundamental mismatch in architecture. Please correct me if I'm wrong
> here.
>=20
> The Pi CSI2 receiver peripheral always writes the incoming data to
> SDRAM, and the ISP is then a memory to memory device.

This is the same for IPU3 and some new can ARM ISP works like this too.
Though, IPU3 is fixed, you simply enable / disable / configure the ISP
base on the stats/metadata. Basically, it's not a single device, but
really two separate thing, were the ISP could be used without a sensor.
(Hope this make sense, need to be taken in consideration).

>=20
> V4L2 subdevices are not dma controllers and therefore have no buffers
> allocated to them. So to support the full complexity of the pipeline
> in V4L2 requires that something somewhere would have to be dequeuing
> the buffers from the CSI receiver V4L2 device and queuing them to the
> input of a (theoretical) ISP M2M V4L2 device, and returning them once
> processed. The application only cares about the output of the ISP M2M
> device.
>=20
> So I guess my question is whether there is a sane mechanism to remove
> that buffer allocation and handling from the app? Without it we are
> pretty much forced to hide bigger blobs of functionality to even
> vaguely fit in with V4L2.
>=20
> I'm at the point where it shouldn't be a huge amount of work to create
> at least a basic ISP V4L2 M2M device, but I'm not planning on doing it
> if it pushes the above buffer handling onto the app because it simply
> won't get used beyond demo apps. The likes of Cheese, Scratch, etc,
> just won't do it.

Well, would have to be a media controller running in M2M as it is not
1:1 in term of number of input : number of output.

>=20
> To avoid ambiguity, the Pi has a hardware ISP block. There are other
> SoCs that use either GPU code or a DSP to implement their ISP.

That's a good point, something that need to be kept in mind.

>=20
>   Dave
--=-xhoTHRgaJmbwFJJgqAqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWv8aKQAKCRBxUwItrAao
HAMuAJ0UxNTPN0dV264phQ1gi9TaaTlyYwCguF4NrT3p4X8rmw9EKKUNXNerrsc=
=+CO7
-----END PGP SIGNATURE-----

--=-xhoTHRgaJmbwFJJgqAqq--
