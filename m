Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:44730 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOWPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 17:15:13 -0500
Message-ID: <548F5D6E.4070907@butterbrot.org>
Date: Mon, 15 Dec 2014 23:15:10 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC] video support for Samsung SUR40
References: <548F029C.20907@butterbrot.org> <548F05EF.8080700@xs4all.nl>
In-Reply-To: <548F05EF.8080700@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="27PTGm7BcMisbkw7DNEC1nXBq0aARLTT5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--27PTGm7BcMisbkw7DNEC1nXBq0aARLTT5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 15.12.2014 17:01, Hans Verkuil wrote:
> On 12/15/2014 04:47 PM, Florian Echtler wrote:
>> However, I'm running into an issue I have a hard time understanding. I=
n
>> particular, as soon as I load the kernel module, I'm getting a kernel
>> oops (NULL pointer dereference) in line 354 or 355 of the attached
>> source code. The reason is probably that the previous check (in line
>> 350) doesn't abort - even though I didn't actually provide a buffer, s=
o
>> the list_head should be empty. As no user space program has actually
>> opened the video device yet, there shouldn't be any buffers queued,
>> right? (AFAICT the list is initialized properly in line 490).
>> I'd be quite grateful if somebody with more experience can look over t=
he
>> code and tell me what mistakes I made :-)
First of all, thanks for the quick feedback.

> Why on earth is sur40_poll doing anything with video buffers? That's
> all handled by vb2. As far as I can tell you can just delete everything=

> from '// deal with video data here' until the end of the poll function.=

Right now, the code doesn't do anything, but I'm planning to add the
actual data retrieval at this point later. I'd like to use the
input_polldev thread for this, as a) the video data should be fetched
synchronously with the input device data and b) the thread will be
running continuously anyway.

> The probably cause of the crash here is that the input device node is
> created before the 'INIT_LIST_HEAD(&sur40->buf_list);' call, and since
> udevd (I think) opens new devices immediately after they are created
> it is likely that sur40_poll is called before buf_list is initialized.
OK, that sounds plausible, will test that tomorrow.

> But, as I said, that code doesn't belong there at all, so just remove i=
t.
See above - that was actually intentional. It's kind of a hackish
solution, but for the moment, I'd just like to get a video stream with
minimal overhead, so I'm reusing the polldev thread.

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--27PTGm7BcMisbkw7DNEC1nXBq0aARLTT5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSPXW4ACgkQ7CzyshGvatgn8ACg2i8R3aMn07mVm4spS+aQwKz/
W2gAmwX9yYxyqGD+aRu1qvFHQ1UHmK6I
=OJ2F
-----END PGP SIGNATURE-----

--27PTGm7BcMisbkw7DNEC1nXBq0aARLTT5--
