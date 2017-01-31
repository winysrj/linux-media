Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:51354 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbdAaSai (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 13:30:38 -0500
From: Eric Anholt <eric@anholt.net>
To: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: bcm2835-v4l2: Apply spelling fixes from checkpatch.
In-Reply-To: <1485826718.20550.14.camel@perches.com>
References: <20170127215503.13208-1-eric@anholt.net> <20170127215503.13208-7-eric@anholt.net> <1485556233.12563.142.camel@perches.com> <87inowfh55.fsf@eliezer.anholt.net> <1485826718.20550.14.camel@perches.com>
Date: Tue, 31 Jan 2017 10:30:12 -0800
Message-ID: <87k29b84ln.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Joe Perches <joe@perches.com> writes:

> On Mon, 2017-01-30 at 12:05 -0800, Eric Anholt wrote:
>> Joe Perches <joe@perches.com> writes:
>>=20
>> > On Fri, 2017-01-27 at 13:55 -0800, Eric Anholt wrote:
>> > > Generated with checkpatch.pl --fix-inplace and git add -p out of the
>> > > results.
>> >=20
>> > Maybe another.
>> >=20
>> > > diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/d=
rivers/staging/media/platform/bcm2835/mmal-vchiq.c
>> >=20
>> > []
>> > > @@ -239,7 +239,7 @@ static int bulk_receive(struct vchiq_mmal_instan=
ce *instance,
>> > >  		pr_err("buffer list empty trying to submit bulk receive\n");
>> > >=20=20
>> > >  		/* todo: this is a serious error, we should never have
>> > > -		 * commited a buffer_to_host operation to the mmal
>> > > +		 * committed a buffer_to_host operation to the mmal
>> > >  		 * port without the buffer to back it up (underflow
>> > >  		 * handling) and there is no obvious way to deal with
>> > >  		 * this - how is the mmal servie going to react when
>> >=20
>> > Perhaps s/servie/service/ ?
>>=20
>> I was trying to restrict this patch to just the fixes from checkpatch.
>
> That's the wrong thing to do if you're fixing
> spelling defects.  checkpatch is just one mechanism
> to identify some, and definitely not all, typos and
> spelling defects.
>
> If you fixing, fix.  Don't just rely on the brainless
> tools, use your decidedly non-mechanical brain.

"if you touch anything, you must fix everything."  If that's how things
work, I would just retract the patch.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAliQ17QACgkQtdYpNtH8
nugnbQ//TKK6m8Py5H3om5vv5EQMSc9Yt07t8Q3BI2TAtzrpfzFu8Z2uxv2ugV/t
nfm3M+VhYRgYmH335I0R/LlDhjbYoKldL604ywuLazgCsmRvWckHz7slr8cKEryv
R4GkNC6jOjO9p7oG9U9Zz914qn2nM2gKNgEUqUcZmfP8T9RcqcbvwYpS6vtwCP3L
Kb4Ji/4OJO0AV4WQenFyhc8iyizY2/6nB+bkqHq6Isc4P7W3w6Y/NuZwc9JBTgbj
pjglj12a9axEIsmJSx1qiyk27J96QH0SRQsm9NHqSSXqPgmbkOIKgYFcSeG0uBdC
rdMQikHOThFSO4/eh3vEwth5fphaM24WPHo3tV73jfsMJtqYMwpEhhQN4UUZywe3
zWWTztk/LObWwnVDqiB2cdYZSSzx8Qqu6ghsB2kWwum95y/yhabMITiLTF3cnlov
/pjIpdsfPEi7ec6xr5eyNZSXTl0wEu8IkohYsSEVPEgB6G4ekWV9tB135ZNQ7ZvI
ri6NRLXORa8Q148G+Zz2LjejHR/WY5zGCzAAiKVh4vaxxMgnF1ZAbv/RwxXVSz9u
b5THE+8CilWuyMV2zayNghituNR3I7oZ0ifUQiKyAZdnwswatEu6UDLkGnu6ITNH
UvRB4dDVjVRNjZ8B8E/3v+1/iA1J46NyCqAezoRuBltQ09aM0xU=
=mPEB
-----END PGP SIGNATURE-----
--=-=-=--
