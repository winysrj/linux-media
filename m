Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbeHCT1y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 15:27:54 -0400
Date: Fri, 3 Aug 2018 14:30:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Rob Herring <robh@kernel.org>, mchehab@kernel.org,
        mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, javierm@redhat.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 20/22] [media] tvp5150: Add input port connectors DT
 bindings
Message-ID: <20180803143030.3cd43921@coco.lan>
In-Reply-To: <20180803072953.gwla7i6pcw2s3zo7@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-21-m.felsch@pengutronix.de>
        <20180703232320.GA18319@rob-hp-laptop>
        <20180803072953.gwla7i6pcw2s3zo7@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Aug 2018 09:29:53 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Rob,
> 
> first of all, thanks for the review. After some discussion with the
> media guys I have a question about the dt-bindings.
> 
> On 18-07-03 17:23, Rob Herring wrote:
> > On Thu, Jun 28, 2018 at 06:20:52PM +0200, Marco Felsch wrote:  
> > > The TVP5150/1 decoders support different video input sources to their
> > > AIP1A/B pins.
> > > 
> > > Possible configurations are as follows:
> > >   - Analog Composite signal connected to AIP1A.
> > >   - Analog Composite signal connected to AIP1B.
> > >   - Analog S-Video Y (luminance) and C (chrominance)
> > >     signals connected to AIP1A and AIP1B respectively.
> > > 
> > > This patch extends the device tree bindings documentation to describe
> > > how the input connectors for these devices should be defined in a DT.
> > > 
> > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > ---
> > >  .../devicetree/bindings/media/i2c/tvp5150.txt | 118 +++++++++++++++++-
> > >  1 file changed, 113 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > > index 8c0fc1a26bf0..feed8c911c5e 100644
> > > --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > > +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > > @@ -12,11 +12,23 @@ Optional Properties:
> > >  - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
> > >  - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
> > >  
> > > -The device node must contain one 'port' child node for its digital output
> > > -video port, in accordance with the video interface bindings defined in
> > > -Documentation/devicetree/bindings/media/video-interfaces.txt.
> > > +The device node must contain one 'port' child node per device input and output
> > > +port, in accordance with the video interface bindings defined in
> > > +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> > > +are numbered as follows
> > >  
> > > -Required Endpoint Properties for parallel synchronization:
> > > +	  Name		Type		Port
> > > +	--------------------------------------
> > > +	  AIP1A		sink		0
> > > +	  AIP1B		sink		1
> > > +	  S-VIDEO	sink		2
> > > +	  Y-OUT		src		3  
> 
> Do you think it's correct to have a seperate port for each binding?
> Since the S-Video port is a combination of AIP1A and AIP1B. After a
> discussion with Mauro [1] the TVP5150 should have only 3 pads. Since the
> pads are directly mappped to the dt-ports this will correspond to three
> ports (2 in, 1 out). Now the svideo connector will be mapped to a second
> endpoint in each port:
> 
> port@0			
> 	endpoint@0 -----------> Comp0-Con
> 	endpoint@1 -----+-----> Svideo-Con
> port@1		|
> 	endpoint@0 -----|-----> Comp1-Con
> 	endpoint@1 -----+
> port@2
> 	endpoint

For tvp5150, the model is like the above, so just one port at the
S-video connector.

Yet, for more complex devices that would allow switching the
endpoints at the Svideo connector, the model would be:

port@0			
	endpoint@0 (AIP1A) -----------> Comp0-Con
	endpoint@1 (AIP1B) -----------> Svideo-Con  port@0 (luminance)
port@1
	endpoint@0 (AIP1A) -----------> Comp1-Con
	endpoint@1 (AIP1B) -----------> Svideo-Con  port@1 (chrominance)
port@2
	endpoint   (video bitstream output)

E. g. the S-Video connector will also have two ports, one for the
chrominance signal and another one for the luminance one.

> I don't like that solution that much, since the mapping is now signal
> based. We also don't map each line of a parallel port.
> 
> A quick grep shows that currently each device using a svideo connector
> seperates them in a own port as I did.

No. I've no idea about how you did the grep, but this is not how other
drivers handle it currently.

Right now, on all hardware where connectors are mapped, there is just one
input port and multiple connectors linked to it. You can see some examples
here:

	https://www.infradead.org/~mchehab/mc-next-gen/au0828_hvr950q.png
	https://www.infradead.org/~mchehab/mc-next-gen/cx231xx_hvr930c_hd.png
	https://www.infradead.org/~mchehab/mc-next-gen/em28xx_hvr950.png
	https://www.infradead.org/~mchehab/mc-next-gen/playtv_usb.png
	https://www.infradead.org/~mchehab/mc-next-gen/saa7134-asus-p7131-dual.png
	https://www.infradead.org/~mchehab/mc-next-gen/wintv_usb2.png

The problem with this approach is that it doesn't reflect how the
hardware is actually wired. On some hardware similar to tvp5150,
it may be possible, for example, to wire the S-Video both ways,
e. g., something equivalent to (using tvp5150 terminology):

	Luminance   -> AIP1A
	Chrominance -> AIP1B
or
	Luminance   -> AIP1B
	Chrominance -> AIP1A

So, just one pad wouldn't allow this kind of config.

Having three pads is equally wrong, as there's no S-Video port on
tvp5150. All it has physically are two inputs: AIP1A and AIP1B.

If you want to see the discussions we had, they are at:
	https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-08-02,Thu

I'm preparing right now a summary of them. will copy you once I
finish it.

> IMHO this is a uncomplicate
> solution, but don't abstract the HW correctly. What is your opinion
> about that? Is it correct to have seperate (virtual) port or should I
> map the svideo connector as shown above?
> 
> [1] https://www.spinics.net/lists/devicetree/msg242825.html

Anyway, I'm writing a summary of our discussions 

Thanks,
Mauro
