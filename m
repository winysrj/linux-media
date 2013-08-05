Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38572 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3HEND4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 09:03:56 -0400
Message-ID: <51FFA2B1.1050809@ti.com>
Date: Mon, 5 Aug 2013 16:03:45 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/6] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-3-git-send-email-archit@ti.com> <51FF6C4D.2030306@ti.com> <51FF9517.6000406@ti.com>
In-Reply-To: <51FF9517.6000406@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="CGWEWjkHSbj3p5R9HEfANwduVbSOelhXk"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--CGWEWjkHSbj3p5R9HEfANwduVbSOelhXk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/08/13 15:05, Archit Taneja wrote:
> On Monday 05 August 2013 02:41 PM, Tomi Valkeinen wrote:

>> There's quite a bit of code in these dump functions, and they are alwa=
ys
>> called. I'm sure getting that data is good for debugging, but I presum=
e
>> they are quite useless for normal use. So I think they should be
>> compiled in only if some Kconfig option is selected.
>=20
> Won't pr_debug() functions actually print something only when
> CONFIG_DYNAMIC_DEBUG is selected or if the DEBUG is defined? They will

If DEBUG is defined, they are always printed. If dynamic debug is in
use, the user has to enable debug prints for VPE for the dumps to be
printed.

> still consume a lot of code, but it would just end up in dummy printk
> calls, right?

Yes.

Well, I don't know VPE, so I can't really say how much those prints are
needed or not. They just looked very verbose to me.

I think we should have "normal" level debugging messages compiled in by
default, and for "verbose" there should be a separate compile options.
With verbose I mean something that may be useful if you are changing the
code and want to verify it or debugging some very odd bug. I.e. for the
developer of the driver.

And with normal something that would be used when, say, somebody uses
VPE for in his app, but things don't seem to be quite right, and there's
need to get some info on what is going on. I.e. for "normal" user.

But that's just my opinion, and it's obviously difficult to define those
clearly =3D). To be honest, I don't know how much overhead very verbose
kernel debug prints even cause. Maybe it's negligible.

>>> +/*
>>> + * data transfer descriptor
>>> + *
>>> + * All fields are 32 bits to make them endian neutral
>>
>> What does that mean? Why would 32bit fields make it endian neutral?
>=20
>=20
> Each 32 bit field describes one word of the data descriptor. Each
> descriptor has a number of parameters.
>=20
> If we look at the word 'xfer_length_height'. It's composed of height
> (from bits 15:0) and width(from bits 31:16). If the word was expressed
> using bit fields, we can describe the word(in big endian) as:
>=20
> struct vpdma_dtd {
>     ...
>     unsigned int    xfer_width:16;
>     unsigned int    xfer_height:16;
>     ...
>     ...
> };
>=20
> and in little endian as:
>=20
> struct vpdma_dtd {
>     ...
>     unsigned int    xfer_height:16;
>     unsigned int    xfer_width:16;
>     ...
>     ...
> };
>=20
> So this representation makes it endian dependent. Maybe the comment
> should be improved saying that usage of u32 words instead of bit fields=

> prevents endian issues.

No, I don't think that's correct. Endianness is about bytes, not 16 bit
words. The above text doesn't make much sense to me.

I haven't really worked with endiannes issues, but maybe __le32 and
others should be used in the struct, if that struct is read by the HW.
And use cpu_to_le32() & others to write those. But googling will
probably give more info (I should read also =3D).

>>> + */
>>> +struct vpdma_dtd {
>>> +    u32            type_ctl_stride;
>>> +    union {
>>> +        u32        xfer_length_height;
>>> +        u32        w1;
>>> +    };
>>> +    dma_addr_t        start_addr;
>>> +    u32            pkt_ctl;
>>> +    union {
>>> +        u32        frame_width_height;    /* inbound */
>>> +        dma_addr_t    desc_write_addr;    /* outbound */
>>
>> Are you sure dma_addr_t is always 32 bit?
>=20
> I am not sure about this.

Is this struct directly read by the HW, or written to HW? If so, I
believe using dma_addr_t is very wrong here. Having a typedef like
dma_addr_t hides the actual type used for it. So even if it currently
would always be 32bit, there's no guarantee.

>>
>>> +    };
>>> +    union {
>>> +        u32        start_h_v;        /* inbound */
>>> +        u32        max_width_height;    /* outbound */
>>> +    };
>>> +    u32            client_attr0;
>>> +    u32            client_attr1;
>>> +};
>>
>> I'm not sure if I understand the struct right, but presuming this one
>> struct is used for both writing and reading, and certain set of fields=

>> is used for writes and other set for reads, would it make sense to hav=
e
>> two different structs, instead of using unions? Although they do have
>> many common fields, and the unions are a bit scattered there, so I don=
't
>> know if that would be cleaner...
>=20
> It helps in a having a common debug function, I don't see much benefit
> apart from that. I'll see if it's better to have them as separate struc=
ts.

Ok. Does the struct have any bit or such that tells us if the current
data is inbound or outbound?

 Tomi



--CGWEWjkHSbj3p5R9HEfANwduVbSOelhXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR/6KxAAoJEPo9qoy8lh71j8oP/RJg7xux9QWotOGKMl26SdOY
aSigh6wg4HmJqWkjEZBVUf9Ey12L/yxvtSCPzDxRWNOmbmDhjCiSWMJxzx/pEDpw
sf5Vg0z1lpqI4Pj+5zdXkeUNEFhYCnGF+8xaH0qeul5jAeE1LwvflDDP6z4PFeWA
rCxrDOy8GpYCEhQwrWjL0XY4vysIWodXY2erru0grGrSBXhMEbWrOumuZUGt5b+X
xwx6B62Fc0f94ajFSp6/MSEhqkdVHQeNl6gJf8gGHzCGK74fgFFDHgN3AfxZW99Z
MDFrtlXEaPCSyNwTVRB27dML3ijc2sArY59bHaWRpy/cUDvGEz+muj/nOSLre+cK
dZ+2gGJNwdIOjJi/NCdI1V9dkhAgmB5MQcFgPwjTnyDPr8/4xU74bUd0iTIPQ7IL
aAwNR+W9eV9OGOiDhuBm68NANmAGcG9Ywp9o5PcCBUeZpUPvuEZX1VCo2224SCSf
yc69gUXW3ox//gR0MsDjukaMrQeWZuDBx4ixy4Cy0DPDKivAydewyO3E5+ghM6p9
x4lqgtZS25ml6+IltMjjKwCDPrekH3dGMC2Ot22/dZeJ7WiLfwBxPX/zCgz4TzCE
9yowmwWj+SK2CIaCHFYrRYd5ExICvggXuSJROmmzjDRD8EVMxquVFsMeuZlXbBg1
djalJWYNhywAqgAcaN4j
=pNLN
-----END PGP SIGNATURE-----

--CGWEWjkHSbj3p5R9HEfANwduVbSOelhXk--
