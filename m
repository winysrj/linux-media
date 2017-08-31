Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44938
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751821AbdHaXrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 00/15] Improve DVB documentation and reduce its gap
Date: Thu, 31 Aug 2017 20:46:47 -0300
Message-Id: <cover.1504222628.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB documentation was negligected for a long time, with
resulted on several gaps between the API description and its
documentation.

I'm doing a new reading at the documentation. As result of it,
this series:

- improves the introductory chapter, making it more generic;
- Do some adjustments at the frontend API, using kernel-doc
  when possible.
- Remove unused APIs at DVB demux. I suspect that the drivers
  implementing such APIs were either never merged upstream,
  or the API itself  were never used or was deprecated a long
  time ago. In any case, it doesn't make any sense to carry
  on APIs that aren't properly documented, nor are used on the
  upstream Kernel.

With this patch series, the gap between documentation and
code is solved for 3 DVB APIs:

  - Frontend API;
  - Demux API;
  - Net API.

There is still a gap at the CA API that I'll try to address when I
have some time[1].

[1] There's a gap also on the legacy audio, video and OSD APIs,
    but, as those are used only by a single very old deprecated
    hardware (av7110), it is probably not worth the efforts.

Mauro Carvalho Chehab (15):
  media: dvb/intro: use the term Digital TV to refer to the system
  media: dvb/intro: update references for TV standards
  media: dvb/intro: update the history part of the document
  media: dvb/intro: adjust the notices about optional hardware
  media: dvb/frontend.h: move out a private internal structure
  media: dvb/frontend.h: document the uAPI file
  media: dvb frontend docs: use kernel-doc documentation
  media: fe_property_parameters.rst: better define properties usage
  media: fe_property_parameters.rst: better document bandwidth
  media: dmx.h: get rid of unused DMX_KERNEL_CLIENT
  media: dmx.h: get rid of DMX_GET_CAPS
  media: dmx.h: get rid of DMX_SET_SOURCE
  media: dmx.h: get rid of GET_DMX_EVENT
  media: dmx.h: add kernel-doc markups and use it at Documentation/
  media: net.rst: Fix the level of a section of the net chapter

 Documentation/media/dmx.h.rst.exceptions           |   20 +-
 Documentation/media/frontend.h.rst.exceptions      |  185 ++-
 Documentation/media/uapi/dvb/dmx-get-caps.rst      |   41 -
 Documentation/media/uapi/dvb/dmx-get-event.rst     |   60 -
 Documentation/media/uapi/dvb/dmx-set-source.rst    |   44 -
 Documentation/media/uapi/dvb/dmx_fcalls.rst        |    3 -
 Documentation/media/uapi/dvb/dmx_types.rst         |  225 +---
 Documentation/media/uapi/dvb/dtv-fe-stats.rst      |   17 -
 Documentation/media/uapi/dvb/dtv-properties.rst    |   15 -
 Documentation/media/uapi/dvb/dtv-property.rst      |   31 -
 Documentation/media/uapi/dvb/dtv-stats.rst         |   18 -
 Documentation/media/uapi/dvb/dvbproperty-006.rst   |   12 -
 Documentation/media/uapi/dvb/dvbproperty.rst       |   28 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |   40 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |   31 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |   29 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  370 +-----
 Documentation/media/uapi/dvb/fe-get-property.rst   |    2 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |   83 --
 Documentation/media/uapi/dvb/fe-set-tone.rst       |   30 -
 .../media/uapi/dvb/fe_property_parameters.rst      | 1383 +++-----------------
 Documentation/media/uapi/dvb/frontend-header.rst   |    4 +
 Documentation/media/uapi/dvb/intro.rst             |   76 +-
 Documentation/media/uapi/dvb/net.rst               |    1 -
 drivers/media/dvb-core/dvb_frontend.c              |   11 +
 include/uapi/linux/dvb/dmx.h                       |  171 ++-
 include/uapi/linux/dvb/frontend.h                  |  589 +++++++--
 27 files changed, 1082 insertions(+), 2437 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/dmx-get-caps.rst
 delete mode 100644 Documentation/media/uapi/dvb/dmx-get-event.rst
 delete mode 100644 Documentation/media/uapi/dvb/dmx-set-source.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-fe-stats.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-properties.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-property.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-stats.rst
 delete mode 100644 Documentation/media/uapi/dvb/dvbproperty-006.rst
 create mode 100644 Documentation/media/uapi/dvb/frontend-header.rst

-- 
2.13.5
