Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2KVVon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:44:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: [RFC v2 0/5] Common Display Framework
Date: Thu, 22 Nov 2012 22:45:31 +0100
Message-Id: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Hi everybody,

Here's the second RFC of what was previously known as the Generic Panel
Framework.

I won't repeat all the background information from the first version here, you
can read it at http://lwn.net/Articles/512363/.

Many developers showed interest in the first RFC, and I've had the opportunity
to discuss it with most of them. I would like to thank (in no particular
order) Tomi Valkeinen for all the time he spend helping me to draft v2, Marcus
Lorentzon for his useful input during Linaro Connect Q4 2012, and Linaro for
inviting me to Connect and providing a venue to discuss this topic.

After discussing the Generic Panel Framework at Linaro Connect we came to the 
conclusion that "panel" is too limiting a name. In addition to panel drivers
we also want to share transmitter and bridge drivers between DRM and FBDEV. I
have thus introduced the concept of a display entity in this version to
represent any hardware block that sources, processes or sinks display-related
video streams. This patch set implements the Common Display Framework (CDF).

Display entities are connected to at least one video data bus, and optionally
to a control bus. The video data busses carry display-related video data out
of sources (such as a CRTC in a display controller) to sinks (such as a panel
or a monitor), optionally going through transmitters, encoders, decoders,
bridges or other similar devices. A CRTC or a panel will usually be connected
to a single data bus, while an encoder or a transmitter will be connected to
two data busses.

While some display entities don't require any configuration (DPI panels are a
good example), many of them are connected to a control bus accessible to the
CPU. Control requests can be sent on a dedicated control bus (such as I2C or
SPI) or multiplexed on a mixed control and data bus (such as DBI or DSI). To
support both options the CDF display entity model separates the control and
data busses in different APIs.

Display entities are abstract object that must be implemented by a real
device. The device sits on its control bus and is registered with the Linux
device core and matched with his driver using the control bus specific API.
The CDF doesn't create a display entity class or bus, display entity drivers
thus standard Linux kernel drivers using existing busses.

When a display entity driver probes a device it must create an instance of the
display_entity structure, initialize it and register it with the CDF core. The
display entity exposes abstract operations through function pointers, and the
entity driver must implement those operations. They are divided in two groups,
control operations and video operations.

Control operations are called by upper-level drivers, usually in response to a
request originating from userspace. They control the display entity state and
operation. Currently defined control operations are

- set_state(), to control the state of the entity (off, standby or on)
- update(), to trigger a display update (for entities that implement manual
  update, such as manual-update panels that store frames in their internal
  frame buffer)
- get_modes(), to retrieve the video modes supported by the entity
- get_params(), to retrive the data bus parameters at the entity input (sink)
- get_size(), to retrive the entity physical size (applicable to panels only)

Video operations are called by downstream entities on upstream entities (from
a video data bus point of view) to control the video operation. The only
currently defined video operation is

- set_stream(), to start (in continuous or single-shot mode) the video stream

http://www.ideasonboard.org/media/cdf/cdf.pdf#1 describes how a panel driver
implemented using the CDF interacts with the other components in the system.
The first page shows the panel driver receiving control request from the
display controller driver at its top side, usually in response to a DRM or
FBDEV API call. It then issues requests on its control bus (several possible
control busses are shown on the diagram, the panel driver uses one of them
only) and calls video operations of the display controller on its left side to
control the video stream.

The second page shows a slightly more complex use case, with a display
controller that includes an LVDS transceiver (shown as two separate entities
on the left hand side), connected to an LVDS to DSI converter that is itself
connected to a DSI panel module. The panel module contains a DSI panel
controller that drives the LCD panel. While this particular example is
probably too theoretical to be found in real devices, it illustrates the
concept of display entities chains.

The CDF models this using a Russian doll's model. From the display controller
point of view only the first external entity (LVDS to DSI converter) is
visible. The display controller thus calls the control operations implemented
by the LVDS to DSI transmitter driver (left-most green arrow). The driver is
aware of the next entity in the chain, and relays the call down, possibly
mangling the request and/or the reply, and accessing the device it handles
through its control bus (not shown here). When the operations reaches the last
entity in the chain the video operations are called upstream to control the
video stream.

