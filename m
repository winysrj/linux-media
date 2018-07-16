Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:35285 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730828AbeGPIzz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 04:55:55 -0400
Date: Mon, 16 Jul 2018 10:29:29 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
Message-ID: <20180716082929.GM8180@w540>
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
 <20180711072148.GH8180@w540>
 <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
 <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
 <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Content-Disposition: inline
In-Reply-To: <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,
   thanks for keep testing it

On Sat, Jul 14, 2018 at 01:02:32PM -0700, Steve Longerbeam wrote:
>
>
> On 07/14/2018 12:41 PM, Steve Longerbeam wrote:
> >Hi Jacopo,
> >
> >
> >On 07/14/2018 11:57 AM, Steve Longerbeam wrote:
> >>Hi Jacopo,
> >>
> >>Pardon the late reply, see below.
> >>
> >>On 07/11/2018 12:21 AM, jacopo mondi wrote:
> >>>Hi Steve,
> >>>
> >>>On Tue, Jul 10, 2018 at 02:10:54PM -0700, Steve Longerbeam wrote:
> >>>>Hi Jacopo,
> >>>>
> >>>>Sorry to report my testing on SabreSD has same result
> >>>>as last time. This series fixes the LP-11 timeout at stream
> >>>>on but captured images are still blank. I tried the 640x480
> >>>>mode with UYVY2X8. Here is the pad config:
> >>>This saddens me :(
> >>>
> >>>I'm capturing with the same format and sizes... this shouldn't be the
> >>>issue
> >>>
> >>>Could you confirm this matches what you have in your tree?
> >>>5dc2c80 media: ov5640: Fix timings setup code
> >>>b35e757 media: i2c: ov5640: Re-work MIPI startup sequence
> >>>3c4a737 media: ov5640: fix frame interval enumeration
> >>>41cb1c7 media: ov5640: adjust xclk_max
> >>>c3f3ba3 media: ov5640: add support of module orientation
> >>>ce85705 media: ov5640: add HFLIP/VFLIP controls support
> >>>8663341 media: ov5640: Program the visible resolution
> >>>476dec0 media: ov5640: Add horizontal and vertical totals
> >>>dba13a0 media: ov5640: Change horizontal and vertical resolutions name
> >>>8f57c2f media: ov5640: Init properly the SCLK dividers
> >>
> >>Yes, I have that commit sequence.
> >>
> >>FWIW, I can verify what Jagan Teki reported earlier, that the driver
> >>still
> >>works on the SabreSD platform at:
> >>
> >>dba13a0 media: ov5640: Change horizontal and vertical resolutions name
> >>
> >>and is broken at:
> >>
> >>476dec0 media: ov5640: Add horizontal and vertical totals
> >>
> >>with LP-11 timeout at the mipi csi-2 receiver:
> >>
> >>[=C2=A0=C2=A0 80.763189] imx6-mipi-csi2: LP-11 timeout, phy_state =3D 0=
x00000230
> >>[=C2=A0=C2=A0 80.769599] ipu1_csi1: pipeline start failed with -110
> >
> >And I discovered the bug in 476dec0 "media: ov5640: Add horizontal and
> >vertical totals". The call to ov5640_set_timings() needs to be moved
> >before the
> >calls to ov5640_get_vts() and ov5640_get_hts(). But I see you have
> >discovered
> >that as well, and fixed in the second patch in your series.
> >

I'm sorry I'm not sur I'm following. Does this mean that with that bug
you are referring to up here fixed by my last patch you have capture
working?

Thanks
   j

>
> But strangely, if I revert to 476dec0, and then move the call to
> ov5640_set_timings()
> to just after ov5640_load_regs() in ov5640_set_mode_exposure_calc() and
> ov5640_set_mode_direct(), the LP-11 timeouts are still present. So I can
> confirm
> this strangeness which you already pointed out below [1].
>
>
> >
> >>
> >>>
> >>>>
> >>>>>
> >>>>>The version I'm sending here re-introduces some of the timings
> >>>>>parameters in the
> >>>>>initial configuration blob (not in the single mode ones), which
> >>>>>apparently has
> >>>>>to be at least initially programmed to allow the driver to later
> >>>>>program them
> >>>>>singularly in the 'set_timings()' function. Unfortunately I do not
> >>>>>have a real
> >>>>>rationale behind this which explains why it has to be done this
> >>>>>way :(
> >>>>>
>
> [1] here :)
>
> Steve
>
>

--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbTFdpAAoJEHI0Bo8WoVY8LIIQAL14/2n5sTHJVycfaK3db19q
qsJcuCN09761yNIeHXM/41ZD4OzXgSu6zXhOr1wAYlL/erLTrjPwc12Pe3yLwPEK
cAzvwMPQ317PbGKFtWdnC2iB8HDP6wATvgj5YuVZtTHlSFIAIO2kKFHMWXHR9QbA
cclkFXTkC5/J2HXw77OqkDIRyiCmeR57LoHCo5hwSQqIE70qY8j+DojdrbBQnEvu
pb9cAThP2XuKQ4K2wtYShGO52n8FhJvke+hG4qTE4xT0RjDF+rpd2qyxecCkF4vb
WHfM97Vssldbx9cSK0zzD125gIxsYwPaT8Z8DvyQETeBV0LA+VQmU1OeNvKm3c4d
mJYVv4RWI8iaRQH5GxubTtPJYxOSzd80dLppoHp7cpYtvKFrIV0OtWQ9h54ZT7Iv
GwUaEXRlJHl9vJztW/4mmg2tSdc51An7cn9TFn04SCQaB6CaLlZrDRGDcENN0tSS
3q4GRXm9gdfEYJwemXo7HxegINvu4K0/S+GokBXfcm9cWWdlVaLuMBKKaC8b5a9B
7UyONYNIkJK/HaPiGsvvbnHo28au4DvUKczc89FuJFguSXi5/JP+9ReQa0ABJf0K
n2+t3m4q4q3oyhXHo8tXIChZ+khxeIep6kDLdJ6QdQeD3hD89yF6XLeChzLNI7IF
xGkACQwi7jtih0F2FMnU
=FqFY
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
