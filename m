Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33027 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbeGQMqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 08:46:06 -0400
Date: Tue, 17 Jul 2018 14:13:38 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: Re: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree
 binding
Message-ID: <20180717121338.GO8180@w540>
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Geert,
   I'm replying here, even if a new version of the bindings for this
chip has been posted[1], as they have the same ports layout.

[1] https://www.spinics.net/lists/linux-renesas-soc/msg29307.html

On Wed, Jun 06, 2018 at 08:34:41AM +0200, Geert Uytterhoeven wrote:
> Hi Kieran,
>
> On Wed, Jun 6, 2018 at 1:34 AM, Kieran Bingham
> <kieran.bingham+renesas@ideasonboard.com> wrote:
> > Provide device tree binding documentation for the MAX9286 Quad GMSL
> > deserialiser.
> >
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Thanks for your patch!
>
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
> > @@ -0,0 +1,75 @@
> > +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
> > +
> > +Required Properties:
> > + - compatible: Shall be "maxim,max9286"
> > +
> > +The following required properties are defined externally in
> > +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
> > + - Standard I2C mux properties.
> > + - I2C child bus nodes.
> > +
> > +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
> > +correspond with a maximum of 4 input devices.
> > +
> > +The device node must contain one 'port' child node per device input and output
> > +port, in accordance with the video interface bindings defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> > +are numbered as follows.
> > +
> > +      Port        Type
> > +    ----------------------
> > +       0          sink
> > +       1          sink
> > +       2          sink
> > +       3          sink
> > +       4          source
>
> I assume the source and at least one sink are thus mandatory?
>
> Would it make sense to use port 0 for the source?
> This would simplify extending the binding to devices with more input
> ports later.

I see your point, but as someone that has no idea how future chips could look
like, I wonder why having multiple outputs it's more un-likely to
happen than having more inputs added.

Do you have any suggestion on how we can handle both cases?

Thanks
   j

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbTd1yAAoJEHI0Bo8WoVY8Fk4P/jYkQQQts/UOCm/xCDtz8dya
GKRFdzyp9ZGIPx4MlUWPp7smxNBcnYP6/uVEXmzpilTjOr5hheovbE7B821QN7L8
jGRp/S2odB5iAPcgvjuWRb6Vac44wjkBzP98Bgz3Ro6MZ1NxzeLOg/ce3cCZkCY+
W5iaozSkh/P9X75pK0/z9YDyml+aXQ7GKqpDlKzczpgcjALsxg2axwWY4D6kTjLW
m/9lRXvev/B6QYe4SpbjjfGYYDqPrfvCjhwIz9yzDnUAgHqBW0DATtaAp7L6Sqpc
GSJU0OpXfY41emQ/tybVdsVB5npyxmMipc2m7Te3s7HVHlNsSd+UBvkOcxzQTRbs
cZqHnu0axN6Irixm9KiMW6RsyP2V6V2b8yP7V0KdMWqcK16lfNzA64JcbMPJ1w33
+EC8sjNRwBLAW9+zgZ9nhscND9y6ePKVbWH3kFdZKeoxgU40uKjhktdZHfvuuz+s
3ivP9wZEOAYuoRC+hOpwyWcdwWQB+HD8lygIvMgjvkbcayRxsypuvD+vl7QFbUvm
TCZgIjphATVqm4MxhiQvJf6h7LlFwaZ84Zisl6kwUg1QxhSv6nP9gBX//8AQC+fD
0T+0y/8OspAkOHu7cTigXo2xPoOM0rn9Y8wUeP9K0Exzj0LIXyVPkeNmv8btRQUw
8ro9BgGQw/jO6BOGNw1K
=Bl78
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
