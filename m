Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:40644 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbeGQMzx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 08:55:53 -0400
MIME-Version: 1.0
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com> <20180717121338.GO8180@w540>
In-Reply-To: <20180717121338.GO8180@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 17 Jul 2018 14:23:16 +0200
Message-ID: <CAMuHMdVLe3P0GBP9z=S2+a1SDsBe3zmUnS32J-yd4tYsP99qaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree binding
To: Jacopo Mondi <jacopo@jmondi.org>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Jul 17, 2018 at 2:13 PM jacopo mondi <jacopo@jmondi.org> wrote:
>    I'm replying here, even if a new version of the bindings for this
> chip has been posted[1], as they have the same ports layout.
>
> [1] https://www.spinics.net/lists/linux-renesas-soc/msg29307.html
>
> On Wed, Jun 06, 2018 at 08:34:41AM +0200, Geert Uytterhoeven wrote:
> > Hi Kieran,
> >
> > On Wed, Jun 6, 2018 at 1:34 AM, Kieran Bingham
> > <kieran.bingham+renesas@ideasonboard.com> wrote:
> > > Provide device tree binding documentation for the MAX9286 Quad GMSL
> > > deserialiser.
> > >
> > > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >
> > Thanks for your patch!
> >
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
> > > @@ -0,0 +1,75 @@
> > > +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
> > > +
> > > +Required Properties:
> > > + - compatible: Shall be "maxim,max9286"
> > > +
> > > +The following required properties are defined externally in
> > > +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
> > > + - Standard I2C mux properties.
> > > + - I2C child bus nodes.
> > > +
> > > +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
> > > +correspond with a maximum of 4 input devices.
> > > +
> > > +The device node must contain one 'port' child node per device input and output
> > > +port, in accordance with the video interface bindings defined in
> > > +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> > > +are numbered as follows.
> > > +
> > > +      Port        Type
> > > +    ----------------------
> > > +       0          sink
> > > +       1          sink
> > > +       2          sink
> > > +       3          sink
> > > +       4          source
> >
> > I assume the source and at least one sink are thus mandatory?
> >
> > Would it make sense to use port 0 for the source?
> > This would simplify extending the binding to devices with more input
> > ports later.
>
> I see your point, but as someone that has no idea how future chips could look
> like, I wonder why having multiple outputs it's more un-likely to
> happen than having more inputs added.

I also don't know.
I was just thinking "What if another chip has less or more sinks?".

> Do you have any suggestion on how we can handle both cases?

Instead of having a single "ports" subnode, you could split it in two subnodes,
"sinks" and "sources"? I don't know if that's feasible.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
