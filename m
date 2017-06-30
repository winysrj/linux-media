Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50221 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbdF3OfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>
Subject: [RFC PATCH 00/12] cec: add low-level pin driver/monitoring
Date: Fri, 30 Jun 2017 16:34:57 +0200
Message-Id: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is something I have been working on for some time now.
The initial use-case was for the Allwinner A10 SoC which supported CEC
but only by polling the CEC bus. It turned out that being able to
access the CEC bus at such a low-level was also ideal for debugging CEC
problems (bad timings etc) and to do error injection.

Since these old Allwinner SoCs aren't all that easy to get these days
I decided to try to use the same code but using a GPIO pin on a
Raspberry Pi (tested with both 2B and 3) since those are widely
available.

Of course, the cec-gpio driver can be used with any pull-up gpio on
any SoC.

This patch series first makes some small changes in the CEC framework
(patches 1-4) to prepare for this CEC pin support.

Patch 5-6 adds the new API elements and documents it.

Patch 7 reworks the CEC core event handling.

Patch 8 adds pin monitoring support (allows userspace to see all
CEC pin transitions as they happen).

Patch 9 adds the core cec-pin implementation that translates low-level
pin transitions into valid CEC messages. Basically this does what any
SoC with a proper CEC hardware implementation does.

Patch 10-11 add a little cec-gpio driver that sits on top of the cec-pin
code. Note that patch 10 is not quite complete: I want to add optional
cec-notifier support as well so the gpio pin can be 'connected' to the
HDMI controller and be notified when the physical address changes.

Patch 12 adds an example dts snippet with support for cec-gpio to the
Rpi dts. In the final version this should change to a
Documentation/devicetree/bindings/media/cec-gpio.txt file.

Patches 1-9 are basically ready for 4.14, although I will probably
clean up a few things in cec-pin.c/h.

Maxime, this series does not contain the A10 support yet. I have that
in this (somewhat old) branch:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cubie-cec-pin

If you look in sun4i_hdmi_enc.c:

https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c?h=cubie-cec-pin

and search for 'cec' you'll see that the CEC implementation is now
tiny since all the work is now done in cec-pin.c. All that this driver
needs to implement are the pin read/low/high ops which are literally
one-liners. Once 4.13-rc1 is released I will rebase this patch series
and add patches for the sun4i CEC driver.

Eric, don't confuse this with the real Rpi CEC driver. As I mentioned
to you in another email I'm waiting for 4.13-rc1 to be released and
then I'll clean up my rpi patch series and repost for inclusion in
4.14.

This gpio driver in combination with a Raspberry Pi is ideal for
debugging since the rpi is so widely available.

I will post a patch to the cec-ctl utility that supports this new
pin monitoring API separately. It is able to fully analyze the CEC
traffic, and esp. when using the GPIO interrupt it is also very
accurate. And much, much cheaper than a full fledged CEC analyzer.

And for the record, I've used this quite successfully at Cisco while
debugging CEC issues :-)

For those who are interested: some code for error injection is available
here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cec-error-inj

But it needs a lot more work, esp. with regards to the API design. So
this is not planned for 4.14 but more likely 4.15.

Regards,

	Hans

Hans Verkuil (12):
  cec: improve transmit timeout logging
  cec: add *_ts variants for transmit_done/received_msg
  cec: add adap_free op
  cec-core.rst: document the adap_free callback
  linux/cec.h: add pin monitoring API support
  cec: document the new CEC pin capability, events and mode
  cec: rework the cec event handling
  cec: add core support for low-level CEC pin monitoring
  cec-pin: add low-level pin hardware support
  cec-gpio: add CEC GPIO driver
  MAINTAINERS: add cec-gpio entry
  rpi: add cec-gpio support to dts

 Documentation/media/kapi/cec-core.rst              |  10 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   7 +
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  20 +
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  19 +-
 MAINTAINERS                                        |   8 +
 arch/arm/boot/dts/bcm2836-rpi-2-b.dts              |   5 +
 arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts   |   5 +
 drivers/media/Kconfig                              |   3 +
 drivers/media/cec/Makefile                         |   4 +
 drivers/media/cec/cec-adap.c                       | 196 ++++--
 drivers/media/cec/cec-api.c                        |  73 +-
 drivers/media/cec/cec-core.c                       |   2 +
 drivers/media/cec/cec-pin.c                        | 784 +++++++++++++++++++++
 drivers/media/platform/Kconfig                     |  10 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cec-gpio/Makefile           |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         | 214 ++++++
 include/media/cec-pin.h                            | 113 +++
 include/media/cec.h                                |  64 +-
 include/uapi/linux/cec.h                           |   8 +-
 20 files changed, 1449 insertions(+), 99 deletions(-)
 create mode 100644 drivers/media/cec/cec-pin.c
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c
 create mode 100644 include/media/cec-pin.h

-- 
2.11.0
