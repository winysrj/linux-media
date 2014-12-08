Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:5405 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaLHQNz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 11:13:55 -0500
Message-ID: <5485CE40.7010905@imgtec.com>
Date: Mon, 8 Dec 2014 16:13:52 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>, <stable@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [REVIEW PATCH 1/2] img-ir/hw: Avoid clearing filter for no-op
 protocol change
References: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com> <1417438510-18977-2-git-send-email-james.hogan@imgtec.com> <20141204153814.00a1a5ec.m.chehab@samsung.com>
In-Reply-To: <20141204153814.00a1a5ec.m.chehab@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="b3pxjA9oD9pGREOVc7DIBa1uP8LrrG4GN"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--b3pxjA9oD9pGREOVc7DIBa1uP8LrrG4GN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On 04/12/14 17:38, Mauro Carvalho Chehab wrote:
> Em Mon, 1 Dec 2014 12:55:09 +0000
> James Hogan <james.hogan@imgtec.com> escreveu:
>=20
>> When the img-ir driver is asked to change protocol, if the chosen
>> decoder is already loaded then don't call img_ir_set_decoder(), so as
>> not to clear the current filter.
>>
>> This is important because store_protocol() does not refresh the scanco=
de
>> filter with the new protocol if the set of enabled protocols hasn't
>> actually changed, but it will still call the change_protocol() callbac=
k,
>> resulting in the filter being disabled in the hardware.
>>
>> The problem can be reproduced by setting a filter, and then setting th=
e
>> protocol to the same protocol that is already set:
>> $ echo nec > protocols
>> $ echo 0xffff > filter_mask
>> $ echo nec > protocols
>>
>> After this, messages which don't match the filter still get received.
>=20
> This should be fixed at the RC core, as this is not driver-specific.

Yes, you're right. I've fixed there and attempted backporting, and the
problem appears to have actually been introduced in commit da6e162d6a46
("[media] rc-core: simplify sysfs code") which went into v3.17.

I'll send a v2.

Thanks
James

>=20
> Regards,
> Mauro


--b3pxjA9oD9pGREOVc7DIBa1uP8LrrG4GN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhc5BAAoJEGwLaZPeOHZ61ksQAIaZx7c3KCN9jVsl9L2sZ+dq
Q1EMV0xyyRZawp8B7GUeMjCC/kq98kL6nR4XF0HGegZz964s29nHNebHVofX9az7
95ySJIoefAt9wlw1pnlKu/v8bxIdrXCSC66SUYY+lB1fBvN8A5gdal4ypTTmbjKG
tjv8a3bFv8YWexCSEdTZ5rgL/7p6UM63J/MaaAJK5rNscdAO8y1Km7RO2yAHEYW5
krRu/n9+kLrPhImst9W90SdGAHwKPTjyPD/ESMipoaUhYshrvGt2hwKdifxPBGJJ
70rJi/3JYpspEayIh0JRkb6dDZRIWi153xaU2OqZ4mmnRfKVaN1etZLL2610hNe8
c6Rxe6UXRwDiFg3vS7xD7cxRIPv3CntJg+/vmZRgylhGBM8ovmo4iG3km+1tLf4O
791Wt0gC36bKz8Y+9fpQNnjdpFXynyJJ0YIKuFfF1IWn8+ycRcsbVtizFyKcmCP6
IWWbpzpheJ4IQ3tUvNsliNGUlMGDyScdJOaPftZWY8h6Sna/+TnMYU2WG//81qvm
+jQX99bnZ8dg9tyl7pk3TLMml+3NbKEVPLoKYtMCoFIaiGVNP71gLcot+mz6ES4s
YeQGMy9scS/dxtR/C7LZUmkDpozSiXty3HTA6pvTS+zj4yu7EQ9YwM0YpuU84o/U
FtrwzkEnPh6CJAlWOpsL
=i7gd
-----END PGP SIGNATURE-----

--b3pxjA9oD9pGREOVc7DIBa1uP8LrrG4GN--
