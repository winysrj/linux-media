Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40571 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932441AbcLGW6y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 17:58:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Regression: tvp5150 refactoring breaks all em28xx devices
Date: Thu, 08 Dec 2016 00:59:17 +0200
Message-ID: <4766252.UD1QfvftzS@avalon>
In-Reply-To: <CAGoCfiz28eu9dT5qXr-qyh6V_-Xm91MkjzE88wtUJsQfLMNCwA@mail.gmail.com>
References: <CAGoCfiz28eu9dT5qXr-qyh6V_-Xm91MkjzE88wtUJsQfLMNCwA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Wednesday 07 Dec 2016 12:47:01 Devin Heitmueller wrote:
> Hello Javier, Mauro, Laurent,
>=20
> I hope all is well with you.  Mauro, Laurent:  you guys going to
> ELC/Portland in February?

I haven't decided for sure yet, but I will likely go.

> Looks like the refactoring done to tvp5150 in January 2016 for
> s_stream() to support some embedded platform caused breakage in the
> 30+ em28xx products that also use the chip.

I assume you're talking about

commit 460b6c0831cb52ef349156cfa27e889606b4cb75
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Thu Jan 7 10:46:45 2016 -0200

    [media] tvp5150: Add s_stream subdev operation support

followed by

commit 47de9bf8931e6bf9c92fdba9867925d1ce482ab1
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Mon Jan 25 14:39:34 2016 -0200

    [media] tvp5150: Fix breakage for serial usage

both introduced in v4.6. I further assume that "serial" means BT.656 he=
re,=20
which is still parallel.

> Problem confirmed on both the Startech SVIDUSB2 board Steve Preston
> was nice enough to ship me (after adding a board profile), as well as=

> on my original HVR-950 which has worked fine since 2008.
>=20
> The implementation tramples the TVP5150_MISC_CTL register, blowing
> into it a hard-coded value based on one of two scenarios, neither of
> which matches what is expected by em28xx devices.  At least in the
> case of NTSC, this results in chroma cycling.  This was also reported=

> by Alexandre-Xavier Labont=E9-Lamoureux back in August, although in t=
he
> video below he's also having some other issue related to progressive
> video because he's using an old gaming console as the source (i.e. pa=
y
> attention to the chroma effects in the top half of the video rather
> than the fact that only the first field is being rendered).
>=20
> https://youtu.be/WLlqJ7T3y4g
>=20
> The s_stream implementation writes 0x09 or 0x0d into TVP5150_MISC_CTL=

> (overriding whatever was written by tvp5150_init_default and
> tvp5150_selmux().  In fact, just as a test I was able to start up
> video, see the corruption, and write the correct value back into the
> register via v4l2-dbg in order to get it working again:
>=20
> sudo v4l2-dbg --chip=3Dsubdev0 --set-register=3D0x03 0x6f
>=20
> There's no easy fix for this without extending the driver to support
> proper configuration of the output pin muxing, which it isn't clear t=
o
> me what the right approach is and I don't have the embedded hardware
> platform that prompted the refactoring in order to do regression
> testing anyway.
>=20
> Feel free to take it upon yourselves to fix the regression you introd=
uced.

I've had a quick look at the code from the point of view opposite from =
yours,=20
with my knowledge of the embedded side but without any experience with =
em28xx.=20
I don't think that adding proper configuration of pinmuxing would be th=
at=20
hard, if it wasn't for the tvp5150_reset() function. The function is ca=
lled=20
directly in the get and set format handlers, and through subdev core=20=

operations.

The way we expose and use the reset operation is a very surprising (to =
stay=20
politically correct) idea, but in the context of em28xx shouldn't be to=
o much=20
of a problem as the operation is only invoked at stream on time, before=
=20
s_stream(1). However, calling it from the get and set format handlers c=
an only=20
lead me to conclude that the kernel is missing an ENOBRAIN error code. =
I'll=20
blame it on history.

As a prerequisite to implement proper output mixing configuration, the=20=

tvp5150_reset() call needs to be removed from tvp5150_fill_fmt(). I can=
't test=20
that with the em28xx driver as I don't have access to any such device. =
Devin,=20
would you be able to assist with testing on em28xx by removing the func=
tion=20
call from a working kernel (v4.5 would be ideal) and check if the devic=
e still=20
operates correctly ? I believe it would, given that the reset operation=
 is=20
called at stream on time as well as explained above, and that call woul=
d still=20
be there.

The tvp5150_reset() call in tvp5150_fill_fmt() was added by

commit ec2c4f3f93cb9ae2b09b8e942dd75ad3bdf23c9d
Author: Javier Martin <javier.martin@vista-silicon.com>
Date:   Thu Jan 5 10:57:39 2012 -0300

    [media] media: tvp5150: Add mbus_fmt callbacks
   =20
    These callbacks allow a host video driver
    to poll video formats supported by tvp5150.
   =20
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I assume the call was originally intended to put the device in a known =
state=20
for a following call to tvp5150_read_std() in the same function. Given =
that=20
that code got removed in the meantime, I don't see any need to reset th=
e chip=20
there.=20

I'm not sure who added the code, as the commit is authored by Javier by=
 only=20
signed by Mauro. Could any (or both) of you shed some light on that ?

Mauro, as you've already attempted (unfortunately unsuccessfully) to fi=
x this=20
problem in 47de9bf8931e6bf9c92fdba9867925d1ce482ab1, do you plan to giv=
e it=20
another try ? Now that I've performed an initial analysis and set the=20=

direction, this should be easy, right ? :-)

--=20
Regards,

Laurent Pinchart

