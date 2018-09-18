Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34336 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbeIRSs3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 14:48:29 -0400
Received: by mail-it0-f66.google.com with SMTP id x79-v6so14165612ita.1
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 06:15:55 -0700 (PDT)
Received: from eggsbenedict.adamsnet (24-220-35-37-dynamic.midco.net. [24.220.35.37])
        by smtp.gmail.com with ESMTPSA id g10-v6sm6457729iob.88.2018.09.18.06.15.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 06:15:53 -0700 (PDT)
Date: Tue, 18 Sep 2018 09:15:50 -0400
From: Adam Stylinski <kungfujesus06@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: cx23885 - regression between 4.17.x and 4.18.x
Message-ID: <20180918131550.GB28793@eggsbenedict.adamsnet>
References: <47a0c36e-3247-bae4-674d-d8ae7d503a40@unsolicited.net>
 <20180915004236.GA15913@shambles.windy>
 <ecf9e315-7daa-f2af-274f-68e054fa631b@unsolicited.net>
 <20180918131304.GA28793@eggsbenedict.adamsnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20180918131304.GA28793@eggsbenedict.adamsnet>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2018 at 09:13:04AM -0400, Adam Stylinski wrote:
> On Sat, Sep 15, 2018 at 09:30:30AM +0100, David R wrote:
> > Any bisection would take ages, as I need to run for approaching a week
> > to be sure. There are only 3 commits that are possible.
> >=20
> > commit 95f408bbc4e4d46c75da3d2558dd835e56ac7720
> > Author: Brad Love <brad@nextdimension.cc>
> > Date:=A0=A0 Tue May 8 17:20:18 2018 -0400
> >=20
> > =A0=A0=A0 media: cx23885: Ryzen DMA related RiSC engine stall fixes
> >=20
> > commit 3b8315f37d6eaa36f0f2e484eabaef03a7bd1eff
> > Author: Brad Love <brad@nextdimension.cc>
> > Date:=A0=A0 Tue May 8 17:20:17 2018 -0400
> >=20
> > =A0=A0=A0 media: cx23885: Use PCI and TS masks in irq functions
> >=20
> > commit 9a7dc2b064ef7477d4c3a477f4de0a44b3a40cbd
> > Author: Brad Love <brad@nextdimension.cc>
> > Date:=A0=A0 Tue May 8 17:20:16 2018 -0400
> >=20
> > =A0=A0=A0 media: cx23885: Handle additional bufs on interrupt
> >=20
> > Cheers
> > David
> >=20
> > On 15/09/18 01:42, Vincent McIntyre wrote:
> > > On Thu, Sep 13, 2018 at 06:39:57PM +0100, David R wrote:
> > >> Hi
> > >>
> > >> Just a heads up. I'm having to revert cx23885-core.c to the 4.17 ver=
sion
> > >> to obtain stability with my old AMD Phenom/ASUS M4A785TD and Hauppau=
ge
> > >> WinTV-HVR-5525. The latest code drops out and refuses to return video
> > >> streams in hours or a few days max. The 4.17 version is fine and sta=
ble
> > >> over weeks/months.
> > >>
> > >> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23887/8
> > >> PCIe Broadcast Audio and Video Decoder with 3D Comb (rev 04)
> > >> =A0=A0=A0 Subsystem: Hauppauge computer works Inc. Device f038
> > >> =A0=A0=A0 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop=
- ParErr-
> > >> Stepping- SERR+ FastB2B- DisINTx-
> > >> =A0=A0=A0 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >T=
Abort-
> > >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >> =A0=A0=A0 Latency: 0, Cache Line Size: 64 bytes
> > >> =A0=A0=A0 Interrupt: pin A routed to IRQ 17
> > >> =A0=A0=A0 Region 0: Memory at fe800000 (64-bit, non-prefetchable) [s=
ize=3D2M]
> > >> =A0=A0=A0 Capabilities: <access denied>
> > >> =A0=A0=A0 Kernel driver in use: cx23885
> > > Interesting. cx88 also seems to have regressed.
> > > Are you able to give a git commit range for what works & doesn't work?
> > >
> > > I asked Adam to try building the modules with media-build
> > > but have not heard anything further.
> > >
> > >     Date: Sat, 8 Sep 2018 20:49:22 -0400
> > >     From: Adam Stylinski <kungfujesus06@gmail.com>
> > >     To: linux-media@vger.kernel.org
> > >     Subject: 4.18 regression
> > >
> > >     Hello,
> > >
> > >     I haven't done a thorough bisection of kernel revisions, but movi=
ng from kernel 4.17.19
> > >     to 4.18.6 results in mythtv being unable to tune in any channel w=
ith a pic hdtv 5500
> > >     tuner (cx88 based device with an LG frontend). I get an error bac=
k from the channel
> > >     scanner about not being able to measure signal strength and getti=
ng back an error unknown
> > >     (errno 254).
> > >
> > >     I was able to use dvbtools with get-atsc to get a channel, but I =
don't think any of the
> > >     forward error correction was applied to it.
> > >
> > >     Let me know if you need more details.
> > >
> > > Vince
> >=20
> >=20
>=20

For me the issue with my cx88 card happens immediately, most of the command=
s to the card seem to fail.  Unfortunately I build my kernel with this driv=
ers builtin as opposed to modules, so for me to use the 4.17 media branch w=
ith 4.18 I'll need to change my kernel config.  Any instructions on how I s=
hould bisect with this?


--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEDgVoSkwBBLuwA/n/PqxEcTpO+acFAlug+oYACgkQPqxEcTpO
+adHgA/+JITJ5UiSCM3Vcq8CNbskM/j4cL63XCHxrdUt09Ja3XvSJRZlo9Na5EWp
CGFK97iNDtVtSItayDUyb8ZYi6jzprrGyoVsxa2gQtI7nW0w3dFWxgUwpHaj6+l4
8uFqNjuVWLgceiFPlXmK4WNFk2JUIY8V3xMK5mjVdaZc0Sb2qv6/xHEGGRUxeNRY
7KoUgi9ZxItNJe2PtIDcibpNQsp9JTDsEfXwvUO7sIgsjXNbNrY2d7HQvUNq6GHV
VVfAb9o/CcjGqUhSt9zPPSbrnpPDDcpJXMgX+atjVhB9b75cCjY5AcCioP2sHqiz
XkT0UwO9L94dXtFvWs1eSrdKlvYV1whtcGr2dC8yUjF0/pu+uQKYPQeVo6B7nWi/
u9VxkOIHlO6l60y4SgrN4H+Q1TqPuPVlLM0+J9M1/HitDeJFk7/97twRFBOEjrwf
e/eIXCOZ3uFiY51+PfL9X88mCJ4hQd/DNL+md7zlFeSgPAxpwT+yLHLYhk7j/+Fk
VHziTFEAcf+Eg4lGCcGaS1pE643yTIoJe6aHCEsP7KEPXzx9JWWW7oOjwgM880pp
sC/yNA0gAZbzE765LgwPNzykWbb5p/x1FZ2pCmeUJGM5fMRqb+WlhagCdkwxmJJf
YkhhaewKJ4rPuSCCO1C21mbwUWEvBF/wMtvbqDjgLy3NQWe+sc8=
=hpzo
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
