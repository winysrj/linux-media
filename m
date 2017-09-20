Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50308
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751700AbdITTL7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:11:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        knightrider@are.ma, Max Kellermann <max.kellermann@gmail.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-doc@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 00/25] DVB cleanups and documentation improvements
Date: Wed, 20 Sep 2017 16:11:25 -0300
Message-Id: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series comes after a previous patchset with DVB fixes.
both series are there at:

   https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb-fixes-v3

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

PS.: there is one patch in this series that really belongs to kernel-doc
tree. I sent it already in separate, but, as without it several kernel-doc
markups are ignored, I'm adding it here for consistency.

Mauro Carvalho Chehab (24):
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
  scripts: kernel-doc: fix nexted handling
  media: dmxdev.h: add kernel-doc markups for data types and functions
  media: dtv-demux.rst: parse other demux headers with kernel-doc
  media: dvb-net.rst: document DVB network kAPI interface
  media: dvb uAPI docs: get rid of examples section

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
 drivers/media/dvb-core/dmxdev.h                  |  90 +++-
 drivers/media/dvb-core/dvb_demux.c               |  17 +-
 drivers/media/dvb-core/dvb_demux.h               | 248 +++++++++-
 drivers/media/dvb-core/dvb_frontend.c            | 180 +++----
 drivers/media/dvb-core/dvb_frontend.h            |  94 ++--
 drivers/media/dvb-core/dvb_net.h                 |  34 +-
 drivers/media/dvb-core/dvbdev.c                  |  34 +-
 drivers/media/dvb-core/dvbdev.h                  | 137 +++++-
 drivers/media/pci/ttpci/av7110.c                 |   2 +-
 drivers/media/pci/ttpci/budget-core.c            |   2 +-
 include/uapi/linux/dvb/frontend.h                |   2 +-
 scripts/kernel-doc                               |   2 +-
 20 files changed, 1248 insertions(+), 1141 deletions(-)
 create mode 100644 Documentation/media/kapi/dtv-ca.rst
 create mode 100644 Documentation/media/kapi/dtv-common.rst
 create mode 100644 Documentation/media/kapi/dtv-demux.rst
 create mode 100644 Documentation/media/kapi/dtv-frontend.rst
 create mode 100644 Documentation/media/kapi/dtv-net.rst

-- 
2.13.5
