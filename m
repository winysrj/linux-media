Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:37893 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbeGQNh1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 09:37:27 -0400
MIME-Version: 1.0
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
 <20180717121338.GO8180@w540> <CAMuHMdVLe3P0GBP9z=S2+a1SDsBe3zmUnS32J-yd4tYsP99qaQ@mail.gmail.com>
 <20180717125930.GP8180@w540>
In-Reply-To: <20180717125930.GP8180@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 17 Jul 2018 15:04:38 +0200
Message-ID: <CAMuHMdXkkjuug2ogBaXnWniP2xv5=J71dhMndnjDfUWm3Ogjig@mail.gmail.com>
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

On Tue, Jul 17, 2018 at 2:59 PM jacopo mondi <jacopo@jmondi.org> wrote:
> On Tue, Jul 17, 2018 at 02:23:16PM +0200, Geert Uytterhoeven wrote:
> > On Tue, Jul 17, 2018 at 2:13 PM jacopo mondi <jacopo@jmondi.org> wrote:
> > >    I'm replying here, even if a new version of the bindings for this
> > > chip has been posted[1], as they have the same ports layout.
> > >
> > > [1] https://www.spinics.net/lists/linux-renesas-soc/msg29307.html
> > >
> > > On Wed, Jun 06, 2018 at 08:34:41AM +0200, Geert Uytterhoeven wrote:
> > > > Hi Kieran,
> > > >
> > > > On Wed, Jun 6, 2018 at 1:34 AM, Kieran Bingham
> > > > <kieran.bingham+renesas@ideasonboard.com> wrote:
> > > > > Provide device tree binding documentation for the MAX9286 Quad GMSL
> > > > > deserialiser.
> > > > >
> > > > > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > >
> > > > Thanks for your patch!
> > > >
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
> > > > > @@ -0,0 +1,75 @@
> > > > > +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
> > > > > +
> > > > > +Required Properties:
> > > > > + - compatible: Shall be "maxim,max9286"
> > > > > +
> > > > > +The following required properties are defined externally in
> > > > > +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
> > > > > + - Standard I2C mux properties.
> > > > > + - I2C child bus nodes.
> > > > > +
> > > > > +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
> > > > > +correspond with a maximum of 4 input devices.
> > > > > +
> > > > > +The device node must contain one 'port' child node per device input and output
> > > > > +port, in accordance with the video interface bindings defined in
> > > > > +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> > > > > +are numbered as follows.
> > > > > +
> > > > > +      Port        Type
> > > > > +    ----------------------
> > > > > +       0          sink
> > > > > +       1          sink
> > > > > +       2          sink
> > > > > +       3          sink
> > > > > +       4          source
> > > >
> > > > I assume the source and at least one sink are thus mandatory?
> > > >
> > > > Would it make sense to use port 0 for the source?
> > > > This would simplify extending the binding to devices with more input
> > > > ports later.
> > >
> > > I see your point, but as someone that has no idea how future chips could look
> > > like, I wonder why having multiple outputs it's more un-likely to
> > > happen than having more inputs added.
> >
> > I also don't know.
> > I was just thinking "What if another chip has less or more sinks?".
> >
> > > Do you have any suggestion on how we can handle both cases?
> >
> > Instead of having a single "ports" subnode, you could split it in two subnodes,
> > "sinks" and "sources"? I don't know if that's feasible.
> >
> Maybe I didn't get you here, and sorry to repeat something obvious for
> you but, that would be against basic assumptions both in fwnode/of framework
> and in media framework too. See the graph.txt documentation and
> video_interfaces.txt, the layout with a single 'ports' node with
> multiple 'port' sub-nodes is not avoidable, afaik.
>
> What is not -theoretically- forbidden is to have port subnodes with
> multiple endpoints, which is also used as an example in multiple
> places in the documentation files I mentioned above. Unfortunately, as
> we experienced with the ADV748x and the R-Car CSI-2 receiver
> upstreaming effort, the v4l2-async framework relies on matching on the
> remote endpoint's parent device node, and Kieran and Niklas had to use
> a custom endpoint matching logic for the R-Car CSI-2 and adv748x
> combo, something I'm sure nobody wants to repeat here.
>
> We said that multiple times that we would like to tackle this
> limitation (if that's limitation) in the v4l2_async framework, maybe
> if GMSL-like devices with multiple input/output ports comes out, we
> might have enough motivation to do that ;) ?

I'm totally ignorant w.r.t. multimedia endpoints, hence the "... don't
know if that's
feasible".

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
