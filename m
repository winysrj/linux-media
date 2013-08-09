Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54859 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031449Ab3HIXCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 00/19] Common Display Framework
Date: Sat, 10 Aug 2013 01:02:59 +0200
Message-Id: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third RFC of the Common Display Framework. This is a resent, the
series I've sent earlier seems not to have made it to the vger mailing lists,
possibly due to a too long list of CCs (the other explanation being that CDF
has been delayed for so long that vger considers it as spam, which I really
hope isn't the case :-)). I've thus dropped the CCs, sorry about that.

I won't repeat all the background information from the versions one and two
here, you can read it at http://lwn.net/Articles/512363/ and
http://lwn.net/Articles/526965/.

This RFC isn't final. Given the high interest in CDF and the urgent tasks that
kept delaying the next version of the patch set, I've decided to release v3
before completing all parts of the implementation. Known missing items are

- documentation: kerneldoc and this cover letter should provide basic
  information, more extensive documentation will likely make it to v4.

- pipeline configuration and control: generic code to configure and control
  display pipelines (in a nutshell, translating high-level mode setting and
  DPMS calls to low-level entity operations) is missing. Video and stream
  control operations have been carried over from v2, but will need to be
  revised for v4.

- DSI support: I still have no DSI hardware I can easily test the code on.

Special thanks go to

- Renesas for inviting me to LinuxCon Japan 2013 where I had the opportunity
  to validate the CDF v3 concepts with Alexandre Courbot (NVidia) and Tomasz
  Figa (Samsung).

- Tomi Valkeinen (TI) for taking the time to deeply brainstorm v3 with me.

- Linaro for inviting me to Linaro Connect Europe 2013, the discussions we had
  there greatly helped moving CDF forward.

- And of course all the developers who showed interest in CDF and spent time
  sharing ideas, reviewing patches and testing code.

I have to confess I was a bit lost and discouraged after all the CDF-related
meetings during which we have discussed how to move from v2 to v3. With every
meeting I was hoping to run the implementation through use cases of various
interesting parties and narrow down the scope of the huge fuzzy beast that CDF
was. With every meeting the scope actually broadened, with no clear path at
sight anywhere.

Earlier this year I was about to drop one of the requirements on which I had
based CDF v2: sharing drivers between DRM/KMS and V4L2. With only two HDMI
transmitters as use cases for that feature (with only out-of-tree drivers so
far), I just thought the involved completely wasn't worth it and that I should
implement CDF v3 as a DRM/KMS-only helper framework. However, a seemingly
unrelated discussion with Xilinx developers showed me that hybrid SoC-FPGA
platforms such as the Xilinx Zynq 7000 have a larger library of IP cores that
can be used in camera capture pipelines and in display pipelines. The two use
cases suddenly became tens or even hundreds of use cases that I couldn't
ignore anymore.

CDF v3 is thus userspace API agnostic. It isn't tied to DRM/KMS or V4L2 and
can be used by any kernel subsystem, potentially including FBDEV (although I
won't personally wrote FBDEV support code, as I've already advocated for FBDEV
to be deprecated).

The code you are about to read is based on the concept of display entities
introduced in v2. Diagrams related to the explanations below are available at
http://ideasonboard.org/media/cdf/20130709-lce-cdf.pdf.


Display Entities
----------------

A display entity abstracts any hardware block that sources, processes or sinks
display-related video streams. It offers an abstract API, implemented by display
entity drivers, that is used by master drivers (such as the main display driver)
to query, configure and control display pipelines.

Display entities are connected to at least one video data bus, and optionally
to a control bus. The video data busses carry display-related video data out
of sources (such as a CRTC in a display controller) to sinks (such as a panel
or a monitor), optionally going through transmitters, encoders, decoders,
bridges or other similar devices. A CRTC or a panel will usually be connected
to a single data bus, while an encoder or a transmitter will be connected to
two data busses.

The simple linear display pipelines we find in most embedded platforms at the
moment are expected to grow more complex with time. CDF needs to accomodate
those needs from the start to be, if not future-proof, at least present-proof
at the time it will get merged in to mainline. For this reason display
entities have data ports through which video streams flow in or out, with link
objects representing the connections between those ports. A typical entity in
a linear display pipeline will have one (for video source and video sink
entities such as CRTCs or panels) or two ports (for video processing entities
such as encoders), but more ports are allowed, and entities can be linked in
complex non-linear pipelines.

Readers might think that this model if extremely similar to the media
controller graph model. They would be right, and given my background this is
most probably not a coincidence. The CDF v3 implementation uses the in-kernel
media controller framework to model the graph of display entities, with the
display entity data structure inheriting from the media entity structure. The
display pipeline graph topology will be automatically exposed to userspace
through the media controller API as an added bonus. However, ussage of the
media controller userspace API in applications is *not* mandatory, and the
current CDF implementation doesn't use the media controller link setup
userspace API to configure the display pipelines.

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
thus standard Linux kernel drivers using existing busses. A DBI bus is added
as part of this patch set, but strictly speaking this isn't part of CDF.

When a display entity driver probes a device it must create an instance of the
display_entity structure, initialize it and add it to the CDF core entities
pool. The display entity exposes abstract operations through function
pointers, and the entity driver must implement those operations. Those
operations can act on either the whole entity or on a given port, depending on
the operation. They are divided in two groups, control operations and video
operations.


Control Operations
------------------

Control operations are called by upper-level drivers, usually in response to a
request originating from userspace. They query or control the display entity
state and operation. Currently defined control operations are

- get_size(), to retrieve the entity physical size (applicable to panels only)
- get_modes(), to retrieve the video modes supported at an entity port
- get_params(), to retrieve the data bus parameters at an entity port

- set_state(), to control the state of the entity (off, standby or on)
- update(), to trigger a display update (for entities that implement manual
  update, such as manual-update panels that store frames in their internal
  frame buffer)

The last two operations have been carried from v2 and will be reworked.


Pipeline Control
----------------

The figure on page 4 shows the control model for a linear pipeline. This
differs significantly from CDF v2 where calls where forwarded from entity to
entity using a Russian dolls model. v3 removes the need of neighbour awareness
from entity drivers, simplifying the entity drivers. The complexity of pipeline
configuration is moved to a central location called a pipeline controller
instead of being spread out to all drivers.

Pipeline controllers provide library functions that display drivers can use to
control a pipeline. Several controllers can be implemented to accomodate the
needs of various pipeline topologies and complexities, and display drivers can
even implement their own pipeline control algorithm if needed. I'm working on a
linear pipeline controller for the next version of the patch set.

If pipeline controllers are responsible for propagating a pipeline configuration
on all entity ports in the pipeline, entity drivers are responsible for
propagating the configuration inside entities, from sink (input) to source
(output) ports as illustrated on page 5. The rationale behind this is that
knowledge of the entity internals is located in the entity driver, while
knowledge of the pipeline belongs to the pipeline controller. The controller
will thus configure the pipeline by performing the following steps:

- applying a configuration on sink ports of an entity
- read the configuration that has been propagated by the entity driver on its
  source ports
- optionally, modify the source port configuration (to configure custom timings,
  scaling or other parameters, if supported by the entity)
- propagate the source port configuration to the sink ports of the next entities
  in the pipeline and start over

Beside modifying the active configuration, the entities API will allow trying
configurations without applying them to the hardware. As configuration of a port
possibly depend on the configurations of the other ports, trying a configuration
must be done at the entity level instead of the port level. The implementation
will be based on the concept of configuration store objects that will store the
configuration of all ports for a given entity. Each entity will have a single
active configuration store, and test configuration stores will be created
dynamically to try a configuration on an entity. The get and set operations
implemented by the entity will receive a configuration store pointer, and active
and test code paths in entity drivers will be identical, except for applying the
configuration to the hardware for the active code path.


Video Operations
----------------

Video operations control the video stream state on entity ports. The only
currently defined video operation is

- set_stream(), to start (in continuous or single-shot mode) the video stream
  on an entity port

The call model for video operations differ from the control operations model
described above. The set_stream() operation is called directly by downstream
entities on upstream entities (from a video data bus point of view).
Terminating entities in a pipeline (such as panels) will usually call the
set_stream() operation in their set_state() handler, and intermediate entities
will forward the set_stream() call upstream.


Integration
-----------

The figure on page 8 describes how a panel driver, implemented using CDF as a
display entity, interacts with the other components in the system. The use case
is a simple pipeline made of a display controller and a panel.

The display controller driver receives control request from userspace through
DRM (or FBDEV) API calls. It processes the request and calls the panel driver
through the CDF control operations API. The panel driver will then issue
requests on its control bus (several possible control busses are shown on the
figure, panel drivers typically use one of them only) and call video operations
of the display controller on its left side to control the video stream.


Registration and Notification
-----------------------------

Due to possibly complex dependencies between entities we can't guarantee that
all entities part of the display pipeline will have been successfully probed
when the master display controller driver is probed. For instance a panel can
be a child of the DBI or DSI bus controlled by the display device, or use a
clock provided by that device. We can't defer the display device probe until
the panel is probed and also defer the panel device probe until the display
device is probed. For this reason we need a notification system that allows
entities to register themselves with the CDF core, and display controller
drivers to get notified when entities they need are available.

The notification system has been completely redesigned in v3. This version is
based on the V4L2 asynchronous probing notification code, with large parts of
the code shamelessly copied. This is an interim solution to let me play with
the notification code as needed by CDF. I'm not a fan of code duplication, and
will work on merging the CDF and V4L2 implementations in a later stage when
CDF will reach a mature enough state.

CDF manages a pool of entities and a list of notifiers. Notifiers are
registered by master display drivers with an array of entities match
descriptors. When an entity is added to the CDF entities pool, all notifiers
are searched for a match. If a match is found, the corresponding notifier is
called to notify the master display driver.

The two currently supported match methods are platform match, which uses
device names, and DT match, which uses DT node pointers. More match method
might be added later if needed. Two helper functions exist to build a notifier
from a list of platform device names (in the non-DT case) or a DT
representation of the display pipeline topology.

Once all required entities have been successfully found, the master display
driver is responsible for creating media controller links between all entities
in the pipeline. Two helper functions are also available to automate that
process, one for the non-DT case and one for the DT case. Once again some
DT-related code has been copied from the V4L2 DT code, I will work on merging
both in a future version.

Note that notification brings a different issue after registration, as display
controller and display entity drivers would take a reference to each other.
Those circular references would make driver unloading impossible. One possible
solution to this problem would be to simulate an unplug event for the display
entity, to force the display driver to release the dislay entities it uses. We
would need a userspace API for that though. Better solutions would of course
be welcome.


Device Tree Bindings
--------------------

CDF entities device tree bindings are not documented yet. They describe both
the graph topology and entity-specific information. The graph description uses
the V4L2 DT bindings (which are actually not V4L2-specific) specified at
Documentation/devicetree/bindings/media/video-interfaces.txt. Entity-specific
information will be described in individual DT bindings documentation. The DPI
panel driver uses the display timing bindings documented in
Documentation/devicetree/bindings/video/display-timing.txt.




Please note that most of the display entities on devices I own are just dumb
panels with no control bus, and are thus not the best candidates to design a
framework that needs to take complex panels' needs into account. This is why I
hope to see you using the CDF with your display device and tell me what needs to
be modified/improved/redesigned.

This patch set is split as follows:

- The first patch fixes a Kconfig namespace issue with the OMAP DSS panels. It
  could be applied already independently of this series.
- Patches 02/19 to 07/19 add the CDF core, including the notification system
  and the graph and OF helpers.
- Patch 08/19 adds a MIPI DBI bus. This isn't part of CDF strictly speaking,
  but is needed for the DBI panel drivers.
- Patches 09/19 to 13/19 add panel drivers, a VGA DAC driver and a VGA
  connector driver.
- Patches 14/19 to 18/19 add CDF-compliant reference board code and DT for the
  Renesas Marzen and Lager boards.
- Patch 19/19 port the Renesas R-Car Display Unit driver to CDF.

The patches are available in my git tree at

    git://linuxtv.org/pinchartl/fbdev.git cdf/v3
    http://git.linuxtv.org/pinchartl/fbdev.git/shortlog/refs/heads/cdf/v3

For convenience I've included modifications to the Renesas R-Car Display Unit
driver to use the CDF. You can read the code to see how the driver uses CDF to
interface panels. Please note that the rcar-du-drm implementation is still
work in progress, its set_stream operation implementation doesn't enable and
disable the video stream yet as it should.

As already mentioned in v2, I will appreciate all reviews, comments,
criticisms, ideas, remarks, ... If you can find a clever way to solve the
cyclic references issue described above I'll buy you a beer at the next
conference we will both attend. If you think the proposed solution is too
complex, or too simple, I'm all ears, but I'll have more arguments this time
than I had with v2 

Laurent Pinchart (19):
  OMAPDSS: panels: Rename Kconfig options to OMAP2_DISPLAY_*
  video: Add Common Display Framework core
  video: display: Add video and stream control operations
  video: display: Add display entity notifier
  video: display: Graph helpers
  video: display: OF support
  video: display: Add pixel coding definitions
  video: display: Add MIPI DBI bus support
  video: panel: Add DPI panel support
  video: panel: Add R61505 panel support
  video: panel: Add R61517 panel support
  video: display: Add VGA Digital to Analog Converter support
  video: display: Add VGA connector support
  ARM: shmobile: r8a7790: Add DU clocks for DT
  ARM: shmobile: r8a7790: Add DU device node to device tree
  ARM: shmobile: marzen: Port DU platform data to CDF
  ARM: shmobile: lager: Port DU platform data to CDF
  ARM: shmobile: lager-reference: Add display device nodes to device
    tree
  drm/rcar-du: Port to the Common Display Framework

 arch/arm/boot/dts/r8a7790-lager-reference.dts |  92 ++++
 arch/arm/boot/dts/r8a7790.dtsi                |  33 ++
 arch/arm/mach-shmobile/board-lager.c          |  76 ++-
 arch/arm/mach-shmobile/board-marzen.c         |  77 ++-
 arch/arm/mach-shmobile/clock-r8a7790.c        |   5 +
 drivers/gpu/drm/rcar-du/Kconfig               |   3 +-
 drivers/gpu/drm/rcar-du/Makefile              |   7 +-
 drivers/gpu/drm/rcar-du/rcar_du_connector.c   | 164 ++++++
 drivers/gpu/drm/rcar-du/rcar_du_connector.h   |  36 ++
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h        |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c         | 279 ++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_drv.h         |  28 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c     |  87 ++-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.h     |  22 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c         | 116 +++-
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c     | 131 -----
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h     |  25 -
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c      |  96 ----
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.h      |  23 -
 drivers/video/Kconfig                         |   1 +
 drivers/video/Makefile                        |   1 +
 drivers/video/display/Kconfig                 |  62 +++
 drivers/video/display/Makefile                |   9 +
 drivers/video/display/con-vga.c               | 148 +++++
 drivers/video/display/display-core.c          | 759 ++++++++++++++++++++++++++
 drivers/video/display/display-notifier.c      | 542 ++++++++++++++++++
 drivers/video/display/mipi-dbi-bus.c          | 234 ++++++++
 drivers/video/display/panel-dpi.c             | 207 +++++++
 drivers/video/display/panel-r61505.c          | 567 +++++++++++++++++++
 drivers/video/display/panel-r61517.c          | 460 ++++++++++++++++
 drivers/video/display/vga-dac.c               | 152 ++++++
 drivers/video/omap2/displays-new/Kconfig      |  24 +-
 drivers/video/omap2/displays-new/Makefile     |  24 +-
 include/linux/platform_data/rcar-du.h         |  55 +-
 include/video/display.h                       | 398 ++++++++++++++
 include/video/mipi-dbi-bus.h                  | 125 +++++
 include/video/panel-dpi.h                     |  24 +
 include/video/panel-r61505.h                  |  27 +
 include/video/panel-r61517.h                  |  28 +
 39 files changed, 4615 insertions(+), 534 deletions(-)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_connector.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_connector.h
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vgacon.h
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/con-vga.c
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 drivers/video/display/display-notifier.c
 create mode 100644 drivers/video/display/mipi-dbi-bus.c
 create mode 100644 drivers/video/display/panel-dpi.c
 create mode 100644 drivers/video/display/panel-r61505.c
 create mode 100644 drivers/video/display/panel-r61517.c
 create mode 100644 drivers/video/display/vga-dac.c
 create mode 100644 include/video/display.h
 create mode 100644 include/video/mipi-dbi-bus.h
 create mode 100644 include/video/panel-dpi.h
 create mode 100644 include/video/panel-r61505.h
 create mode 100644 include/video/panel-r61517.h

-- 
Regards,

Laurent Pinchart

