Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34216 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdCNU2G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 16:28:06 -0400
Received: by mail-io0-f174.google.com with SMTP id b140so7503561iof.1
        for <linux-media@vger.kernel.org>; Tue, 14 Mar 2017 13:28:05 -0700 (PDT)
Message-ID: <1489523282.28116.10.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Laura Abbott <labbott@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Linux MM <linux-mm@kvack.org>
Date: Tue, 14 Mar 2017 16:28:02 -0400
In-Reply-To: <CA+M3ks5AyVN1hn=FCRx7sy-3B=VujEBL4G4tWy6opifkKTD8=w@mail.gmail.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
         <20170303132949.GC31582@dhcp22.suse.cz>
         <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
         <20170306074258.GA27953@dhcp22.suse.cz>
         <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
         <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
         <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
         <CA+M3ks77Am3Fx-ZNmgeM5tCqdM7SzV7rby4Es-p2F2aOhUco9g@mail.gmail.com>
         <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com>
         <CA+M3ks6R=n4n54wofK7pYcWoQKUhzyWQytBO90+pRDRrAhi3ww@mail.gmail.com>
         <CAKMK7uH9NemeM2z-tQvge_B=kABop6O7UQFK3PirpJminMCPqw@mail.gmail.com>
         <6d3d52ba-29a9-701f-2948-00ce28282975@redhat.com>
         <CA+M3ks5AyVN1hn=FCRx7sy-3B=VujEBL4G4tWy6opifkKTD8=w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-4yF7GXm+/h6FVvfyggOu"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-4yF7GXm+/h6FVvfyggOu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 14 mars 2017 =C3=A0 15:47 +0100, Benjamin Gaignard a =C3=A9crit=C2=
=A0:
> Should we use /devi/ion/$heap instead of /dev/ion_$heap ?
> I think it would be easier for user to look into one directory rather
> then in whole /dev to find the heaps
>=20
> > is that we don't have to worry about a limit of 32 possible
> > heaps per system (32-bit heap id allocation field). But dealing
> > with an ioctl seems easier than names. Userspace might be less
> > likely to hardcode random id numbers vs. names as well.
>=20
> In the futur I think that heap type will be replaced by a "get caps"
> ioctl which will
> describe heap capabilities. At least that is my understanding of
> kernel part
> of "unix memory allocator" project

I think what we really need from userspace point of view, is the
ability to find a compatible heap for a set of drivers. And this
without specific knowledge of the drivers.

Nicolas
--=-4yF7GXm+/h6FVvfyggOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljIUlIACgkQcVMCLawGqBw6ogCgysy19SbY1BaDre6iIXHMkz5R
SPkAoJIx3dzdLVwHCLbVpFbqLZQL+M+K
=tmAm
-----END PGP SIGNATURE-----

--=-4yF7GXm+/h6FVvfyggOu--
