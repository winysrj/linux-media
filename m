Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37391 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbeHOLwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 07:52:08 -0400
Date: Wed, 15 Aug 2018 11:00:40 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Message-ID: <20180815090040.GA30013@w540>
References: <20180711072148.GH8180@w540>
 <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
 <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
 <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com>
 <20180716082929.GM8180@w540>
 <71bc3ff6-8db2-af63-f9af-72696f7d075c@gmail.com>
 <20180814153559.GA16428@w540>
 <cd3e2e96-0968-99cd-1417-05ffdd771341@gmail.com>
 <20180814173448.GA25722@w540>
 <dbe7bb65-156a-89a8-4f96-13692fe11d24@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <dbe7bb65-156a-89a8-4f96-13692fe11d24@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Steve,

On Tue, Aug 14, 2018 at 04:53:26PM -0700, Steve Longerbeam wrote:
>
>
> On 08/14/2018 10:38 AM, jacopo mondi wrote:
> >Hi Steve,
> >
> >On Tue, Aug 14, 2018 at 09:51:04AM -0700, Steve Longerbeam wrote:
> >>Hi Jacopo,
> >>
> >>
> >>On 08/14/2018 08:35 AM, jacopo mondi wrote:
> >>>Hi Steve,
> >>>    sorry for resurecting this.
> >>>
> >>><snip>
> >>>>>I'm sorry I'm not sur I'm following. Does this mean that with that bug
> >>>>>you are referring to up here fixed by my last patch you have capture
> >>>>>working?
> >>>>No, capture still not working for me on SabreSD, even after fixing
> >>>>the bug in 476dec0 "media: ov5640: Add horizontal and vertical totals",
> >>>>by either using your patchset, or by running version 476dec0 of ov5640.c
> >>>>with the call to ov5640_set_timings() moved to the correct places as
> >>>>described below.
> >>>>
> >>>I've been reported a bug on exposure handling that makes the first
> >>>captured frames all black. Both me and Hugues have tried to fix the
> >>>issue (him with a more complete series, but that's another topic).
> >>>See [1] and [2]
> >>>
> >>>It might be possible that you're getting blank frames with this series
> >>>applied? I never seen them as I'm skipping the first frames when
> >>>capturing, but I've now tested and without the exposure fixes (either
> >>>[1] or [2]) I actually have blank frames.
> >>>
> >>>If that's the case for you too (which I hope so much) would you be
> >>>available to test again this series with exposure fixes on top?
> >>>On my platform that actually makes all frames correct.
> >>>
> >>>Thanks
> >>>    j
> >>>
> >>>[1] [PATCH 0/2] media: ov5640: Fix set_timings and auto-exposure
> >>>[2] [PATCH v2 0/5] Fix OV5640 exposure & gain
> >>>
> >>It's not clear to me which patch sets you would like me to test.
> >>Just [1] and [2], or [1], [2], and "media: i2c: ov5640: Re-work MIPI startup
> >>sequence"?
> >>
> >I have tested on my board the following:
> >v4.18-rc2 + MIPI Fix + Timings + Hugues' exposure fix
> >
> >Without Hugues' patches I get blank frames (the first ones at least)
> >Without MIPI startup reowkr and timings I get the LP-11 error on the
> >CSI-2 bus.
> >
> >As Hugues' series has to be rebased on mine, I have prepared a branch
> >here for you if you feel like testing it:
> >git://jmondi.org/linux ov5640/timings_exposure
>
> Hi Jacopo, that branch works on SabreSD!
>

YEAH! I'm so happy about this (and not to having asked you to test
yet-another-broken-patchset for no reason :)

> Feel free to add
>
> Tested-by: Steve Longerbeam <slongerbeam@gmail.com>
> on i.MX6q SabreSD with MIPI CSI-2 OV5640 module
>
> to whichever ov5640 patches are appropriate.

Great, I'll send a v3 now collecting your tags and the most recent
version of the timings fix that was not included in v2 (but in the
branch you have tested).

My ideal plan would be to have these two patches merged, then Hugues'
series to fix exposure handling merged on top. This would, in my mind
make capture on CSI-2 work properly.

Of course, more testing is very welcome.

Thanks again
   j

>
> Steve
>
>

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbc+u4AAoJEHI0Bo8WoVY8DLcQALz+jzlYhhC0LLxdA7s6W6yI
dJiVzi5a+Pw7Hzyu7mXd4s/7HpdKOehknDmggin7l5hvXMI4YKjfhsSflTxevcYp
II7TnT9Ridz9b8yCPUFGhI9aoiRCCbHzUXKuUWRqonT+nY3yG7U0ZAJYQTiWqJNz
AJq7ibM683pjTov1pqLj6rPjg3aQ76UzMr9tZ469QzSOWfrfQgWN3/WKYJlW3Jxj
3nwmyFpNRNYxTd904FSfAfs9omrReHbkrCJrmV/AkNr/bCKJAKLD+CxJZ/KJ8Lit
9QL0ctFqDeD9glA5SdHKHoXNo9TglUzbtNVA/BoJpI7T4OBYWWk21tWScCRXcpHe
24MIdusCmu4fVm0093szuQFf99akkvw2dWYNCgdZUo17SMQYUIe/GgOMPrx1U3B8
RTuu22Q/L7QEpFb2fDhPo6fOQ/kUTUx2qWpBv1SKK3LXfr2nMCqOFd198R+9sc6i
qmqSjmwiE529Dmk9JTMT1tFI6CYmfAX8L+vYTZXeZCNtWZKjX/Q2hSl3jYymuBzf
Cb6clh4+jUmYLlqTWjtUGWVPkJxFnSvBrfQjsZAsepxTO1wExtthHhgdoEP1oyqp
FviSwp6Py68ZPiwQqalM5NEUt7AWk7Lvg/+wFgb6cyXtrsTZ5ksqrcgGKBYQwI5z
jZ9Mlmqo0dF/l7gW4nWe
=NeN9
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
