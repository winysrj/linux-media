Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751183AbdJDVuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v15 00/32] Unified fwnode endpoint parser, async sub-device notifier support, N9 flash DTS
Date: Thu,  5 Oct 2017 00:50:19 +0300
Message-Id: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

	I've dropped the full set from devicetree and linux-acpi lists;
	let me know if you want it back. The entire set is posted to
	linux-media list.

We have a large influx of new, unmerged, drivers that are now parsing
fwnode endpoints and each one of them is doing this a little bit
differently. The needs are still exactly the same for the graph data
structure is device independent. This is still a non-trivial task and the
majority of the driver implementations are buggy, just buggy in different
ways.

Facilitate parsing endpoints by adding a convenience function for parsing
the endpoints, and make the omap3isp and rcar-vin drivers use them as an
example.

To show where we're getting with this, I've added support for async
sub-device notifier support that is notifiers that can be registered by
sub-device drivers as well as V4L2 fwnode improvements to make use of them
and the DTS changes for the Nokia N9. Some of these patches I've posted
previously in this set here:

<URL:http://www.spinics.net/lists/linux-media/msg118764.html>

Since that, the complete callback of the master notifier registering the
V4L2 device is only called once all sub-notifiers have been completed as
well. This way the device node creation can be postponed until all devices
have been successfully initialised.

With this, the as3645a driver successfully registers a sub-device to the
media device created by the omap3isp driver. The kernel also has the
information it's related to the sensor driven by the smiapp driver but we
don't have a way to expose that information yet.

The patches have a dependency to the as3645a driver fixes:

<URL:https://git.kernel.org/pub/scm/linux/kernel/git/j.anaszewski/linux-leds.git/log/?h=fixes-4.14-rc3>

since v14:

- Patch "v4l: fwnode: Support generic parsing of graph endpoints in a
  device" depends on another patch "device property: preserve usecount for
  node passed to of_fwnode_graph_get_port_parent()". Add Depends-on tag.

- Add patch "v4l: async: fix unbind error in
  v4l2_async_notifier_unregister()" by Niklas. Effectively the notifier's
  unbind callback is called before v4l2_async_cleanup(), not after it.

