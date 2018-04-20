Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:50890 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeDTQt2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 12:49:28 -0400
Date: Fri, 20 Apr 2018 17:48:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] arm: renesas: Change platform dependency to
 ARCH_RENESAS
Message-ID: <20180420164811.GC22369@sirena.org.uk>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2018 at 03:28:26PM +0200, Geert Uytterhoeven wrote:

> The first 6 patches can be applied independently by subsystem
> maintainers.
> The last two patches depend on the first 6 patches, and are thus marked
> RFC.

Would it not make sense to try to apply everything en masse rather than
delaying?  I'm happy to apply the subsystem stuff but if it gets things
done quicker or more efficiently I'm also happy to have the lot merged
as one series.

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlraGcoACgkQJNaLcl1U
h9Dwjgf/Q07mk2IWEt7VXFh08KoOEpJEqv82iu1CWXLrjf83nqwrtopuQeod7ep3
mYoWaxwFLG+wRiICbiVvZf1E9oyGm+sd/IceJnV/6vjTX3iAS//6hUZelNkyAjNj
uvj3C3aGO+8n95ziwDEe579wVzhbzf1fNJKuXHavLmvN7Zo0q0J0Z/UcOku5bvIu
cA6uuY4IiNLgq4b2Boe1YKLb4GFrzAMsBSCtrDwhKYPuepVHFN0U9yXjKHPUj9hd
a/0SUXkvRlTTASH/rNZ/izVWymAudG+HJu4bbCuubieJZ2lZ8G3NL2TviyP9O+ql
35zxtbJRtGQ/uHkqH44QJFZmUoDoNQ==
=z1T8
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
