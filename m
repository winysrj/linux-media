Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56923 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbeKBSR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 14:17:57 -0400
Date: Fri, 2 Nov 2018 10:11:23 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        kieran.bingham@ideasonboard.com
Subject: Re: i.MX6: can't capture on MIPI-CSI2 with DS90UB954
Message-ID: <20181102091123.GS15991@w540>
References: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
 <b368e66b-eafa-1c3e-f75d-a57ccb6cc125@gmail.com>
 <CAL8zT=iDHfDPNWruBaLWjrUSgq6dLG34YR3bi1ini=oX_KsnLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iIOavGAISvUeFFLW"
Content-Disposition: inline
In-Reply-To: <CAL8zT=iDHfDPNWruBaLWjrUSgq6dLG34YR3bi1ini=oX_KsnLw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iIOavGAISvUeFFLW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean-Michel,

On Fri, Nov 02, 2018 at 09:09:42AM +0100, Jean-Michel Hautbois wrote:
> Hi Steve,
>
> Le mer. 31 oct. 2018 =C3=A0 22:52, Steve Longerbeam <slongerbeam@gmail.co=
m> a =C3=A9crit :
> >
> > Hi Jean-Michel,
> >
> > We've done some work with another FPD-Link de-serializer (ds90ux940) and
> > IIRC we had some trouble figuring out how to coax the lanes into LP-11
> > state. But on the ds90ux940 it can be done by setting bit 7 in the CSI
> > Enable Port registers (offsets 0x13 and 0x14). But the "imx6-mipi-csi2:
> > clock lane timeout" message is something else and indicates the
> > de-serializer is not activating the clock lane during its s_stream(ON)
> > subdev call.
>
> I have been doing more work on the driver I have, and I had CSI
> enabled before the csi2_dphy_wait_stopstate() call for instance. Now,
> LP-11 state is ok.
> Then, in the s_stream subcall, I added a delay after enabling CSI (and
> the continuous clock) and it is better too, as the clock is seen
> correctly each time.
> But I still get into a EOF timeout, which sounds like another issue.
>
> FYI, I added the NFACK interrupt support in my local kernel just to
> see if New Frames are detected, and it is not the case either.
> Any reason for not using this interrupt (maybe in "debug" mode) ?
>
> Now, I used a scope (not very fast so I can't get into the very fast
> signals) and I can see some weird things.
> In a 1-lane configuration, and a 400MHz clock, I can get the following
> when looking at D0N and D0P (yellow and green, can't remember which
> color is which) :
> https://framapic.org/H65QXHvaWmao/qdyoARz12dNi.png
>
> The purple is the diff result.
>
> First I thought it was a start sequence (but with very bizarre things
> at the very beginning of the sequence) like described here :
> https://cms.edn.com/ContentEETimes/Images/EDN/Design%20How-To/MIPI_Sync-S=
equence-in-the-transmitted-pattern.jpg
>
> But Jacopo remarked that the 'starting sequence' is actually sent in
> HS mode, so we should not be able to see it at all.
> He thinks that what we are looking at is actually a bad LP-11 -> LP01
> -> LP00 transition.
>
> And it could be the "HS ZERO" :
> https://cms.edn.com/ContentEETimes/Images/EDN/Design%20How-To/MIPI_HS-Bur=
st-on-Data-Lane.jpg

Sorry, my wording was confusing maybe. I think that what we see in
your trace looks very similar to what the image above reports as "HS
ZERO" followed by "HS DATA". This confused me intially as I thought I
was looking at an "HS Sync Sequence" (as defined by D-PHY specs), while
as you reported, my understanding is that your trace shows LP signals,
before any HS data transmission happens (in the right
side of your trace, if I got this rigth) and we should see a stable
LP-11 state transitioning to LP01 and then LP00.

=46rom my experience with ov5640 the i.MX6 seems more picky than other
devices on this. The ov5640 driver before commit:
aa4bb8b ("media: ov5640: Re-work MIPI startup sequence")
used to work fine on other platforms, while it failed on i.MX6 and
thus that patch.

This contrast with the fact that you now passes the:
imx6-mipi-csi2: LP-11 timeout, phy_state =3D 0x00000200
error you had reported in your initial email though :/

So please take my interpreation of that traces with a grain of salt, I
really don't want to mis-lead you to chase things that might actually
be correct.

Thanks
   j
>
> What do you think of this ?
> We will conduce more complex measurements, with high speed analyzers
> in order to check everything, and we are right now focusing on a
> possible hardware issue (coule be the custom PCB which embeds the
> DS90UB954).
>
> Thanks,
> JM

--iIOavGAISvUeFFLW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb3BS7AAoJEHI0Bo8WoVY8SjAP/A2Zp+GmAaVyh3LHxm+3bdd9
sFNSQ304urZiK95ThM7dxtiEfV09F5Qq0KneHhGhGzbS8gPD/YKCnI1U2LU931d1
0ViuQ1FbW16TEaFx0goo48iP2nVA2upc65fxmDNPq5tXxTifT8XdQDigQmmrNnlG
oJh3KCvBGLKXTsy+Ll2IlYpwFbZYypChXHyEQGDK9nzr/571+RVtBcXmUx1wwXrM
26XOp1kaLKhTDhst+0hCNDEVjik1E853htKD13yrPatQK0D07Pt+QAag8wYerhrt
KtPx6Ax7YcFYsw0qKDV2w52bJzE95EqMvsFCeDyuyvD9sQCvn913DbTrEM+mLgbA
RsYprT4U/5qqsV0WnKnmgySLT1uSvh4CGPeEnzCWSsHTm+p4QuXWRObr0u+KlYGc
/4G1GmvZBx84jiOrYYEYjwaMCEZklamiLOgkPtYS/q5u07Y3A6QbVkr9KxkjUnIs
ZLEhMXPVfBHrKLmezPThdbXwN5NZxypleXXljdToTpjhBcz6ukT0uyzN6cL8ebdD
CpwhxqCscrdBwru1jp2QK1RShjIxsLVH4tw+tvTcGYxV0DOoJVm32QNYSLcmwJBo
0Z290HjLAu0jeUCYyzSvShn8/ltzQNdwswYLsCKuRUUQ3bwARVSmpdoy8y9n3igj
kx7pX/lvjZ5DQUf8S/aJ
=jo8h
-----END PGP SIGNATURE-----

--iIOavGAISvUeFFLW--