- Fix complete callback error handling (patch "v4l: async: Fix notifier
  complete callback error handling").

- Rework error handling in in v4l2_async_match_notify() and add comments.
  No functional changes there.

- Don't assign sd->dev to NULL in v4l2_async_cleanup() (patch "v4l: async:
  Don't set sd->dev NULL in v4l2_async_cleanup").

- Introduce a function to unbind sub-devices from a notifier. This is a
  common operation so a common implementation is beneficial.

- Assign notifier's v4l2_dev (or sd for sub-device notifiers) NULL on
  failure.

- Make v4l2_async_notifier_unregister() safe to call with a NULL argument.

- Set the implicitly allocated sub-device notifier NULL on async
  sub-device unregistration (used to be a dangling pointer).

- Clean up async sub-device unregistration.

- Fix v4l2_fwnode_endpoint_free() comment to match KernelDoc style, i.e.
  make the function visible in documentation.

- Don't add a random newline near the end of v4l2_async.h.

- Move patch "v4l: fwnode: Move KernelDoc documentation to the header"
  later in the set. The five first patches should now address bugs in the
  V4L2 async framework, causing an oops on complete callback failure.

since v13:

- Add patch "v4l: fwnode: Add a convenience function for registering sensors"
  and make the sensor driver changes a lot smaller.

- Fix v4l2_async_notifier_parse_fwnode_endpoints() error handling for
  omap3isp.

- Return -ENODEV in rcar-vin if no async sub-device is available. I.e. fix
  a bug in previous versions of "rcar-vin: Use generic parser for parsing
  fwnode endpoints".

- Rework notifier completion in patch "v4l: async: Allow binding notifiers to
  sub-devices". This fixes calling complete notifiers more than once; they
  are now all called once when all async sub-devices in all related
  notifiers have been bound.

- Split the same patch ("v4l: async: Allow binding notifiers to
  sub-devices") into two, first one that prepares for async sub-devices
  and another that implements the bulk of support for sub-device notifiers.

- Postpone sub-device bound callback until v4l2_device is available in all
  cases. This also applies to the media device. The notifier's bound
  callback was in some cases called before having v4l2_device in v13.

- Prevent registering fwnodes as async sub-devices more than once.

- Use list_move instead of list_del and list_add in
  v4l2_async_notifier_unbind_all_subdevs.

- Call v4l2_async_notifier_release v4l2_async_notifier_cleanup instead.
  It's a cleanup function and does not release the object passed to it.

- In v4l2_async_notifier_fwnode_parse_endpoint, set match_type field with
  the fwnode.fwnode field, not later.

- In debug and other messages, use port@number/endpoint@number format.

- Call fwnode_handle_put() to release references obtained using e.g.
  fwnode_graph_get_port_parent.

- Multiple KernelDoc documentation fixes.

since v12:

- Merge patches "v4l: fwnode: Support generic parsing of graph endpoints
  in a device" and "v4l: fwnode: Support generic parsing of graph
  endpoints, per port". Improve the commit and KernelDoc documentation as
  well.

- Reformat loop conditions in v4l2_async_notifier_try_complete() and
  v4l2_fwnode_reference_get_int_prop(). Improve comments in
  fwnode_property_get_reference_args() return value handling. Also check
  for -ENODATA in v4l2_fwnode_reference_parse_int_props().

- Add an ACPI example for v4l2_fwnode_reference_get_int_prop().

- Document index parameter, document nprops parameter better and fix
  -EINVAL error code documentation for
  v4l2_fwnode_reference_get_int_prop().

- Use WARN_ON_ONCE(true) instead of WARN_ON_ONCE(1) in
  v4l2_async_notifier_release().

since v11:

- Add patch "et8ek8: Add support for flash and lens devices".

- Add patch "v4l: fwnode: Support generic parsing of graph endpoints, per
  port". The use case for this is to parse only upstream ports in a device
  with sources and sinks. The downstream ports have already been parsed by
  other drivers.

- Rename v4l2_fwnode_reference_parse_sensor_common as
  v4l2_async_notifier_parse_fwnode_sensor_common. This is in line with
  other functions that parse information using fwnode API and set up async
  sub-devices in the notifier.

since v10:

- Rename v4l2_async_get_subdev_notifier as
  v4l2_async_find_subdev_notifier, as this is what it effectively does:
  finds a notifier for a sub-device. Same for v4l2_async_notifier_get_v4l2_dev
  / v4l2_async_notifier_get_v4l2_dev.

- Initialise lists before calling v4l2_async_notifier_call_complete() if
  there are no sub-devices in a notifier.

- Warn on missing sub-device or existing v4l2_device on sub-device
  notifier register, and conversely missing v4l2_device or existing
  sub-device for a master notifier.

- Set notifier's sd and v4l2_dev fields NULL when the sub-device is
  unregistered.

- Document the newly added helper functions for parsing external
  references in v4l2-fwnode.c better.

- Return -ENOENT in v4l2_fwnode_reference_parse if no entries are found,
  and other errors as they occur.

- Turn the loop in v4l2_fwnode_reference_get_int_prop a while loop (was
  for).

- Don't put fwnodes in v4l2_fwnode_reference_parse_int_props.

- Fix description of parent field in struct v4l2_async_notifier.

- In the documentation of v4l2_async_notifier_release, document that this
  function must be called also after
  v4l2_fwnode_reference_parse_sensor_common, not just
  v4l2_async_notifier_parse_fwnode_endpoints. The same goes for
  v4l2_async_notifier_parse_fwnode_endpoints as well as
  v4l2_fwnode_reference_parse_sensor_common.

since v9:

- Drop "as3645a: Switch to fwnode property API" and "ACPI: Document how to
  refer to LEDs from remote nodes" patches. They're better off separately
  from this set.

- Address property documentation redundancy in smiapp DT binding
  documentation.

- Add patches "ov5670: Add support for flash and lens devices" and
  "ov13858: Add support for flash and lens devices".

since v8:

- Improve terminology for notifiers. Instead of master / subdev, we
  have root, parent and subdev notifiers.

- Renamed "flash" property as "flash-leds". There are many, and currently
  we make assumptions in a lot of places (e.g. LED bindings) that these
  are LEDs. While we don't have any other types of flashes supported right
  now (e.g. Xenon), it's safer to assume we might have them in the future.

- Use ENOTCONN instead of EPERM to tell from driver's callback function
  that an endpoint is to be skipped but not handled as an error.

- Avoid accessing notifier's subdevs array as well as num_subdevs field
  from rcar-vin driver.

- Add a patch "v4l: async: Allow async notifier register call succeed with no
  subdevs", which allows, well, what the subject says.

- Move checks for subdev / v4l2_dev from __v4l2_async_notifier_register()
  to v4l2_async_notifier_register() and
  v4l2_async_subdev_notifier_register().

- Don't initialise notifier->list. There was no need to do so, as this is
  the entry added to the list and not used otherwise. I.e. regarding this,
  the state before this patchset is restored.

- Clean up error handling in v4l2_async_notifier_fwnode_parse_endpoint().

- WARN_ON() in v4l2_async_notifier_parse_fwnode_endpoints() if the
  asd_struct_size is smaller than size of struct v4l2_async_subdev.

- Make v4l2_fwnode_reference_parse() static as there should be no need to
  use it outside the V4L2 fwnode framework. Also, remove the callback
  function as well as other arguments that always have the same value in
  current usage. (This can be changed later on if needed without affecting
  drivers.)

- Add the patch "v4l: fwnode: Add a helper function to obtain device /
  interger references", which allows similar use than
  v4l2_fwnode_reference_parse() but is more useful on ACPI based systems
  --- on ACPI, you can only refer to device nodes (corresponding struct
  deice in Linux), not to data extension nodes under the devices.

- Improve v4l2_fwnode_reference_parse_sensor_common() to work on ACPI
  based systems.

- Add patch "ACPI: Document how to refer to LEDs from remote nodes" to
  document using and referring to LEDs on ACPI.

- Rebase the set on AS3645A fixes I just sent ("AS3645A fixes")

- In v4l2_fwnode_reference_parse_sensor_common(), tell if parsing a
  property failed.

- Improved documentation for v4l2_async_notifier_parse_fwnode_endpoints().

- Fix v4l2_async_notifier_try_all_subdevs(); it is allowed that the list
  entry being iterated over is deleted but no other changes to the list
  are allowed. This could be the case if a sub-device driver's notifier
  binds a sub-device. Restart the loop whenever a match is found.

- Add patch "as3645a: Switch to fwnode property API" which also adds ACPI
  support.

since v7:

- Added three more patches:

	v4l: async: Remove re-probing support
	v4l: async: Use more intuitive names for internal functions
	dt: bindings: smiapp: Document lens-focus and flash properties

  The last one was already sent previously after the rest of the patchset.

- Removed re-probing support. This is hard to support and only useful in
  special cases. It can be reintroduced later on if there's really a need
  --- note that in e.g. omap3isp this was always broken and no-one ever
  complained.

- Remove smiapp driver's async complete callback (and ops). It is
  redundant: the sub-device nodes are created through the master notifier.

- Improve flash property documentation in video-interfaces.txt.

- Introduce helper functions to call notifier operations, one for each
  operation.

- Rename v4l2_async_test_notify as v4l2_async_match_notify and
  v4l2_async_belongs to v4l2_async_find_match.

- v4l2_async_notifier_test_all_subdevs() renamed as
  v4l2_async_notifier_try_all_subdevs().

- Made notifier_v4l2_dev a function (it was a macro).

- Registering subdev notifiers from sub-device drivers that control
  sub-devices created through sub-notifiers is now supported. In other
  words, subdev notifiers may be registered through other subdev
  notifiers. This is the source of the bulk of the changes between v7 and
  v8.

- Add explanatory comments to helper functions used by V4L2 async
  framework. This should help understanding the internal workings of the
  framework.

- Removed the "notifiers" list in struct v4l2_async_notifier. The
  information can be found from existing data structures.

- Explicitly check that registering a non-subdev notifier has v4l2_dev and
  a subdev notifier has a sub-device pointer.

- Unified several code paths between subdev notifiers and non-subdev
  notifiers.

- Fixed v4l2_async_notifier_release() --- calling it on a notifier for
  which the driver had allocated the subdevs array would lead calling
  kvfree() on that array. Now notifier->max_subdevs is checked before
  proceeding.

- Fixed a use-after-free issue in
  v4l2_async_notifier_fwnode_parse_endpoints().

- Small fixes to KernelDoc documentation for
  v4l2_async_notifier_parse_fwnode_endpoints().

since v6:

- Drop the last patch that added variant for parsing endpoints given
  specific port and endpoints numbers.

- Separate driver changes from the fwnode endpoint parser patch into two
  patches. rcar-vin driver is now using the name function.

- Use -ENOTCONN to tell the parser that and endpoint (or a reference) is
  to be ignored.

- parse_endpoint and parse_single callback functions are now optional and
  documented as such.

- Added Laurent's patch adding notifier operations struct which I rebase
  on the fwnode parser patchset. I wrote another patch to call the
  notifier operations through macros.

- Add DT bindings for flash and lens devices.

- V4L2 fwnode parser for references (such as flash and lens).

- Added smiapp driver support for async sub-devices (lens and flash).

- Added a few fixes for omap3isp.

since v5:

- Use v4l2_async_ prefix for static functions as well (4th patch)

- Use memcpy() to copy array rather than a loop

- Document that the v4l2_async_subdev pointer in driver specific struct
  must be the first member

- Improve documentation of the added functions (4th and 5th
  patches)

	- Arguments

	- More thorough explation of the purpose, usage and object
	  lifetime

- Added acks

since v4:

- Prepend the set with three documentation fixes.

- The driver's async struct must begin with struct v4l2_async_subdev. Fix this
  for omap3isp and document it.

- Improve documentation for new functions.

- Don't use devm_ family of functions for allocating memory. Introduce
  v4l2_async_notifier_release() to release memory resources.

- Rework both v4l2_async_notifier_fwnode_parse_endpoints() and
  v4l2_async_notifier_fwnode_parse_endpoint() and the local functions they
  call. This should make the code cleaner. Despite the name, for linking
  and typical usage reasons the functions remain in v4l2-fwnode.c.

- Convert rcar-vin to use v4l2_async_notifier_fwnode_parse_endpoint().

- Use kvmalloc() for allocating the notifier's subdevs array.

- max_subdevs argument for notifier_realloc is now the total maximum
  number of subdevs, not the number of available subdevs.

- Use fwnode_device_is_available() to make sure the device actually
  exists.

- Move the note telling v4l2_async_notifier_fwnode_parse_endpoints()
  should not be used by new drivers to the last patch adding
  v4l2_async_notifier_fwnode_parse_endpoint().

since v3:

- Rebase on current mediatree master.

since v2:

- Rebase on CCP2 support patches.

- Prepend a patch cleaning up omap3isp driver a little.

since v1:

- The first patch has been merged (it was a bugfix).

- In anticipation that the parsing can take place over several iterations,
  take the existing number of async sub-devices into account when
  re-allocating an array of async sub-devices.

- Rework the first patch to better anticipate parsing single endpoint at a
  time by a driver.

- Add a second patch that adds a function for parsing endpoints one at a
  time based on port and endpoint numbers.

Laurent Pinchart (1):
  v4l: async: Move async subdev notifier operations to a separate
    structure

Niklas Söderlund (1):
  v4l: async: fix unbind error in v4l2_async_notifier_unregister()

Sakari Ailus (30):
  v4l: async: Remove re-probing support
  v4l: async: Don't set sd->dev NULL in v4l2_async_cleanup
  v4l: async: Fix notifier complete callback error handling
  v4l: async: Correctly serialise async sub-device unregistration
  v4l: async: Use more intuitive names for internal functions
  v4l: async: Add V4L2 async documentation to the documentation build
  v4l: fwnode: Support generic parsing of graph endpoints in a device
  omap3isp: Use generic parser for parsing fwnode endpoints
  rcar-vin: Use generic parser for parsing fwnode endpoints
  omap3isp: Fix check for our own sub-devices
  omap3isp: Print the name of the entity where no source pads could be
    found
  v4l: async: Introduce helpers for calling async ops callbacks
  v4l: async: Register sub-devices before calling bound callback
  v4l: async: Allow async notifier register call succeed with no subdevs
  v4l: async: Prepare for async sub-device notifiers
  v4l: async: Allow binding notifiers to sub-devices
  v4l: async: Ensure only unique fwnodes are registered to notifiers
  dt: bindings: Add a binding for flash LED devices associated to a
    sensor
  dt: bindings: Add lens-focus binding for image sensors
  v4l: fwnode: Move KernelDoc documentation to the header
  v4l: fwnode: Add a helper function for parsing generic references
  v4l: fwnode: Add a helper function to obtain device / integer
    references
  v4l: fwnode: Add convenience function for parsing common external refs
  v4l: fwnode: Add a convenience function for registering sensors
  dt: bindings: smiapp: Document lens-focus and flash-leds properties
  smiapp: Add support for flash and lens devices
  et8ek8: Add support for flash and lens devices
  ov5670: Add support for flash and lens devices
  ov13858: Add support for flash and lens devices
  arm: dts: omap3: N9/N950: Add flash references to the camera

 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   2 +
 .../devicetree/bindings/media/video-interfaces.txt |  10 +
 Documentation/media/kapi/v4l2-async.rst            |   3 +
 Documentation/media/kapi/v4l2-core.rst             |   1 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |   4 +-
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   2 +-
 drivers/media/i2c/ov13858.c                        |   2 +-
 drivers/media/i2c/ov5670.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   8 +-
 drivers/media/platform/atmel/atmel-isc.c           |  10 +-
 drivers/media/platform/atmel/atmel-isi.c           |  10 +-
 drivers/media/platform/davinci/vpif_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif_display.c      |   8 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/omap3isp/isp.c              | 133 ++---
 drivers/media/platform/omap3isp/isp.h              |   5 +-
 drivers/media/platform/pxa_camera.c                |   8 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |   8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        | 117 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c         |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  14 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   4 +-
 drivers/media/platform/rcar_drif.c                 |  10 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  14 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  10 +-
 drivers/media/platform/ti-vpe/cal.c                |   8 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   8 +-
 drivers/media/v4l2-core/v4l2-async.c               | 537 ++++++++++++++----
 drivers/media/v4l2-core/v4l2-fwnode.c              | 623 ++++++++++++++++++---
 drivers/staging/media/imx/imx-media-dev.c          |   8 +-
 include/media/v4l2-async.h                         |  90 ++-
 include/media/v4l2-fwnode.h                        | 220 +++++++-
 include/media/v4l2-subdev.h                        |   3 +
 36 files changed, 1488 insertions(+), 424 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst

-- 
2.11.0
