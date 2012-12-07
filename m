Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44947 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2LGIuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Dec 2012 03:50:12 -0500
Message-ID: <50C1ADAC.2080403@ti.com>
Date: Fri, 7 Dec 2012 10:49:48 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <linux-fbdev@vger.kernel.org>, David Airlie <airlied@linux.ie>,
	<devicetree-discuss@lists.ozlabs.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	<dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCHv15 2/7] video: add display_timing and videomode
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de> <1353920848-1705-3-git-send-email-s.trumtrar@pengutronix.de> <50B36286.7010704@ti.com> <20121126153958.GA30791@pengutronix.de> <20121206100718.C5C263E0EA4@localhost>
In-Reply-To: <20121206100718.C5C263E0EA4@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9CEB17DFA3B7CC555C12C4B7"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig9CEB17DFA3B7CC555C12C4B7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-06 12:07, Grant Likely wrote:
> On Mon, 26 Nov 2012 16:39:58 +0100, Steffen Trumtrar <s.trumtrar@pengut=
ronix.de> wrote:
>> On Mon, Nov 26, 2012 at 02:37:26PM +0200, Tomi Valkeinen wrote:
>>> On 2012-11-26 11:07, Steffen Trumtrar wrote:
>>>
>>>> +/*
>>>> + * Subsystem independent description of a videomode.
>>>> + * Can be generated from struct display_timing.
>>>> + */
>>>> +struct videomode {
>>>> +	u32 pixelclock;		/* pixelclock in Hz */
>>>
>>> I don't know if this is of any importance, but the linux clock framew=
ork
>>> manages clock rates with unsigned long. Would it be better to use the=

>>> same type here?
>>>
>>
>> Hm, I don't know. Anyone? u32 should be large enough for a pixelclock.=

>=20
> 4GHz is a pretty large pixel clock. I have no idea how conceivable it i=
s
> that hardware will get to that speed. However, if it will ever be
> larger, then you'll need to account for that in the DT binding so that
> the pixel clock can be specified using 2 cells.

I didn't mention the type because of the size of the field, but only
because to me it makes sense to use the same type for clock rates all
around the kernel. In many cases the value will be passed to clk_set_rate=
().

I can't see any real issues with u32, though.

 Tomi



--------------enig9CEB17DFA3B7CC555C12C4B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQwa2sAAoJEPo9qoy8lh71pC0P/jCcHcXSVdXCy26V/ZjkV4kj
s11XdvLyA8ozI6WRGbkpIhaX2iPkS59DMJqwa4W23J16yUy+wVOa7kWSSmFFD5sf
X7oU7Ac2DpqJ+X9Lg23GHDfZ3343lnNQRYWjM5sp68zZfUi0OkbAPviAvMv06tzi
SQn/GCMXlFMKunfNRgxRjTzAdJfEaJrmZEMXftR/M5OXrUawnoAFIGFEjdNuGrbp
iCcb4POx8pJgqY0k1kULoMTeper1hMDUpfIphKedUMtSMRvFaFo3LfSH9tFIPCgd
EksXy38XpJygJMfyVQudvaTF+ryYaKkNT+ouRdhslvPkzaAeZxm2Mbl3idJy6GKa
RrsCpwtIcdBx/rrUam4pv5NAHMpkLP432Q8IWlcYexQN/ZUbOOORCQi8yluURcFC
rfAFFmKQNrQ+s1XYA8drJRW8LMgMJ5jlZvL97zRcpIZWLB/oYfKj0p432SOPufNm
Lrze0PxtoucJ92KLpW+akS/nrPPkhfjuXRepjdX5J762JUpwnVdOfCg9aUKmpW9/
bRUed5rOdGhPyKOcjCYiJGAaVt0EDLZ8M5GxMsWpQ8JQccQYuKYqldWKPtrr5Ac6
2GRZDHrf5aG9mrsFbpN/XMp3dENTetGNhvXA5IfU1aR5Z1FDDZtFTgYc8RwO5wxe
5ADwylE9JJgYzU9HR+58
=pisc
-----END PGP SIGNATURE-----

--------------enig9CEB17DFA3B7CC555C12C4B7--
