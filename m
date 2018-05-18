Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:40072 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbeERPPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:15:23 -0400
Received: by mail-qk0-f174.google.com with SMTP id s83-v6so6700402qke.7
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:15:23 -0700 (PDT)
Message-ID: <7f9f800349eb45fb9c3a96b37f238fab0a610ee4.camel@ndufresne.ca>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based
 cameras on generic apps
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: LMML <linux-media@vger.kernel.org>,
        Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
Date: Fri, 18 May 2018 11:15:20 -0400
In-Reply-To: <1568098.156aR60jyk@avalon>
References: <20180517160708.74811cfb@vento.lan> <3216261.G88TfqiCiH@avalon>
         <20180518082447.3068c34c@vento.lan> <1568098.156aR60jyk@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-tPrO3/KC1HWpMryXwugg"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-tPrO3/KC1HWpMryXwugg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 18 mai 2018 =C3=A0 15:38 +0300, Laurent Pinchart a =C3=A9crit :
> > Before libv4l, media support for a given device were limited to a few
> > apps that knew how to decode the format. There were even cases were a
> > proprietary app were required, as no open source decoders were availabl=
e.
> >=20
> > From my PoV, the biggest gain with libv4l is that the same group of
> > maintainers can ensure that the entire solution (Kernel driver and
> > low level userspace support) will provide everything required for an
> > open source app to work with it.
> >=20
> > I'm not sure how we would keep enforcing it if the pipeline setting
> > and control propagation logic for an specific hardware will be
> > delegated to PipeWire. It seems easier to keep doing it on a libv4l
> > (version 2) and let PipeWire to use it.
>=20
> I believe we need to first study pipewire in more details. I have no pers=
onal=20
> opinion yet as I haven't had time to investigate it. That being said, I d=
on't=20
> think that libv4l with closed-source plugins would be much better than a=
=20
> closed-source pipewire plugin. What main concern once we provide a usersp=
ace=20
> camera stack API is that vendors might implement that API in a closed-sou=
rce=20
> component that calls to a kernel driver implementing a custom API, with a=
ll=20
> knowledge about the camera located in the closed-source component. I'm no=
t=20
> sure how to prevent that, my best proposal would be to make V4L2 so usefu=
l=20
> that vendors wouldn't even think about a different solution (possibly cou=
pled=20
> by the pressure put by platform vendors such as Google who mandate upstre=
am=20
> kernel drivers for Chrome OS, but that's still limited as even when it co=
mes=20
> to Google there's no such pressure on the Android side).

If there is proprietary plugins, then I don't think it will make any
difference were this is implemented. The difference is the feature set
we expose. 3A is per device, but multiple streams, with per request
controls is also possible. PipeWire gives central place to manage this,
while giving multiple process access to the camera streams. I think in
the end, what fits better would be something like or the Android Camera
HAL2. But we could encourage OSS by maintaining a base implementation
that covers all the V4L2 aspect, leaving only the 3A aspect of the work
to be done. Maybe we need to come up with an abstraction that does not
prevent multi-streams, but only requires 3A per vendors (saying per
vendors, as some of this could be Open Source by third parties).

just thinking out loud now ;-P
Nicolas

p.s. Do we have the Intel / IPU3 folks in in the loop ? This is likely
the most pressing HW as it's shipping on many laptops now.
--=-tPrO3/KC1HWpMryXwugg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWv7uCAAKCRBxUwItrAao
HAuPAJ42XbA0TqIgapcpw6HLQBfqrE9ezQCeJWRhyZVsNUrk5tdIxjAHC6kmOgk=
=QhIW
-----END PGP SIGNATURE-----

--=-tPrO3/KC1HWpMryXwugg--
