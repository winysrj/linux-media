Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:43399 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965554AbeEYK4r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 06:56:47 -0400
Date: Fri, 25 May 2018 12:56:42 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Tomasz Figa <tfiga@google.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
Message-ID: <20180525105642.GK18369@w540>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
 <20180522200848.GB15035@w540>
 <20180523073833.onxqj72hi23qkz42@paasikivi.fi.intel.com>
 <20180524200738.GD18369@w540>
 <20180524204733.s2ijd3t2izztvjnv@kekkonen.localdomain>
 <CAAFQd5CtOkGmGsixJg1XO-stwY=+DSGdQhR28SieHN-vHfPY9g@mail.gmail.com>
 <20180525071205.GH18369@w540>
 <CAAFQd5Bo3NVNYU=Mbk26u_obiio7h+5avbaom-S5kyThW55uwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qi3SIpffvxS/TM8d"
Content-Disposition: inline
In-Reply-To: <CAAFQd5Bo3NVNYU=Mbk26u_obiio7h+5avbaom-S5kyThW55uwA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qi3SIpffvxS/TM8d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Tomasz,

On Fri, May 25, 2018 at 04:31:07PM +0900, Tomasz Figa wrote:
> On Fri, May 25, 2018 at 4:12 PM jacopo mondi <jacopo@jmondi.org> wrote:
>
> > Hi Tomasz,
>

[snip]

> > > the controls set before powering on will actually be programmed into the
> > > hardware registers.
>
> > Thanks, I had missed that part.
>
> > I quickly tried searching for 's_ctrl' calls in the v4l2-core/ code
> > and I've found nothing that invokes that in response to a streaming
> > start operation. Just if you happen to have any reference handy, could
> > you please point me to that part, just for my better understanding?
>
> The driver does it itself by calling __v4l2_ctrl_handler_setup() from its
> .start_streaming() callback.

Thanks, I'm not sure how I've missed that part. Thanks and sorry for
the fuss!


--qi3SIpffvxS/TM8d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbB+vqAAoJEHI0Bo8WoVY83lMP/3bNTNQxs02G6q6x6YXb5ANM
HMhOzPoB1ZGVmos+OkcsfvpPLcGY0AvuQV2XoV8SNHQQuwxH1hUCYkLq8ISxZVi1
jx+l7d199POEWeno/S1z3vMtg5PHp10134iauqR0Gu3/WXz2BeIWQJbo/bFXaCwd
zs5n/sD5rye739JKW1sKMKjv8fI0pTy4xqq0F1+zOsI+BOuvi5qgC+GUXYzGSNsK
AAcvwuAlsjb/Poipfl00oIWw3gh8L+ZpgygNsrrVhmFJReYilNJJW+zISZTVE/bk
imnzyj9VRLvY4gZdFgyIaaT9Gnl/jt0EKegYtsaYf3UGQmY0/bSzaU3TxdE9qClG
4oDArD8w5OfA75GieMhxfRVgoXY42J6uPF6eREGA6N9gdw40V3JGEjoWWErtZ8kj
U5TO4BkyjJSqMPXL9K5w5NXjqenvdlv3t2efJ/OMYR3S9BQEvz1jbTgN5nV6cEg1
/fQckOEy7Y5xJs4YteTMamCIMv0dRrkLijPol1zDuhr+UApixFNKimVQD0dJlt3L
PrNDGMsDFBdRZxpwaFIWf+bosMEyHVbHHVHGxUVO7gFHWlrHDDKX+abyKtpZQVxe
WLd4WVxPWaPftNGerJNXpCwMkxz0bSMfAoJT0qjDHFUI9eP7BHbas93qIcrIF0b3
FHmIAP8dZ9hQbCLNSvOP
=1bcx
-----END PGP SIGNATURE-----

--qi3SIpffvxS/TM8d--
