Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:51733 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbeEQJI5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 05:08:57 -0400
Date: Thu, 17 May 2018 11:01:10 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180517090110.GA20190@w540>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-6-git-send-email-jacopo+renesas@jmondi.org>
 <20180516221307.GF17948@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20180516221307.GF17948@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Thu, May 17, 2018 at 12:13:07AM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your work.
>
> On 2018-05-16 18:32:31 +0200, Jacopo Mondi wrote:
> > The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> > driver and only confuse users. Remove them in all Gen2 SoC that used
> > them.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  arch/arm/boot/dts/r8a7790-lager.dts   | 3 ---
> >  arch/arm/boot/dts/r8a7791-koelsch.dts | 3 ---
> >  arch/arm/boot/dts/r8a7791-porter.dts  | 1 -
> >  arch/arm/boot/dts/r8a7793-gose.dts    | 3 ---
> >  arch/arm/boot/dts/r8a7794-alt.dts     | 1 -
> >  arch/arm/boot/dts/r8a7794-silk.dts    | 1 -
> >  6 files changed, 12 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8=
a7790-lager.dts
> > index 063fdb6..b56b309 100644
> > --- a/arch/arm/boot/dts/r8a7790-lager.dts
> > +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> > @@ -873,10 +873,8 @@
> >  	port {
> >  		vin0ep2: endpoint {
> >  			remote-endpoint =3D <&adv7612_out>;
> > -			bus-width =3D <24>;
>
> I can't really make up my mind if this is a good thing or not. Device
> tree describes the hardware and not what the drivers make use of. And
> the fact is that this bus is 24 bits wide. So I'm not sure we should
> remove these properties. But I would love to hear what others think
> about this.
>

Just to point out those properties are not even documented in rcar-vin
bindings (actually, none of them was).

I feel it's wrong to have them here, as someone may think that
changing their value should actually change the VIN interface behavior,
which it's not true, leading to massive confusion and quite some code
digging for no reason (and they will get mad at us at some point, probably =
:)

Thanks
   j

> >  			hsync-active =3D <0>;
> >  			vsync-active =3D <0>;
> > -			pclk-sample =3D <1>;
> >  			data-active =3D <1>;
> >  		};
> >  	};
> > @@ -895,7 +893,6 @@
> >
> >  		vin1ep0: endpoint {
> >  			remote-endpoint =3D <&adv7180>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/=
r8a7791-koelsch.dts
> > index f40321a..9967666 100644
> > --- a/arch/arm/boot/dts/r8a7791-koelsch.dts
> > +++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
> > @@ -849,10 +849,8 @@
> >
> >  		vin0ep2: endpoint {
> >  			remote-endpoint =3D <&adv7612_out>;
> > -			bus-width =3D <24>;
> >  			hsync-active =3D <0>;
> >  			vsync-active =3D <0>;
> > -			pclk-sample =3D <1>;
> >  			data-active =3D <1>;
> >  		};
> >  	};
> > @@ -870,7 +868,6 @@
> >
> >  		vin1ep: endpoint {
> >  			remote-endpoint =3D <&adv7180>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r=
8a7791-porter.dts
> > index c14e6fe..055a7f1 100644
> > --- a/arch/arm/boot/dts/r8a7791-porter.dts
> > +++ b/arch/arm/boot/dts/r8a7791-porter.dts
> > @@ -391,7 +391,6 @@
> >
> >  		vin0ep: endpoint {
> >  			remote-endpoint =3D <&adv7180>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a=
7793-gose.dts
> > index 9ed6961..9d3fba2 100644
> > --- a/arch/arm/boot/dts/r8a7793-gose.dts
> > +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> > @@ -759,10 +759,8 @@
> >
> >  		vin0ep2: endpoint {
> >  			remote-endpoint =3D <&adv7612_out>;
> > -			bus-width =3D <24>;
> >  			hsync-active =3D <0>;
> >  			vsync-active =3D <0>;
> > -			pclk-sample =3D <1>;
> >  			data-active =3D <1>;
> >  		};
> >  	};
> > @@ -781,7 +779,6 @@
> >
> >  		vin1ep: endpoint {
> >  			remote-endpoint =3D <&adv7180_out>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7=
794-alt.dts
> > index 26a8834..4bbb9cc 100644
> > --- a/arch/arm/boot/dts/r8a7794-alt.dts
> > +++ b/arch/arm/boot/dts/r8a7794-alt.dts
> > @@ -380,7 +380,6 @@
> >
> >  		vin0ep: endpoint {
> >  			remote-endpoint =3D <&adv7180>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a=
7794-silk.dts
> > index 351cb3b..c0c5d31 100644
> > --- a/arch/arm/boot/dts/r8a7794-silk.dts
> > +++ b/arch/arm/boot/dts/r8a7794-silk.dts
> > @@ -480,7 +480,6 @@
> >
> >  		vin0ep: endpoint {
> >  			remote-endpoint =3D <&adv7180>;
> > -			bus-width =3D <8>;
> >  		};
> >  	};
> >  };
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa/UTWAAoJEHI0Bo8WoVY8SesQAIeTcsNVt3KCDFQ2RJ5cwf0g
IJSgO/15lLtDNdZUxBltmwvpujppz+jPGGss17mZaf6FFdRPCoypp4nw4kmBhmFg
hHtOBIrXcfJQQZPIP5UswxP2C8lLW0daGlCP0wuHzSAlGLJf3AJQrOYOQNHknTwB
FBr2AbnPqbY7Oj4MjDLgZeXZjO4E9sQpGOUiHKNJgNChe2ZFcMubJMcNUIEc+Dcq
HYgZFPSrBc/JBLLg8rRvnr+7H5fFqe8Wfqqcx+P593j0gBqZoJ6iX/NUE3Rc/7q5
0nKPQyKFX5LqHyGODBZu0BGoCOyecQKWCibIZnyZJGu0GKH/oNOXnZmHOAAfw7om
wBXC2ZUI6PxqGYwo7IwpBH4hhCMvM/1SwKsRLEV+LnV3UmScg7BNAfJYQ6ANmzBa
mY7DKe6TaoizKv3gsnq/c5mTh2Hjw3w84A9pdFe9iJDOysERirpSQpuRwJ7H07Wb
UcbQKL8A9EDIglpXSuMb+3/HnCv3Wse/PjZ6o6aEbXR1RLemY52qrw/SmAV/4c0K
6etf+tbjc4nmxtiqTMEve8B9gCJY+Z0m3qoXsqO5CRmB+LH3MWnOKrzyFB+4iG8+
sJmiyPLqVwzoKNGmFjR7/qFTRKu3sNIBaWKKChItrxDpZ+2HAAYMXT6I8cJDCO6g
SaQxcv4x7eYtuYGVFVKn
=x1ck
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
