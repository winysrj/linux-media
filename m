Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:40195 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbeIFNWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 09:22:36 -0400
Date: Thu, 6 Sep 2018 10:48:07 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>, pza@pengutronix.de,
        steve_longerbeam@mentor.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Daniel Mack <daniel@zonque.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] media: ov5640: Re-work MIPI startup sequence
Message-ID: <20180906084807.GL28160@w540>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
 <20180906074815.GK28160@w540>
 <CAMZdPi8MTCCNp_Q_WZUm5TnH2U_x9bxO7QLmxaiBvMEAB5ujTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="75WsOQSofUOhcSOp"
Content-Disposition: inline
In-Reply-To: <CAMZdPi8MTCCNp_Q_WZUm5TnH2U_x9bxO7QLmxaiBvMEAB5ujTw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--75WsOQSofUOhcSOp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Loic,

On Thu, Sep 06, 2018 at 10:13:53AM +0200, Loic Poulain wrote:
> On 6 September 2018 at 09:48, jacopo mondi <jacopo@jmondi.org> wrote:
> > Hello Loic,
> >    thanks for looking into this
> >
> > On Tue, Sep 04, 2018 at 07:22:50PM +0200, Loic Poulain wrote:
> >> Hi Jacopo,
> >>
> >> > -       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
> >> > -                            on ? 0 : BIT(5));
> >> > -       if (ret)
> >> > -               return ret;
> >> > -       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
> >> > -                              on ? 0x00 : 0x70);
> >> > +       /*
> >> > +        * Enable/disable the MIPI interface
> >> > +        *
> >> > +        * 0x300e = on ? 0x45 : 0x40
> >> > +        * [7:5] = 001  : 2 data lanes mode
> >>
> >> Does 2-Lanes work with this config?
> >> AFAIU, if 2-Lanes is bit 5, value should be 0x25 and 0x20.
> >>
> >
> > Yes, confusing.
> >
> > The sensor manual reports
> > 0x300e[7:5] = 000 one lane mode
> > 0x300e[7:5] = 001 two lanes mode
> >
> > Although this configuration works with 2 lanes, and the application
> > note I have, with the suggested settings for MIPI CSI-2 2 lanes
> > reports 0x40 to be the 2 lanes mode...
> >
> > I used that one, also because the removed entry from the settings blob
> > is:
> > -       {0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
> > +       {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
> >
> > So it was using BIT(6) already.
>
> Yes, it was setting BIT(6) from static config and BIT(5) from the
> ov5640_set_stream_mipi function. In your patch you don't set
> BIT(5) anymore.
>
> So it's not clear to me why it is still working, and the datasheet does
> not help a lot on this (BIT(6) is for debug modes).
> FYI I tried with BIT(5) only but it does not work (though I did not
> investigate a lot).

Thanks. Is your setup using 1 or 2 lanes? (I assume 2...)

Another question, unrelated to this specific issue: was the ov5640
working with dragonboard before this patch? I'm asking as I've seen
different behaviors between different platforms, and knowing this
fixes a widespread one like dragonboard is, would help getting this
patches in faster :)

Thanks
   j
>
> > Anyway, it works for me with 2 lanes (and I assume Steve), you have tested
> > too, with how many lanes are you working with?
> >
> > Anyway, a comment there might be nice to have... Will add in next
> > version
>
> Definitely.
>
> Regards,
> Loic

--75WsOQSofUOhcSOp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbkOnGAAoJEHI0Bo8WoVY8zMIP/jEoDqoOVr8fLR0TLaghLoCa
W0JMFc+wgrkzi6IGPczHmlBX+tQ19CnfBDncFr01tAIj8+jUEswHPIAxE44vB6Vd
qoj+hPf3ULKsy5/7MclFU7S9pDwBdwLR2SDR8bvVGw65NoMDCr3Yg/A0bREIfy7X
Cd9IxXOMz7Ve7USNbTE6wEfy6h72lBxcoWDLEAifvM3q3Fl6oonJ++oHYBXOUmBG
mRIyJ5vpxdihO7MmfeK/jPmmzfDeMHuhTs1sSEuu3NvTi8kVEDqVAgYW746gt/O6
L+Sk2ICoFQ/CDdcG0EoNmtVtBgCZ/EBgsSqvn0QN1H9rD8CD+1Jx7RTRUp69dBxf
ny+qdT7JAT4w/yi2dP1zUNlNNQz4rfeSZcgD/DgJJk17seIki9qEV/RhHdk2oPS1
hs16vgAFEz/eYykX5LUSyxdqVx/8EOC9prMAYcPDQtyuO+Es/ki4BQ0lqp2G4Q96
N3xYaXD90xM0CNhnWCllVOAEc0bVo8ksvrMTPUVFFptz8yTxhxQ+zIeysy+VeOTH
CRG47FWDkXriYz927445Pbz8UG3IK3NMt2MsLt0vwXiy5xc4UuQgyZXMmhcSn3QM
Y1PTAtEl7Pq23jFHFPCZKgQoSUhA4NcYUs08JOJLxy2TZsha6sg9WIsGvV7V1qeY
UpNOFMa/NOvODsbyxK2C
=x0CZ
-----END PGP SIGNATURE-----

--75WsOQSofUOhcSOp--
