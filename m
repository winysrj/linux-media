Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:45461 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHNS3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:29:47 -0400
Date: Tue, 14 Aug 2018 17:41:52 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: "mchehab@kernel.org" <mchehab@kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "sam@elite-embedded.com" <sam@elite-embedded.com>,
        "jagan@amarulasolutions.com" <jagan@amarulasolutions.com>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "pza@pengutronix.de" <pza@pengutronix.de>,
        "steve_longerbeam@mentor.com" <steve_longerbeam@mentor.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "daniel@zonque.org" <daniel@zonque.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/2] media: ov5640: Fix timings setup code
Message-ID: <20180814154152.GA16349@w540>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
 <1531912743-24767-2-git-send-email-jacopo@jmondi.org>
 <f5e1bcf6-a677-441b-eaec-60901811038e@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <f5e1bcf6-a677-441b-eaec-60901811038e@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Hugues,
   I'll reply to your v2 series shortly, but let me point out one
thing before.

+steve

On Tue, Aug 07, 2018 at 08:53:53AM +0000, Hugues FRUCHET wrote:
> Hi Jacopo,
>
> Thanks for this patch, when testing on my side I don't see special
> regression or enhancement with that fix, particularly on image quality
> (exposure, ...),

On imx.6 platforms I need this patch along with the MIPI interface
setup fixes sent here [1] to have capture working.

I messed up a bit, as I've sent the "timings fixes" in two series,
this one I'm replying to and the one I've pasted the link of, even if
those series had two different purposes.

So, this patch in my setup does not fixes an image quality issues, but
instead takes part in solving a problems with MIPI CSI-2 on imx.6
platforms.

I asked Steve Longerbeam to test on his imx.6 platform and he reported
his issues was not fixed and he got blank frames ( I was very
disappointed by the different results we had, but moved on and kept
carrying those patches in my tree, as otherwise MIPI interface failed
to startup).

Now I have asked Steve if he might have blank frames, which might be
an exposure related issue, I never had as I skept the first frames,
which are usually the blank one (you're cc-ed).

I believe too your exposure+gain series should be applied and
should supersed [2/2] of this series, but this timing fix is necessary
for me, and I hope Steve's problem are related to exposure handling
issues your series might fix as it did for me.

> do you have a test procedure that underline the issue ?
> For example on my side when I do 5Mp then QVGA capture, pictures are
> overexposed/greenish:

I do capture with yavta, I usually skept the first 7 frames and then
captured 3. Without exposure fix (my patch or your series) the first
frames are black.

This driver is making our life miserable, isn't it? :)

Thanks
   j

[1] https://www.spinics.net/lists/linux-media/msg137557.html

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbcvhAAAoJEHI0Bo8WoVY8vZIP/jZWMF2Xi998CmqTBtp9fcnc
5jruWUBvbmvncbj5nL6icACQfOCJBC35ywNk4peKMNEEl0nehWWgGM+H1aUN6Bz3
hXCnOdOCOI/sivHd+fktrJt7pI44aaDwitnZQA2U+xlrQbba4elFLKb7YOYDCMtc
cU+VRTTMmkDdRfC2B02V9voNbKxYh+zTA16SK8eAdjsel93CoCZ8lP/jIU6PE6It
AOj0qVadv/tTdUyrKP0xtgyZ+q+d5oei0kQcHW5i+CpZtoNJDpRTibDDIiBP7UW9
6KoDv8Bhx78cB/fArjGr1vSECx8gRWyRtbSIrkqRBSWDSPL9s1LIYJaa3qbHO2B7
FzVopCQhNP/xXcAxwTiAzaLNvLGWOYWOaKivnyf65jyxaQYN87oVWUgMhDosIhmg
LhdWVf10x7SC7jSlmTVAwWW7Jx8ezpjV71bj4KwNOVhjEVLGGhvcj0avD8GMJUmi
ddNTuI1Zxi24paOBvJUYHDVaa34nPni+P3IWoaJDNmbr8N7geuYsM3MrLGzY1KeG
X1CwepgM/DamwiFJMurluiwjDQVTvY/X6HSKAT9JdSOQoESEhxPytxZ3VsHf3qMe
YPN2q8rrrsI2dWB5BdTwK8uMTpo8ctmC10JwHjWmcPRwXT69EV6HGyOWURIRcjgG
DxogRf+lfezT8S9NWodz
=9KA+
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
