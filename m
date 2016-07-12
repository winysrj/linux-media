Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/20] Improve LIRC documentation
Date: Tue, 12 Jul 2016 09:41:54 -0300
Message-Id: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIRC documentation doesn't follow the remaining of the media book.

There's just a single page with all ioctls inside, and, IMHO, not very clear.
Also, the LIRC_CAN flags were not described.

This patchset address these. Also, it removes some LIRC ioctls that aren't
used.

Mauro Carvalho Chehab (20):
  [media] doc-rst: Document ioctl LIRC_GET_FEATURES
  [media] doc-rst: add media/uapi/rc/lirc-header.rst
  [media] lirc.h: remove several unused ioctls
  [media] doc-rst: remove not used ioctls from documentation
  [media] doc-rst: Fix LIRC_GET_FEATURES references
  [media] doc-rst: document ioctl LIRC_GET_SEND_MODE
  [media] doc-rst: fix some lirc cross-references
  [media] doc-rst: document ioctl LIRC_GET_REC_MODE
  [media] doc-rst: document LIRC_GET_REC_RESOLUTION
  [media] doc-rst: document LIRC_SET_SEND_DUTY_CYCLE
  [media] doc-rst: document LIRC_GET_*_TIMEOUT ioctls
  [media] doc-rst: Document LIRC_GET_LENGTH ioctl
  [media] doc-rst: document LIRC set carrier ioctls
  [media] doc-rst: document LIRC_SET_TRANSMITTER_MASK
  [media] doc-rst: document LIRC_SET_REC_TIMEOUT
  [media] doc-rst: document LIRC_SET_REC_TIMEOUT_REPORTS
  [media] doc-rst: add documentation for LIRC_SET_MEASURE_CARRIER_MODE
  [media] doc-rst: document LIRC_SET_WIDEBAND_RECEIVER
  [media] doc-rst: Document LIRC set mode ioctls
  [media] doc-rst: reorganize LIRC ReST files

 Documentation/media/lirc.h.rst.exceptions          |  39 +--
 .../rc/{lirc_dev_intro.rst => lirc-dev-intro.rst}  |  34 +++
 .../rc/{lirc_device_interface.rst => lirc-dev.rst} |   7 +-
 Documentation/media/uapi/rc/lirc-func.rst          |  28 +++
 Documentation/media/uapi/rc/lirc-get-features.rst  | 181 ++++++++++++++
 Documentation/media/uapi/rc/lirc-get-length.rst    |  45 ++++
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  45 ++++
 .../media/uapi/rc/lirc-get-rec-resolution.rst      |  49 ++++
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  45 ++++
 Documentation/media/uapi/rc/lirc-get-timeout.rst   |  55 +++++
 Documentation/media/uapi/rc/lirc-header.rst        |  10 +
 .../media/uapi/rc/{lirc_read.rst => lirc-read.rst} |  10 +-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      |  48 ++++
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |  49 ++++
 .../media/uapi/rc/lirc-set-rec-carrier.rst         |  48 ++++
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |  49 ++++
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |  52 ++++
 .../media/uapi/rc/lirc-set-send-carrier.rst        |  43 ++++
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |  49 ++++
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    |  53 ++++
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |  56 +++++
 .../uapi/rc/{lirc_write.rst => lirc-write.rst}     |   4 +-
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 270 ---------------------
 Documentation/media/uapi/rc/remote_controllers.rst |   3 +-
 include/uapi/linux/lirc.h                          |  39 +--
 25 files changed, 956 insertions(+), 355 deletions(-)
 rename Documentation/media/uapi/rc/{lirc_dev_intro.rst => lirc-dev-intro.rst} (52%)
 rename Documentation/media/uapi/rc/{lirc_device_interface.rst => lirc-dev.rst} (67%)
 create mode 100644 Documentation/media/uapi/rc/lirc-func.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-features.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-mode.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-send-mode.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-get-timeout.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-header.rst
 rename Documentation/media/uapi/rc/{lirc_read.rst => lirc-read.rst} (83%)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-send-carrier.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
 rename Documentation/media/uapi/rc/{lirc_write.rst => lirc-write.rst} (94%)
 delete mode 100644 Documentation/media/uapi/rc/lirc_ioctl.rst

-- 
2.7.4


