Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:35218 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbbATJYN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 04:24:13 -0500
Message-ID: <54BE1EBC.2090001@butterbrot.org>
Date: Tue, 20 Jan 2015 10:24:12 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <54BCDE91.90807@xs4all.nl>
In-Reply-To: <54BCDE91.90807@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="w2fbvAh7XVxNVBqiKiK79ku16dUcKQBTv"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w2fbvAh7XVxNVBqiKiK79ku16dUcKQBTv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 19.01.2015 11:38, Hans Verkuil wrote:
> Sorry for the delay.
No problem, thanks for your feedback.

>> Note: I'm intentionally using dma-contig instead of vmalloc, as the US=
B
>> core apparently _will_ try to use DMA for larger bulk transfers.=20
> As far as I can tell from looking through the usb core code it supports=

> scatter-gather DMA, so you should at least use dma-sg rather than dma-c=
ontig.
> Physically contiguous memory should always be avoided.
OK, will this work transparently (i.e. just switch from *-contig-* to
*-sg-*)? If not, can you suggest an example driver to use as template?

> I'm also missing a patch for the Kconfig that adds a dependency on MEDI=
A_USB_SUPPORT
> and that selects VIDEOBUF2_DMA_SG.
Good point, will add that.

>> +err_unreg_video:
>> +	video_unregister_device(&sur40->vdev);
>> +err_unreg_v4l2:
>> +	v4l2_device_unregister(&sur40->v4l2);
>>  err_free_buffer:
>>  	kfree(sur40->bulk_in_buffer);
>>  err_free_polldev:
>> @@ -436,6 +604,10 @@ static void sur40_disconnect(struct usb_interface=
 *interface)
> Is this a hardwired device or hotpluggable? If it is hardwired, then th=
is code is
> OK, but if it is hotpluggable, then this isn't good enough.
It's hardwired. Out of curiosity, what would I have to change for a
hotpluggable one?

>> +	i->type =3D V4L2_INPUT_TYPE_CAMERA;
>> +	i->std =3D V4L2_STD_UNKNOWN;
>> +	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
> Perhaps just say "Sensor" here? I'm not sure what "In-Cell" means.
In-cell is referring to the concept of integrating sensor pixels
directly with LCD pixels, I think it's what Samsung calls it.

Thanks & best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--w2fbvAh7XVxNVBqiKiK79ku16dUcKQBTv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlS+HrwACgkQ7CzyshGvatgSBgCgnY6rVYFYDYvbGmccsANwylWg
daIAoOmkekEYVTsw86kyG+ZtxcECSZVy
=6Yd2
-----END PGP SIGNATURE-----

--w2fbvAh7XVxNVBqiKiK79ku16dUcKQBTv--
