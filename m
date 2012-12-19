Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40100 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab2LSPjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 10:39:02 -0500
Message-ID: <50D1DF42.3070008@ti.com>
Date: Wed, 19 Dec 2012 17:37:38 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>
CC: Jani Nikula <jani.nikula@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1608840.IleINgrx5J@avalon> <87pq28hb72.fsf@intel.com> <1671267.x0lxGrFjjV@avalon> <87pq26ay2z.fsf@intel.com> <CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
In-Reply-To: <CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB79484E5FBA69B58E0AE8B3B"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigB79484E5FBA69B58E0AE8B3B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-19 17:26, Rob Clark wrote:
> On Wed, Dec 19, 2012 at 8:57 AM, Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
>>
>> Hi Laurent -
>>
>> On Tue, 18 Dec 2012, Laurent Pinchart <laurent.pinchart@ideasonboard.c=
om> wrote:
>>> Hi Jani,
>>>
>>> On Monday 17 December 2012 18:53:37 Jani Nikula wrote:
>>>> I can see the need for a framework for DSI panels and such (in fact =
Tomi
>>>> and I have talked about it like 2-3 years ago already!) but what is =
the
>>>> story for HDMI and DP? In particular, what's the relationship betwee=
n
>>>> DRM and CDF here? Is there a world domination plan to switch the DRM=

>>>> drivers to use this framework too? ;) Do you have some rough plans h=
ow
>>>> DRM and CDF should work together in general?
>>>
>>> There's always a world domination plan, isn't there ? :-)
>>>
>>> I certainly want CDF to be used by DRM (or more accurately KMS). That=
's what
>>> the C stands for, common refers to sharing panel and other display en=
tity
>>> drivers between FBDEV, KMS and V4L2.
>>>
>>> I currently have no plan to expose CDF internals to userspace through=
 the KMS
>>> API. We might have to do so later if the hardware complexity grows in=
 such a
>>> way that finer control than what KMS provides needs to be exposed to
>>> userspace, but I don't think we're there yet. The CDF API will thus o=
nly be
>>> used internally in the kernel by display controller drivers. The KMS =
core
>>> might get functions to handle common display entity operations, but t=
he bulk
>>> of the work will be in the display controller drivers to start with. =
We will
>>> then see what can be abstracted in KMS helper functions.
>>>
>>> Regarding HDMI and DP, I imagine HDMI and DP drivers that would use t=
he CDF
>>> API. That's just a thought for now, I haven't tried to implement them=
, but it
>>> would be nice to handle HDMI screens and DPI/DBI/DSI panels in a gene=
ric way.
>>>
>>> Do you have thoughts to share on this topic ?
>>
>> It just seems to me that, at least from a DRM/KMS perspective, adding
>> another layer (=3DCDF) for HDMI or DP (or legacy outputs) would be
>> overengineering it. They are pretty well standardized, and I don't see=

>> there would be a need to write multiple display drivers for them. Each=

>> display controller has one, and can easily handle any chip specific
>> requirements right there. It's my gut feeling that an additional
>> framework would just get in the way. Perhaps there could be more commo=
n
>> HDMI/DP helper style code in DRM to reduce overlap across KMS drivers,=

>> but that's another thing.
>>
>> So is the HDMI/DP drivers using CDF a more interesting idea from a
>> non-DRM perspective? Or, put another way, is it more of an alternative=

>> to using DRM? Please enlighten me if there's some real benefit here th=
at
>> I fail to see!
>=20
> fwiw, I think there are at least a couple cases where multiple SoC's
> have the same HDMI IP block.
>=20
> And, there are also external HDMI encoders (for example connected over
> i2c) that can also be shared between boards.  So I think there will be
> a number of cases where CDF is appropriate for HDMI drivers.  Although
> trying to keep this all independent of DRM (as opposed to just
> something similar to what drivers/gpu/i2c is today) seems a bit
> overkill for me.  Being able to use the helpers in drm and avoiding an
> extra layer of translation seems like the better option to me.  So my
> vote would be drivers/gpu/cdf.

Well, we need to think about that. I would like to keep CDF independent
of DRM. I don't like tying different components/frameworks together if
there's no real need for that.

Also, something that Laurent mentioned in our face-to-face discussions:
Some IPs/chips can be used for other purposes than with DRM.

He had an example of a board, that (if I understood right) gets video
signal from somewhere outside the board, processes the signal with some
IPs/chips, and then outputs the signal. So there's no framebuffer, and
the image is not stored anywhere. I think the framework used in these
cases is always v4l2.

The IPs/chips in the above model may be the exact same IPs/chips that
are used with "normal" display. If the CDF was tied to DRM, using the
same drivers for normal and these streaming cases would probably not be
possible.

 Tomi



--------------enigB79484E5FBA69B58E0AE8B3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQ0d9CAAoJEPo9qoy8lh71B7wP/2lghR1HLlLQmAd+jvePPEHs
KGD4N7NiYJL5B5m7cxrakbf8W/gffUwWBUrZZSTDoUHGN7XFmCmFk5R0X/Snoq7h
7Vy+ecz8MFEvf7mkTXeR9lD/J/yFbAKtEhjWiGw8VIC0WdcY+jyRs7c9v92Ci7qO
CTT3FFwS5fYDlJZiFJVHGpKlO1sTsVzepLA3JFlbP3D0cPWnbOp0q2te4A8E9am0
kn2bDaz0AB/JI7cNkuRcp3pxzrIiRWG4sjkdniXRdayY3MzQARCfYySW2nlji9N1
L27+AHIKOXBhgIekvyxW1WpxFSpZOO9/GS8SENCvoo631kADqOXWYvqJLtSFGumX
EN+IAqWrPNH5zMzFEU4CpU/gEboJikjarOQqyFhD4dYDvpHhLq3N33TtFLvLvB5h
dHX1Mj83eTYvXkyLQWPREAgKhaGY1vfRdZD6nad3s8iUy/VBmWfgbwmtZMva+ubr
7W3SlLhokCzz6X0MvjxI4Lw3pPwUYaCH8zWHBvDnlwBIsyOdXKkcDPq0qwo2gFbU
86VFUMENRTMCF41MH9zjM83N+PSS+7D7P0k1QmfCB96V4WlHHH1Srm+4/GC8HaMd
wnIIP7NIcA1qlwckWJSHxMQqMys1ZLufwnd/xw7/KhTMbWvDYbAxSANU7QsbnmLb
RvOjdudu0u2aB/7LRZuG
=Ob2b
-----END PGP SIGNATURE-----

--------------enigB79484E5FBA69B58E0AE8B3B--
