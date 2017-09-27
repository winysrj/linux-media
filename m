Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33190
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752192AbdI0Vk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 00/37] DVB cleanups and documentation improvements
Date: Wed, 27 Sep 2017 18:40:01 -0300
Message-Id: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series merges a 6 patches series I sent earlier, and a 25 patch
series.

It comes after the patch series with add support for nexted structs/enums
on kernel-doc.

I"m pushing it on my experimental tree:

    https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb-fixes-v5

It is mainly focused on improving the DVB kAPI documentation, making
it (finally!) in sync with the current implementation. It also contains
a patch getting rid of the legacy (non-working) uAPI examples.

While reviewing the code implementation, I noticed some struct fields
that aren't used at all by any DVB driver or core. So, the series gets
rid of them. Others are used only on av7110, and are documented as
such.

After this patch series, both DVB uAPI and kAPI are fully documented
(except for the legacy video/audio/osd uAPI, that doesn't have any
kAPI associated to them).

Granted, some things could be improved at the documentation, but at
least it doesn't carry anymore any big gap or conflict!

Please review and test.

---

v2:

  - merged with a previous 6 patch series;
  - added patches at the end adding support for nexted structs/enums.


Mauro Carvalho Chehab (36):
  media: dvb_frontend: only use kref after initialized
  media: stv0288: get rid of set_property boilerplate
  media: stv6110: get rid of a srate dead code
  media: friio-fe: get rid of set_property()
  media: dvb_frontend: get rid of get_property() callback
  media: dvb_frontend: get rid of set_property() callback
  media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
  media: dvb_frontend: cleanup ioctl handling logic
  media: dvb_frontend: get rid of property cache's state
  media: dvb_frontend.h: fix alignment at the cache properties
  media: dvb_frontend: better document the -EPERM condition
  media: dvb_frontend: fix return values for FE_SET_PROPERTY
  media: dvbdev: convert DVB device types into an enum
  media: dvbdev: fully document its functions
  media: dvb_frontend.h: improve kernel-doc markups
  media: dtv-core.rst: add chapters and introductory tests for common
    parts
  media: dtv-core.rst: split into multiple files
  media: dtv-demux.rst: minor markup improvements
  media: dvb_demux.h: add an enum for DMX_TYPE_* and document
  media: dvb_demux.h: add an enum for DMX_STATE_* and document
  media: dvb_demux.h: get rid of unused timer at struct dvb_demux_filter
  media: dvb_demux: mark a boolean field as such
  media: dvb_demux: dvb_demux_feed.pusi_seen is boolean
  media: dvb_demux.h: get rid of DMX_FEED_ENTRY() macro
  media: dvb_demux: fix type of dvb_demux_feed.ts_type
  media: dvb_demux: document dvb_demux_filter and dvb_demux_feed
  media: dvb_frontend: get rid of dtv_get_property_dump()
  media: dvb_demux.h: document structs defined on it
  media: dvb_demux.h: document functions
  media: dmxdev.h: add kernel-doc markups for data types and functions
  media: dtv-demux.rst: parse other demux headers with kernel-doc
  media: dvb-net.rst: document DVB network kAPI interface
  media: dvb uAPI docs: get rid of examples section
  media: dmxdev: use the newly nested kernel-doc support
  media: dvb_demux: use the newly nested kernel-doc support
  media: frontend: use the newly nested kernel-doc support

Satendra Singh Thakur (1):
  media: dvb_frontend: dtv_property_process_set() cleanups

 Documentation/media/kapi/dtv-ca.rst              |   4 +
 Documentation/media/kapi/dtv-common.rst          |  55 +++
 Documentation/media/kapi/dtv-core.rst            | 574 +----------------------
 Documentation/media/kapi/dtv-demux.rst           |  82 ++++
 Documentation/media/kapi/dtv-frontend.rst        | 443 +++++++++++++++++
 Documentation/media/kapi/dtv-net.rst             |   4 +
 Documentation/media/uapi/dvb/examples.rst        | 378 +--------------
 Documentation/media/uapi/dvb/fe-get-property.rst |   7 +-
 Documentation/media/uapi/dvb/net-types.rst       |   2 +-
 drivers/media/dvb-core/dmxdev.h                  |  95 +++-
 drivers/media/dvb-core/dvb_demux.c               |  17 +-
 drivers/media/dvb-core/dvb_demux.h               | 253 +++++++++-
 drivers/media/dvb-core/dvb_frontend.c            | 534 +++++++++++----------
 drivers/media/dvb-core/dvb_frontend.h            | 117 ++---
 drivers/media/dvb-core/dvb_net.h                 |  34 +-
 drivers/media/dvb-core/dvbdev.c                  |  34 +-
 drivers/media/dvb-core/dvbdev.h                  | 137 +++++-
 drivers/media/dvb-frontends/lg2160.c             |  14 -
 drivers/media/dvb-frontends/stv0288.c            |   7 -
 drivers/media/dvb-frontends/stv6110.c            |   9 -
 drivers/media/pci/ttpci/av7110.c                 |   2 +-
 drivers/media/pci/ttpci/budget-core.c            |   2 +-
 drivers/media/usb/dvb-usb/friio-fe.c             |  24 -
 include/uapi/linux/dvb/frontend.h                |  35 +-
 24 files changed, 1457 insertions(+), 1406 deletions(-)
 create mode 100644 Documentation/media/kapi/dtv-ca.rst
 create mode 100644 Documentation/media/kapi/dtv-common.rst
 create mode 100644 Documentation/media/kapi/dtv-demux.rst
 create mode 100644 Documentation/media/kapi/dtv-frontend.rst
 create mode 100644 Documentation/media/kapi/dtv-net.rst

-- 
2.13.5
