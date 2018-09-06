Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60337 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbeIFMWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 08:22:30 -0400
Date: Thu, 6 Sep 2018 09:48:15 +0200
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
Message-ID: <20180906074815.GK28160@w540>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ms5iOKSBOB9YS8zC"
Content-Disposition: inline
In-Reply-To: <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Ms5iOKSBOB9YS8zC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Loic,
   thanks for looking into this

On Tue, Sep 04, 2018 at 07:22:50PM +0200, Loic Poulain wrote:
> Hi Jacopo,
>
> > -       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
> > -                            on ? 0 : BIT(5));
> > -       if (ret)
> > -               return ret;
> > -       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
> > -                              on ? 0x00 : 0x70);
> > +       /*
> > +        * Enable/disable the MIPI interface
> > +        *
> > +        * 0x300e = on ? 0x45 : 0x40
> > +        * [7:5] = 001  : 2 data lanes mode
>
> Does 2-Lanes work with this config?
> AFAIU, if 2-Lanes is bit 5, value should be 0x25 and 0x20.
>

Yes, confusing.

The sensor manual reports
0x300e[7:5] = 000 one lane mode
0x300e[7:5] = 001 two lanes mode

Although this configuration works with 2 lanes, and the application
note I have, with the suggested settings for MIPI CSI-2 2 lanes
reports 0x40 to be the 2 lanes mode...

I used that one, also because the removed entry from the settings blob
is:
-       {0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
+       {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},

So it was using BIT(6) already.

I do not remember if I tested BIT(5) or not, it would be interesting
if someone using a 1-lane interface could try '000' and '001' maybe.

Anyway, it works for me with 2 lanes (and I assume Steve), you have tested
too, with how many lanes are you working with?

Anyway, a comment there might be nice to have... Will add in next
version

Thanks
   j

> > +        * [4] = 0      : Power up MIPI HS Tx
> > +        * [3] = 0      : Power up MIPI LS Rx
> > +        * [2] = 1/0    : MIPI interface enable/disable
> > +        * [1:0] = 01/00: FIXME: 'debug'
> > +        */
> > +       ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00,
> > +                              on ? 0x45 : 0x40);
>
> Regards,
> Loic

--Ms5iOKSBOB9YS8zC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbkNu/AAoJEHI0Bo8WoVY8TAIP/jUxrI4lrpeheBXLfRatBcKX
b5MxKBn5G8YvKz78Y1qFoxMa0xtAqQNNaNRgFcYdFRq2Aq1CrDGGblKW67ckfHFP
PXnMYg5eYqYtoKV+y6TWjv+WjxnHlu0VY7oQficqbIq53UnldmaBy5XvFBQgX4V2
vfif6kqG6f42EbpmnzN5zN4xLdMysj55itATy+C85o1ISSGvX6MomCnu1SJkZfw/
ZSB0U8HNfrDxjsRQ+CC+npRoOwfafMjhKhjjOeYKQ3deyHJSRlv4SWsiruG+qZLr
hO+K3S6mp6ekdW5uloJnq5uzD/SgjVZraMjD2wcAzoiqsDPhYENJIcsnUl4zQxlQ
NEa175hgn2+AZnRC7rL1qnac6gMiKdLeKXdPJANWsgfb/novYtCZ0znOUYR2kWrY
9dD8z8xwvfqFyN9GJd/WEA5fucGT8Y5gRekelKnXUOuJXhT/ewC3ENBaUnh7QwsG
Bd9AIxzH+3qfiGQkubZS9lZPFomSLaF/22dG0zN/RGCdmeUK+oHRGWO56Vh8mkEn
z1kkDtHd6gFG7aYrTwjS5kTHKUsUYclLDwe9JkIWuL73D4N7vZFdx8oWS5dO85EZ
cUf9UzzcCA005brs9IpGmqSTcWhM71H2KJvhzqOEpwzC3BQ1R0sZI/r5xovhhtzK
XtbHypcf+qrH0iE6Hse/
=kKcu
-----END PGP SIGNATURE-----

--Ms5iOKSBOB9YS8zC--
