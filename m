Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:60605 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbeINOwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 10:52:31 -0400
Date: Fri, 14 Sep 2018 11:38:32 +0200
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
Message-ID: <20180914093832.GL11509@w540>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
 <20180906074815.GK28160@w540>
 <CAMZdPi8MTCCNp_Q_WZUm5TnH2U_x9bxO7QLmxaiBvMEAB5ujTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Content-Disposition: inline
In-Reply-To: <CAMZdPi8MTCCNp_Q_WZUm5TnH2U_x9bxO7QLmxaiBvMEAB5ujTw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--JlJsEFsx9RQyiX4C
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

I've resumed looking into this series.
Just FYI, the snippet you refer to is:

-       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
-                            on ? 0 : BIT(5));
-       if (ret)
-               return ret;
-       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
-                              on ? 0x00 : 0x70);
+       /*
+        * Enable/disable the MIPI interface
+        *
+        * 0x300e = on ? 0x45 : 0x40
+        * [7:5] = 001  : 2 data lanes mode
+        * [4] = 0      : Power up MIPI HS Tx
+        * [3] = 0      : Power up MIPI LS Rx
+        * [2] = 1/0    : MIPI interface enable/disable
+        * [1:0] = 01/00: FIXME: 'debug'
+        */
+       ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00,
+                              on ? 0x45 : 0x40)

As you can see (it took me a while) the old code was indeed setting
BIT(5) as you mentioned, but on OV5640_REG_MIPI_CTRL00 (0x4800) and
not on OV5640_REG_IO_MIPI_CTRL00 (0x300e) as mine does. So the lane
configuration mode was set to 0x45 and never changed later.
>
> So it's not clear to me why it is still working, and the datasheet does
> not help a lot on this (BIT(6) is for debug modes).
> FYI I tried with BIT(5) only but it does not work (though I did not
> investigate a lot).

I'll keep BIT(6) set, point out the discrepancy with the datasheet,
and point out it has been tested with 2 lanes, until someone can
confirm it works with 1 lane too.

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

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbm4GYAAoJEHI0Bo8WoVY8hPAP/iMLLr3mRpo1vXtFflR883H5
fd3T/9g6GUhoBoux9HZXmUWkvkW0hBAsaTbpbmHtdXE2kiA72jKUK5QP2XV+WqJj
SnUsRzyAi3rXl/HUbz+FfVJ/HXZd/jPNC0jf8XgUX4MCHEEji1+3VUIjuAfdAul5
Ye18fhFbSR2CRqE2n4lo6+xgvhvSnYYcYShRyqK8gWjJxjse7qBSRiQz17C5Vav+
tP0tgisJhA5TSkr4GtaM0hcRIJVd477GQ8l76LeOWZEuWAtTXrIJTprBTY4ZcBhy
ZCDQZJhjfxeT0j9k33vrW8toJvVbp8lkyctsMZy6STxS+k+EXZn4nnbRzY4NipMF
qDMoP4efudYpKa6ccSiVNqnxIIP89jf2AsaUxPGZgMRRLxZrO3DuuNNg8PO60XvF
U1khdPWKNX3w32mUqmEI6QECoBoHuYKbBw8dY+AWkQMqeQbDWPaj03gxOaFYDzYN
Xo1fLAse2NoC3+fRcXuNuo5vQvLnmLPE0uKarB6UJ6+uZhaTUROMYpb/pvknLPgW
G9f+qNy8ubIEXk0RrfawRth9bSzEcyNxgGZVmczIS474cg3FB9bHnvRT0uzF7G8T
8ZSMjlrapnxEJWJ0Fzg51py7tfutYgR0t6yej3F33mz78ScyGL3ZdzyxYELykVMC
eOtzOdiOmSZ/TS1OyIaR
=w1uE
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
