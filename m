Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:44549 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbcFKWcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 18:32:41 -0400
From: Henrik Austad <henrik@austad.us>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	linux-netdev@vger.kernel.org, henrk@austad.us,
	Henrik Austad <henrik@austad.us>
Subject: [very-RFC 0/8] TSN driver for the kernel
Date: Sun, 12 Jun 2016 00:22:13 +0200
Message-Id: <1465683741-20390-1-git-send-email-henrik@austad.us>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all
(series based on v4.7-rc2)

This is a *very* early RFC for a TSN-driver in the kernel. It has been
floating around in my repo for a while and I would appreciate some
feedback on the overall design to avoid doing some major blunders.

TSN: Time Sensitive Networking, formely known as AVB (Audio/Video
Bridging).

There are at least one AVB-driver (the AV-part of TSN) in the kernel
already, however this driver aims to solve a wider scope as TSN can do
much more than just audio. A very basic ALSA-driver is added to the end
that allows you to play music between 2 machines using aplay in one end
and arecord | aplay on the other (some fiddling required) We have plans
for doing the same for v4l2 eventually (but there are other fishes to
fry first). The same goes for a TSN_SOCK type approach as well.

TSN is all about providing infrastructure. Allthough there are a few
very interesting uses for TSN (reliable, deterministic network for audio
and video), once you have that reliable link, you can do a lot more.

Some notes on the design:

The driver is directed via ConfigFS as we need userspace to handle
stream-reservation (MSRP), discovery and enumeration (IEEE 1722.1) and
whatever other management is needed. Once we have all the required
attributes, we can create link using mkdir, and use write() to set the
attributes. Once ready, specify the 'shim' (basically a thin wrapper
between TSN and another subsystem) and we start pushing out frames.

The network part: it ties directly into the rx-handler for receive and
writes skb's using netdev_start_xmit(). This could probably be
improved. 2 new fields in netdev_ops have been introduced, and the Intel
igb-driver has been updated (as this is available as a PCI-e card). The
igb-driver works-ish


What remains
- tie to (g)PTP properly, currently using ktime_get() for presentation
  time
- get time from shim into TSN and vice versa
- let shim create/manage buffer

Henrik Austad (8):
  TSN: add documentation
  TSN: Add the standard formerly known as AVB to the kernel
  Adding TSN-driver to Intel I210 controller
  Add TSN header for the driver
  Add TSN machinery to drive the traffic from a shim over the network
  Add TSN event-tracing
  AVB ALSA - Add ALSA shim for TSN
  MAINTAINERS: add TSN/AVB-entries

 Documentation/TSN/tsn.txt                 | 147 +++++
 MAINTAINERS                               |  14 +
 drivers/media/Kconfig                     |  15 +
 drivers/media/Makefile                    |   3 +-
 drivers/media/avb/Makefile                |   5 +
 drivers/media/avb/avb_alsa.c              | 742 +++++++++++++++++++++++
 drivers/media/avb/tsn_iec61883.h          | 124 ++++
 drivers/net/ethernet/intel/Kconfig        |  18 +
 drivers/net/ethernet/intel/igb/Makefile   |   2 +-
 drivers/net/ethernet/intel/igb/igb.h      |  19 +
 drivers/net/ethernet/intel/igb/igb_main.c |  10 +-
 drivers/net/ethernet/intel/igb/igb_tsn.c  | 396 ++++++++++++
 include/linux/netdevice.h                 |  32 +
 include/linux/tsn.h                       | 806 ++++++++++++++++++++++++
 include/trace/events/tsn.h                | 349 +++++++++++
 net/Kconfig                               |   1 +
 net/Makefile                              |   1 +
 net/tsn/Kconfig                           |  32 +
 net/tsn/Makefile                          |   6 +
 net/tsn/tsn_configfs.c                    | 623 +++++++++++++++++++
 net/tsn/tsn_core.c                        | 975 ++++++++++++++++++++++++++++++
 net/tsn/tsn_header.c                      | 203 +++++++
 net/tsn/tsn_internal.h                    | 383 ++++++++++++
 net/tsn/tsn_net.c                         | 403 ++++++++++++
 24 files changed, 5306 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/TSN/tsn.txt
 create mode 100644 drivers/media/avb/Makefile
 create mode 100644 drivers/media/avb/avb_alsa.c
 create mode 100644 drivers/media/avb/tsn_iec61883.h
 create mode 100644 drivers/net/ethernet/intel/igb/igb_tsn.c
 create mode 100644 include/linux/tsn.h
 create mode 100644 include/trace/events/tsn.h
 create mode 100644 net/tsn/Kconfig
 create mode 100644 net/tsn/Makefile
 create mode 100644 net/tsn/tsn_configfs.c
 create mode 100644 net/tsn/tsn_core.c
 create mode 100644 net/tsn/tsn_header.c
 create mode 100644 net/tsn/tsn_internal.h
 create mode 100644 net/tsn/tsn_net.c

--
2.7.4