Display entities are accessed by driver using notifiers. Any driver can
register a display entity notifier with the CDF, which then calls the notifier
when a matching display entity is registered. The reason for this asynchronous
mode of operation, compared to how drivers acquire regulator or clock
resources, is that the display entities can use resources provided by the
display driver. For instance a panel can be a child of the DBI or DSI bus
controlled by the display device, or use a clock provided by that device. We
can't defer the display device probe until the panel is registered and also
defer the panel device probe until the display is registered. As most display
drivers need to handle output devices hotplug (HDMI monitors for instance),
handling other display entities through a notification system seemed to be the
easiest solution.

Note that this brings a different issue after registration, as display
controller and display entity drivers would take a reference to each other.
Those circular references would make driver unloading impossible. One possible
solution to this problem would be to simulate an unplug event for the display
entity, to force the display driver to release the dislay entities it uses. We
would need a userspace API for that though. Better solutions would of course
be welcome.

Please note taht most of the display entities on devices I own are jut dumb
panels with no control bus, and are thus not the best candidates to design a
framework that needs to take complex panels' needs into account. This is why I
hope to see you using the CDF with your display device and tell me what needs
to be modified/improved/redesigned.

This patch set includes three sections:

- The first patch adds the generic display entity core
- The third patch adds a MIPI DBI bus, which is a mixed control and data video
  bus using parallel data (similarly to a microprocessor external data bus)
- The second, fourth and fifth patches add drivers for DPI panels (no control
  bus) and two DBI panel controllers.

The patches are available in my git tree at

    git://linuxtv.org/pinchartl/fbdev.git lcdc-panel
    http://git.linuxtv.org/pinchartl/fbdev.git/shortlog/refs/heads/lcdc-panel

For convenience I've included Steffen's display helpers patches on which this
series is based (see http://www.spinics.net/lists/dri-devel/msg30664.html for
more information about those), as well as modifications to the sh-mobile-lcdc
driver to use the CDF. You can read the code to see how the driver uses the
CDF to interface panels. Please note that the sh-mobile-lcdc implementation is
still work in progress, its set_stream operation implementation doesn't
enable/disable the video stream yet as it should.

I still need to gather notes from v1 and v2 and create proper documentation
from them. I didn't want to delay these patches any longer given the number of
people who were waiting for them, I will try to do work on documentation next
week.

As already mentioned in v1, I will appreciate all reviews, comments,
criticisms, ideas, remarks, ... If you can find a clever way to solve the
cyclic references issue described above I'll buy you a beer at the next
conference we will both attend. If you think the proposed solution is too
complex, or too simple, I'm all ears.

Laurent Pinchart (5):
  video: Add generic display entity core
  video: panel: Add DPI panel support
  video: display: Add MIPI DBI bus support
  video: panel: Add R61505 panel support
  video: panel: Add R61517 panel support

 drivers/video/Kconfig                |    1 +
 drivers/video/Makefile               |    1 +
 drivers/video/display/Kconfig        |   39 +++
 drivers/video/display/Makefile       |    5 +
 drivers/video/display/display-core.c |  362 ++++++++++++++++++++++
 drivers/video/display/mipi-dbi-bus.c |  228 ++++++++++++++
 drivers/video/display/panel-dpi.c    |  147 +++++++++
 drivers/video/display/panel-r61505.c |  554 ++++++++++++++++++++++++++++++++++
 drivers/video/display/panel-r61517.c |  447 +++++++++++++++++++++++++++
 include/video/display.h              |  155 ++++++++++
 include/video/mipi-dbi-bus.h         |  125 ++++++++
 include/video/panel-dpi.h            |   24 ++
 include/video/panel-r61505.h         |   27 ++
 include/video/panel-r61517.h         |   28 ++
 14 files changed, 2143 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 drivers/video/display/mipi-dbi-bus.c
 create mode 100644 drivers/video/display/panel-dpi.c
 create mode 100644 drivers/video/display/panel-r61505.c
 create mode 100644 drivers/video/display/panel-r61517.c
 create mode 100644 include/video/display.h
 create mode 100644 include/video/mipi-dbi-bus.h
 create mode 100644 include/video/panel-dpi.h
 create mode 100644 include/video/panel-r61505.h
 create mode 100644 include/video/panel-r61517.h

-- 
Regards,

Laurent Pinchart

