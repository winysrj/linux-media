Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45429 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab2K2Pxu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 10:53:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Te6R1-00022v-WC
	for linux-media@vger.kernel.org; Thu, 29 Nov 2012 16:53:56 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 16:53:55 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 16:53:55 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: ivtv driver inputs randomly "block"
Date: Thu, 29 Nov 2012 10:53:32 -0500
Message-ID: <50B784FC.1080904@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org> <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com> <50B60D54.4010302@interlinx.bc.ca> <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com> <50B69C08.7050401@interlinx.bc.ca> <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com> <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8256BA94AF926E22DA7C775B"
In-Reply-To: <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8256BA94AF926E22DA7C775B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-29 10:29 AM, Ezequiel Garcia wrote:
> Hi Brian,

Hi Garcia,

> Mmm, the log shows this repeating pattern:
>=20
> ---
> Nov 28 17:54:46 cmurrell kernel: [878779.229702] ivtv0:  info: Setup
> VBI start 0x002fea04 frames 4 fpi 1
> Nov 28 17:54:46 cmurrell kernel: [878779.233129] ivtv0:  info: PGM
> Index at 0x00180150 with 400 elements
> Nov 28 17:54:47 cmurrell kernel: [878779.556039] ivtv0 encoder MPG:
> VIDIOC_ENCODER_CMD cmd=3D0, flags=3D0
> Nov 28 17:54:49 cmurrell kernel: [878782.059204] ivtv0:  ioctl:
> V4L2_ENC_CMD_STOP
> Nov 28 17:54:49 cmurrell kernel: [878782.059209] ivtv0:  info: close
> stopping capture
> Nov 28 17:54:49 cmurrell kernel: [878782.059214] ivtv0:  info: Stop Cap=
ture
> Nov 28 17:54:51 cmurrell kernel: [878784.156135] ivtv0 encoder MPG:
> VIDIOC_ENCODER_CMD cmd=3D1, flags=3D1
> Nov 28 17:54:51 cmurrell kernel: [878784.166157] ivtv0:  ioctl:
> V4L2_ENC_CMD_START
> Nov 28 17:54:51 cmurrell kernel: [878784.166165] ivtv0:  info: Start
> encoder stream encoder MPG

Yes, as I indicated.

> And from 15:00 to 18:00 recording fails?

Yes.

> Perhaps it would make sense to restart application upon driver failure,=

> now that output is more verbose.

Meaning what exactly?  Restart MythTV?  How would I restart MythTV when
the failure occurs?  Do you mean like having a daemon watching dmesg
that restarts MythTV when this happens?  That's a very ugly hack-around
that will have negative side effects per below...

This failure doesn't necessarily affect all tuners at the same time so I
would potentially be restarting MythTV while other tuners are recording,
interrupting good recordings to fix one tuner which is having a problem.

I am sure you would agree that this is not really a suitable
work-around, yes?

> PS: Please don't drop linux-media list from Cc

I don't think I did.  All of my messages have been copied to the list,
albeit I post them through gmane rather than posting to the list
directly since I read via gmane and am not a direct subscriber to the
list.  Most lists will disallow postings by non-subscribers.  I know
vger.kernel.org does allow posting by non-subscribers on at least some
of their lists but I am not aware of it being a site-wide policy or not
so to be on the safe side I just let gmane post it to the list.

Perhaps you got the copy I CC'd to you directly before you got the copy
that went to the list via gmane.

Cheers,
b.




--------------enig8256BA94AF926E22DA7C775B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC3hPwACgkQl3EQlGLyuXBt4ACgtJw35xGNOGHa9sXCLUzbgIqL
KewAoO/jNdP38hpTR78EiGigVb1sQA+t
=PNbI
-----END PGP SIGNATURE-----

--------------enig8256BA94AF926E22DA7C775B--

