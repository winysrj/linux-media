Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:58015 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbeEROlD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:41:03 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 0/9] rcar-vin: Add support for parallel input on Gen3
Date: Fri, 18 May 2018 16:40:36 +0200
Message-Id: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series adds support for parallel video input to the Gen3 version of
rcar-vin driver.

Thanks to Niklas' review of v2, this new version allows the same VIN instance
to have both a parallel and a CSI-2 subdevice connected, and to switch
between them at runtime through the modification of links between the media
controller entities in the media-controller graph.

The series starts with a rename s/digital/parallel, as the use of the term
digital was not appropriate and Niklas agreed on the change.

Then a group-wise notifier is created. As detailed in the commit message, to
avoid registering the same notifier twice, for parallel and CSI-2 subdevices,
a shared one is created and used to collect all CSI-2 subdevs for the group.

As we can now switch between CSI-2 and digital subdevs, the media bus
configuration properties have been removed from the VIN device, and cached
in a dedicated structure. They will be taken into account only when a parallel
subdevice is linked to the VIN instance, as suggested by Niklas.

The parallel input parsing has been moved to probe function, and the involved
functions modified to take the media-controller case into account. Again, this
was initially suggested by Niklas, but I failed to do this in v2.

Once the parallel subdevice is collected and bound, at 'complete' time a link
in the media controller has to be created if we're running on an mc-compliant
configuration. This makes the parallel complete function a bit more verbose.

Last step is to properly handle the link state change notification function,
switching between CSI-2 and parallel inputs. This patch is almost the
same as the v2 one, handling of the 'is_csi' flag apart.

At the end of the series, after a small cleanup requested by Niklas, support
for the R8A77995 SoC is added to the driver.

Testing:
As there are no boards I'm aware of with both CSI-2 and digital subdevs
connected to the same VIN instance, I have faked that on a Salvator-x M3-W
board, registering an adv7612 chip connected to VIN5 instance, where also
a CSI20 and CSI40 are routed to. For the interested, the testing branch is
available at:
git://jmondi.org/linux d3/media-master/salvator-x-dts_csi2/digital_input

Image capture from HDMI input works as expected, as well as link switching.
Of course capturing from adv7612 is not tested, as the chip is not actually
there.

On D3, where a single parallel input provided by an adv7612 is connected to
VIN4, image capture from the HDMI port has been tested using a modified version
of vin-tests available at:
git://jmondi.org/vin-tests d3

and an additional patch to Draak device tree to enable HDMI capture, which is
by default disabled in favor of CVBS one:
git://jmondi.org/linux d3/media-master/salvator-x-dts_csi2/d3-hdmi

Image capture from HDMI works as expected with a 640x480 image source.

No changelog as the series is changed quite significantly from v2 and v1 and
is fully described in this cover letter.

Thanks Niklas for the prompt review of v1 and v2, I hope this one is closer
to what is expected to properly support parallel capture on Gen3 boards.

(On a side note, am I wrong or with this series we may easily move all Gen2
devices to run with media-controller without any major modifications?)

Thanks
   j

Jacopo Mondi (9):
  media: rcar-vin: Rename 'digital' to 'parallel'
  media: rcar-vin: Remove two empty lines
  media: rcar-vin: Create a group notifier
  media: rcar-vin: Cache the mbus configuration flags
  media: rcar-vin: Parse parallel input on Gen3
  media: rcar-vin: Link parallel input media entities
  media: rcar-vin: Handle parallel subdev in link_notify
  media: rcar-vin: Rename _rcar_info to rcar_info
  media: rcar-vin: Add support for R-Car R8A77995 SoC

 drivers/media/platform/rcar-vin/rcar-core.c | 318 +++++++++++++++++++---------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  28 ++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  31 ++-
 4 files changed, 260 insertions(+), 129 deletions(-)

--
2.7.4
