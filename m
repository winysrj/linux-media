Return-path: <linux-media-owner@vger.kernel.org>
Received: from [90.185.159.143] ([90.185.159.143]:36181 "EHLO
	cow.netcompartner.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372AbZIGELf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Sep 2009 00:11:35 -0400
Received: from [218.111.43.50] (helo=ncpws04.localnet)
	by cow.netcompartner.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <lth@cow.dk>)
	id 1MkUxe-00018N-7e
	for linux-media@vger.kernel.org; Mon, 07 Sep 2009 05:32:19 +0200
From: Lars Boegild Thomsen <lth@cow.dk>
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-1200 - CX23885 - S-Video capture
Date: Mon, 7 Sep 2009 11:31:26 +0800
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1801923.iUODcCTqC6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909071131.32045.lth@cow.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1801923.iUODcCTqC6
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have been struggling with Linux drivers for the above mentioned card.=20
Doing an lspci -v reports:

03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 02)
        Subsystem: Hauppauge computer works Inc. Device 71d3
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at ef800000 (64-bit, non-prefetchable) [size=3D2M]
        Capabilities: [40] Express Endpoint, MSI 00
        Capabilities: [80] Power Management version 2
        Capabilities: [90] Vital Product Data
        Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885

I have been googling a lot and I am somewhat confused if the current drivers
supports video capture on the S-Video connector.  Most mailing list entries
say that only digital capture is possible, however I did notice some
changes in the cx23885-cards.c:

        [CX23885_BOARD_HAUPPAUGE_HVR1200] =3D {
                .name           =3D "Hauppauge WinTV-HVR1200",
                .portc          =3D CX23885_MPEG_DVB,
                .input          =3D {{
                        .type   =3D CX23885_VMUX_TELEVISION,
                        .vmux   =3D 0,
                        .gpio0  =3D 0xff00,
                }, {
                        .type   =3D CX23885_VMUX_DEBUG,
                        .vmux   =3D 0,
                        .gpio0  =3D 0xff01,
                }, {
                        .type   =3D CX23885_VMUX_COMPOSITE1,
                        .vmux   =3D 1,
                        .gpio0  =3D 0xff02,
                }, {
                        .type   =3D CX23885_VMUX_SVIDEO,
                        .vmux   =3D 2,
                        .gpio0  =3D 0xff02,
                } },
        },

Which sort of indicates that the driver is aware of the connector.  Can
anybody help me what is the current status of this driver/card combination?

So - in short - I am currently only interested in capturing analog video fr=
om the s-video connector (it comes from a satbox).  Is that in any way poss=
ible with this card?

=2D-
Lars

--nextPart1801923.iUODcCTqC6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqkfo8ACgkQeHBusRfrogUI3QCgmI77zWb6toz2Uq3PRavfeslV
tuAAn0IzKviuhbLsZA7pH1d9iwWuevcj
=6T+Q
-----END PGP SIGNATURE-----

--nextPart1801923.iUODcCTqC6--
