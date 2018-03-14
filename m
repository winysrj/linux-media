Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:52565 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCNPRk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:17:40 -0400
Date: Wed, 14 Mar 2018 16:17:33 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
Subject: Re: [PATCH 1/3] rcar-vin: remove duplicated check of state in irq
 handler
Message-ID: <20180314151733.GC16424@w540>
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
 <a6fa3bbf-52e5-5576-fbea-3a280a1c8bb1@ideasonboard.com>
 <20180313175654.GE10974@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <20180313175654.GE10974@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas, Kieran,

On Tue, Mar 13, 2018 at 06:56:54PM +0100, Niklas S=C3=B6derlund wrote:
> Hi Kieran,
>
> Thanks for your feedback.
>
> On 2018-03-13 17:42:25 +0100, Kieran Bingham wrote:
> > Hi Niklas,
> >
> > Thanks for the patch series :) - I've been looking forward to seeing th=
is one !
> >
> > On 10/03/18 01:09, Niklas S=C3=B6derlund wrote:
> > > This is an error from when the driver where converted from soc-camera.
> > > There is absolutely no gain to check the state variable two times to =
be
> > > extra sure if the hardware is stopped.
> >
> > I'll not say this isn't a redundant check ... but isn't the check again=
st two
> > different states, and thus the remaining check doesn't actually catch t=
he case
> > now where state =3D=3D STOPPED ?
>
> Thanks for noticing this, you are correct. I think I need to refresh my
> glasses subscription after missing this :-)
>
> >
> > (Perhaps state !=3D RUNNING would be better ?, but I haven't checked th=
e rest of
> > the code)
>
> I will respin this in a v2 and either use state !=3D RUNNING or at least
> combine the two checks to prevent future embarrassing mistakes like
> this.

I am sorry I have missed this comment, but I think your patch has some
merits. Ofc no need to hold on v2 of this series for this, but still I
think you can re-propose this later (and I didn't get from
your commit message you were confusing STOPPED/STOPPING).

In rvin_stop_streaming(), you enter STOPPING state, disable the
interface cleaning ME bit in VnMC and single/continuous capture mode
in VnFC, and then poll on CA bit of VnMS until the VIN peripheral has
not been stopped, at this  point you set interface state to STOPPED.

As you loop you can still receive interrupts, as you are releasing the
spinlock when sleeping before testing the ME bit again, so it's fine
checking for STOPPING state in irq handler.
It seems to me though, that once you enter STOPPED state, you are sure the
peripheral has stopped and you should not receive any more interrupt, spuri=
ous
ones apart or when the peripheral fails to stop at all, but things went
south already at that point.

Again no need to have this part of this series, but you may want to
take into consideration this for the future, as with this change you can
remove the STOPPED state at all from the driver.

Thanks
   j

>
> >
> > --
> > Kieran
> >
> >
> > >
> > > Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnat=
ech.se>
> > > ---
> > >  drivers/media/platform/rcar-vin/rcar-dma.c | 6 ------
> > >  1 file changed, 6 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/med=
ia/platform/rcar-vin/rcar-dma.c
> > > index 23fdff7a7370842e..b4be75d5009080f7 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > > @@ -916,12 +916,6 @@ static irqreturn_t rvin_irq(int irq, void *data)
> > >  	rvin_ack_interrupt(vin);
> > >  	handled =3D 1;
> > >
> > > -	/* Nothing to do if capture status is 'STOPPED' */
> > > -	if (vin->state =3D=3D STOPPED) {
> > > -		vin_dbg(vin, "IRQ while state stopped\n");
> > > -		goto done;
> > > -	}
> > > -
> > >  	/* Nothing to do if capture status is 'STOPPING' */
> > >  	if (vin->state =3D=3D STOPPING) {
> > >  		vin_dbg(vin, "IRQ while state stopping\n");
> > >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJaqT0NAAoJEHI0Bo8WoVY8TJAP/0aTh6SqRtDKYfTlrNUwh8FN
NOEZCoLOIvD19HhB6xOkQ+BOckH1ipjvQyJ1lGA6diJLPZIZCeTAbNacrOqEqAYt
MDmVdACcXLoGKUYZbqPYSDrQYXXESOVQLx/Eym/WKY9SQb4WQxOpBlgq3qawlX+X
1Ts9gfpiAi9P/+nXPjZ1GD0+byzbdZaqFLKyvBzRu/TU1nTUY+D0id7+swJT7XPz
VZNJlLgKxBNjN9ld2diuNXBocwYiIY5QvjKk+/Wau/LAmOVuUWdKERxt/KbfYlNS
uaJpcgDXY4Z09ZDD93ob/JXZgdDOSbqqk6IBXKanhIOqVZJ7b4NXkMGTQoN15HNK
uZDPwEp3uYezYLcKsN5Iem6Ll7cb6llbaqWAhtd2EdhDIqNlUP31q51U2dyIlUt/
jCenITj0Q0ei0wVa3LdOzZ46crsA31ZvRXNWqKVGygNKOvVZSGNhM91TLF6gOf7u
R5aiUDDM0CQ1ML8rHmDQr2creZPdMEvwsy3cD3d0ivMNRu42qvz2hd3QzqZBxsx7
sZDTtCtjoEdNfMuQdl2uNmnWPRnCweGaKR57aAVbm0gizjpwpKKTAiXmD9BGr8VL
F6yr83g1dANAz9CRgE15eOGG7vHW1QPw4qAspv8DmgYMGx7e4A4DIlQhHfTHuZwG
CSaTumdyt3/QnPXotUUq
=wG/g
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
