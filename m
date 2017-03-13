Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36506 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdCMNWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 09:22:23 -0400
Date: Mon, 13 Mar 2017 13:21:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Laura Abbott <labbott@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>, linux-mm@kvack.org
Message-ID: <20170313132150.324h7em7c3iowmwj@sirena.org.uk>
References: <20170303132949.GC31582@dhcp22.suse.cz>
 <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
 <20170306074258.GA27953@dhcp22.suse.cz>
 <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
 <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
 <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
 <CA+M3ks77Am3Fx-ZNmgeM5tCqdM7SzV7rby4Es-p2F2aOhUco9g@mail.gmail.com>
 <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com>
 <CA+M3ks6R=n4n54wofK7pYcWoQKUhzyWQytBO90+pRDRrAhi3ww@mail.gmail.com>
 <20170313105433.GA12980@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jmd3p5wa7z2gqxvc"
Content-Disposition: inline
In-Reply-To: <20170313105433.GA12980@e106950-lin.cambridge.arm.com>
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jmd3p5wa7z2gqxvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 13, 2017 at 10:54:33AM +0000, Brian Starkey wrote:
> On Sun, Mar 12, 2017 at 02:34:14PM +0100, Benjamin Gaignard wrote:

> > Another point is how can we put secure rules (like selinux policy) on
> > heaps since all the allocations
> > go to the same device (/dev/ion) ? For example, until now, in Android
> > we have to give the same
> > access rights to all the process that use ION.
> > It will become problem when we will add secure heaps because we won't
> > be able to distinguish secure
> > processes to standard ones or set specific policy per heaps.
> > Maybe I'm wrong here but I have never see selinux policy checking an
> > ioctl field but if that
> > exist it could be a solution.

> I might be thinking of a different type of "secure", but...

> Should the security of secure heaps be enforced by OS-level
> permissions? I don't know about other architectures, but at least on
> arm/arm64 this is enforced in hardware; it doesn't matter who has
> access to the ion heap, because only secure devices (or the CPU
> running a secure process) is physically able to access the memory
> backing the buffer.

> In fact, in the use-cases I know of, the process asking for the ion
> allocation is not a secure process, and so we wouldn't *want* to
> restrict the secure heap to be allocated from only by secure
> processes.

I think there's an orthogonal level of OS level security that can be
applied here - it's reasonable for it to want to say things like "only
processes that are supposed to be implementing functionality X should be
able to try to allocate memory set aside for that functionality".  This
mitigates against escallation attacks and so on, it's not really
directly related to secure memory as such though.

--jmd3p5wa7z2gqxvc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAljGnO0ACgkQJNaLcl1U
h9ADTgf/cen1KJxzB5DyzPjdff5+hLmkjHDPrpZVfe7FMCTp8wYRsf1OHGAMsHx0
KsoTEdpQmt6ao4EEQGYPZWs1VSYE12tXejBGQJ0Av8duNXg1BUUUnLJi+xz/sIGb
tDX3trnLxByCfqFdZEtXuFpErBUtyt3tv5nrcLYzWFcgWaK+Xuf+5WsPZ4McTJCF
KK7j22M9qZ5J/0C/DyTM2H8EaBb6NjSDfDBnydDYCzYrf+YkxwAdcj8qta9toRyV
qfBVsD/kkx8dHPPYZG+WXeQCzkQPoluN94P2cN2Ni990mzSAKtgS8maXRJ9MRUBV
5F4uW1syDtEsiZPAdFPeC/ZXISn65g==
=C/hC
-----END PGP SIGNATURE-----

--jmd3p5wa7z2gqxvc--
