Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:53543 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaLPMfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 07:35:48 -0500
Message-ID: <5490271F.1060609@butterbrot.org>
Date: Tue, 16 Dec 2014 13:35:43 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC] video support for Samsung SUR40
References: <548F029C.20907@butterbrot.org> <548F05EF.8080700@xs4all.nl> <548F5D6E.4070907@butterbrot.org> <548F6205.6000305@xs4all.nl>
In-Reply-To: <548F6205.6000305@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tAlSmVN8uo46tnrlPwEqLMravuG6iUbw6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tAlSmVN8uo46tnrlPwEqLMravuG6iUbw6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 15.12.2014 23:34, Hans Verkuil wrote:
> On 12/15/2014 11:15 PM, Florian Echtler wrote:
>> On 15.12.2014 17:01, Hans Verkuil wrote:
>>> On 12/15/2014 04:47 PM, Florian Echtler wrote:
>>> Why on earth is sur40_poll doing anything with video buffers? That's
>>> all handled by vb2. As far as I can tell you can just delete everythi=
ng
>>> from '// deal with video data here' until the end of the poll functio=
n.
>> Right now, the code doesn't do anything, but I'm planning to add the
>> actual data retrieval at this point later. I'd like to use the
>> input_polldev thread for this, as a) the video data should be fetched
>> synchronously with the input device data and b) the thread will be
>> running continuously anyway.
> Ah, now I see it.
One additional question you might be able to answer: if I use
vb2_dma_contig_init_ctx for the allocator context, will usb_bulk_msg
with a vb2_buffer then automatically use DMA? I want to avoid
unnecessary memcpy operations, so ideally the USB host controller should
directly put the data into the buffer which is then passed to userspace.
Does this require any additional setup?

>>> But, as I said, that code doesn't belong there at all, so just remove=
 it.
>> See above - that was actually intentional. It's kind of a hackish
>> solution, but for the moment, I'd just like to get a video stream with=

>> minimal overhead, so I'm reusing the polldev thread.
> OK. If you are planning to upstream this driver, then this probably nee=
ds
> another look.
Once I get it working, I'll submit a patch for further discussion.

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--tAlSmVN8uo46tnrlPwEqLMravuG6iUbw6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSQJx8ACgkQ7CzyshGvatgz2QCeMdDcNP9j3RgCMWuiua7tAUVB
/vwAnRIAhMXzOgPcm2WSrWjaufv9eh+P
=3Rly
-----END PGP SIGNATURE-----

--tAlSmVN8uo46tnrlPwEqLMravuG6iUbw6--
