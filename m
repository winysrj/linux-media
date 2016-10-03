Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43180 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbcJCKQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2016 06:16:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: gose: add HDMI input
Date: Mon, 03 Oct 2016 13:16:22 +0300
Message-ID: <2300679.2ngeeH3ECe@avalon>
In-Reply-To: <20161001091931.GL8472@bigcity.dyn.berto.se>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com> <3186140.opQPlkUUe2@avalon> <20161001091931.GL8472@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Saturday 01 Oct 2016 11:19:31 Niklas S=F6derlund wrote:
> On 2016-09-30 16:32:52 +0300, Laurent Pinchart wrote:
> > On Friday 30 Sep 2016 15:00:59 Geert Uytterhoeven wrote:
> >> On Fri, Sep 30, 2016 at 2:40 PM, Laurent Pinchart wrote:
> >>>> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> >>>> +++ b/arch/arm/boot/dts/r8a7793-gose.dts

[snip]

> >>>> @@ -531,6 +536,21 @@
> >>>>               };
> >>>>       };
> >>>>=20
> >>>> +     hdmi-in@4c {
> >>>> +             compatible =3D "adi,adv7612";
> >>>> +             reg =3D <0x4c>;
> >>>> +             interrupt-parent =3D <&gpio1>;
> >>>> +             interrupts =3D <20 IRQ_TYPE_LEVEL_LOW>;
> >>>=20
> >>> Isn't the interrupt signal connected to GP4_2 ?
> >>=20
> >> No idea about Gose, but on Koelsch it is (hence koelsch DTS is wro=
ng??)
> >=20
> > I believe so. I don't have a Koelsch board anymore so I can't test =
that.
> > Niklas, do you have a Koelsch on which you could confirm the IRQ nu=
mber ?
>=20
> I have done the best I can to prove the IRQ, it proved to be a bit
> tricky or maybe I'm doing it the wrong way.
>=20
> I hooked up my oscilloscope to EXIO Connector D pin 7, which accordin=
g
> to the schematics should be GP4_2 and attached to a pull-up at 3.3v. =
I
> can observe the pull-up and if I control the pin using the
> /sys/class/gpio interface I do indeed control GP4_2, So the schematic=
 is
> correct at least this far.
>=20
> The trouble I have is that the adv7612 driver do not currently consum=
e
> the interrupt so I can't see multiple field interrupts by observing t=
he
> pin. I do however see what I believe is the first field interrupt, if=
 I
> observe the pin just as I turn on my HDMI video source the pin go fro=
m 1
> -> 0 but is never reset and a reset of the entire board is needed if =
you
> wish to see it again.
>=20
> If I on the other hand observe pin GP1_20 on EXIO Connector A pin 66 =
I
> notice nothing on the oscilloscope from that it's set to 3.3V at powe=
r
> on, no mater how much HDMI input i run.
>=20
> In conclusion, yes I do believe the DTS is wrong and that GP4_2 is th=
e
> correct interrupt signal on Koelsch. This adds up with the schematics=

> and my rudimentary measurements.

Thanks a lot for testing. Ulrich, could you please fix this patch accor=
dingly=20
?

--=20
Regards,

Laurent Pinchart

