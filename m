Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753209AbdFPJ53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 05:57:29 -0400
Date: Fri, 16 Jun 2017 12:57:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [RFC 1/2] [media] dt-bindings: Document BCM283x CSI2/CCP2
 receiver
Message-ID: <20170616095722.GN12407@valkosipuli.retiisi.org.uk>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <888a28269a8a7c22feb2a126db699b1259d1b457.1497452006.git.dave.stevenson@raspberrypi.org>
 <20170615125958.GE12407@valkosipuli.retiisi.org.uk>
 <CAAoAYcOKD=Bd8_yDuoT8g+g1JYJO1fEoY83YWjPY38sru8Cvdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoAYcOKD=Bd8_yDuoT8g+g1JYJO1fEoY83YWjPY38sru8Cvdw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Thu, Jun 15, 2017 at 05:15:04PM +0100, Dave Stevenson wrote:
> Hi Sakari.
> 
> Thanks for the review.
> 
> On 15 June 2017 at 13:59, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Dave,
> >
> > Thanks for the set!
> >
> > On Wed, Jun 14, 2017 at 04:15:46PM +0100, Dave Stevenson wrote:
> >> Document the DT bindings for the CSI2/CCP2 receiver peripheral
> >> (known as Unicam) on BCM283x SoCs.
> >>
> >> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> >> ---
> >>  .../devicetree/bindings/media/bcm2835-unicam.txt   | 76 ++++++++++++++++++++++
> >>  1 file changed, 76 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> >> new file mode 100644
> >> index 0000000..cc5a451
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
> >> @@ -0,0 +1,76 @@
> >> +Broadcom BCM283x Camera Interface (Unicam)
> >> +------------------------------------------
> >> +
> >> +The Unicam block on BCM283x SoCs is the receiver for either
> >> +CSI-2 or CCP2 data from image sensors or similar devices.
> >> +
> >> +Required properties:
> >> +===================
> >> +- compatible : must be "brcm,bcm2835-unicam".
> >> +- reg                : physical base address and length of the register sets for the
> >> +               device.
> >> +- interrupts : should contain the IRQ line for this Unicam instance.
> >> +- clocks     : list of clock specifiers, corresponding to entries in
> >> +               clock-names property.
> >> +- clock-names        : must contain an "lp_clock" entry, matching entries
> >> +               in the clocks property.
> >> +
> >> +Optional properties
> >> +===================
> >> +- max-data-lanes: the hardware can support varying numbers of clock lanes.
> >> +               This value is the maximum number supported by this instance.
> >> +               Known values of 2 or 4. Default is 2.
> >
> > Please use "data-lanes" endpoint property instead. This is the number of
> > connected physical lanes and specific to the hardware.
> 
> I'll rethink/test, but to explain what I was intending to achieve:
> 
> Registers UNICAM_DAT2 and UNICAM_DAT3 are not valid for instances of
> the hardware that only have two lanes instantiated in silicon.
> In the case of the whole BCM283x family, Unicam0 ony has 2 lanes
> instantiated, whilst Unicam1 has the maximum 4 lanes. (Lower
> resolution front cameras would connect to Unicam0, whilst the higher
> resolution back cameras would go to Unicam1).
> 
> To further confuse matters, on the Pi platforms (other than the
> Compute Module), it is Unicam1 that is brought out to the camera
> connector but with only 2 lanes wired up.

This information should be present in the DT. I.e. the data-lanes property.

v4l2_fwnode_endpoint_alloc_parse() can obtain that from DT, among other
things (I haven't checked the second patch yet).

> 
> I was intending to make it possible for the driver to avoid writing to
> invalid registers, and also describe the platform limitations to allow
> sanity checking.
> I haven't tested against Unicam0 as yet to see what actually happens
> if we try to write UNICAM_DAT2 or UNICAM_DAT3. If the hardware
> silently swallows it then that requirement is null and void. I'll do
> some testing tomorrow.
> The second bit comes down to how friendly an error you want should
> someone write an invalid DT with 'data-lanes' greater than can be
> supported by the platform.

I'd expect things not to work if there's a grave error in DT. I guess you
could assume something but the fact is that you know you don't know.

> 
> > Could you also document which endpoint properties are mandatory and which
> > ones optional?
> 
> Will do, although I'm not sure there are any required properties.

data-lanes, among other things?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
