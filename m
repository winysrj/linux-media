Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52778 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbeHHMoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 08:44:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: dt: adv7604: Fix slave map documentation
Date: Wed, 08 Aug 2018 13:25:53 +0300
Message-ID: <5273911.bCJl0SVgzf@avalon>
In-Reply-To: <b5b25641-f898-577b-7762-d72dd64272cf@ideasonboard.com>
References: <20180807155452.797-1-kieran.bingham@ideasonboard.com> <505904fb-7bfc-c455-740e-b72a14731eb9@ysoft.com> <b5b25641-f898-577b-7762-d72dd64272cf@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 8 August 2018 13:23:32 EEST Kieran Bingham wrote:
> Hi Michal,
>=20
> Thank you for your review.
>=20
> +Rob, +Mark, +Laurent asking for opinions if anyone has any on prefixes
> through media tree.
>=20
> On 08/08/18 08:48, Michal Vok=C3=A1=C4=8D wrote:
> > On 7.8.2018 17:54, Kieran Bingham wrote:
> > Hi Kieran,
> >=20
> >> The reg-names property in the documentation is missing an '=3D'. Add i=
t.
> >>=20
> >> Fixes: 9feb786876c7 ("media: dt-bindings: media: adv7604: Extend
> >> bindings to allow specifying slave map addresses")
> >=20
> > "dt-bindings: media: " is preferred for the subject.
>=20
> This patch will go through the media-tree as far as I am aware, and
> Mauro prefixes all commits through the media tree with "media:" if they
> are not already prefixed.
>=20
> Thus this would then become "media: dt-bindings: media: adv7604: ...."
> as per my commit: 9feb786876c7 which seems a bit redundant.
>=20
> Is it still desired ? If so I'll send a V2. (perhaps needed anyway, as I
> seem to have erroneously shortened dt-bindings: to just dt: which wasn't
> intentional.
>=20
> > I think you should also add device tree maintainers to the recipients.
>=20
> Added to this mail to ask opinions on patch prefixes above.
>=20
> Originally, I believed the list was sufficient as this is a trivial
> patch, and it goes through the media tree.
>=20
> But, it turned out to be more controversial :)
>=20
> Rob, Mark, should I add you to all patches affecting DT? Or is the list
> sufficient?

Given the insane amount of patches received by DT maintainers, I personally=
=20
try to use common sense and only disturb them when needed. Such a typo fix=
=20
doesn't qualify for a full CC list in my opinion.

> >> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> >> ---
> >>   Documentation/devicetree/bindings/media/i2c/adv7604.txt | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> >> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> >> index dcf57e7c60eb..b3e688b77a38 100644
> >> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> >> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> >> @@ -66,7 +66,7 @@ Example:
> >>            * other maps will retain their default addresses.
> >>            */
> >>           reg =3D <0x4c>, <0x66>;
> >> -        reg-names "main", "edid";
> >> +        reg-names =3D "main", "edid";
> >>             reset-gpios =3D <&ioexp 0 GPIO_ACTIVE_LOW>;
> >>           hpd-gpios =3D <&ioexp 2 GPIO_ACTIVE_HIGH>;

=2D-=20
Regards,

Laurent Pinchart
