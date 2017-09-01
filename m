Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47012
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752156AbdIANZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
Date: Fri,  1 Sep 2017 10:24:22 -0300
Message-Id: <cover.1504272067.git.mchehab@s-opensource.com>
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

There is still a gap at the CA API, as there are three ioctls that are used
only by a few drivers and whose structs are not properly documented:
CA_GET_MSG, CA_SEND_MSG and CA_SET_DESCR.

The first two ones seem to be related to a way that a few drivers
provide to send/receive messages. Yet, I was unable to get what
"index" and "type" means on those ioctls. The CA_SET_DESCR is
only supported by av7110 driver, and has an even weirder
undocumented struct. I was unable to discover at the Kernel, VDR
or Kaffeine how those structs are filled. I suspect that there's
something wrong there, but I won't risk trying to fix without
knowing more about them. So, let's just document that those
are needing documentation :-)

---

v2: Added CA API patches at the end and verified that everything
compiles after each patch. Also do some fixes at dst_ca for it
to report the error code to userspace and remove boilerplate
code there.

Mauro Carvalho Chehab (27):
  media: ca.h: split typedefs from structs
  media: dmx.h: split typedefs from structs
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
  media: ca.h: get rid of CA_SET_PID
  media: ca.h: document most CA data types
  media: dst_ca: return a proper error code from CA errors
  media: ca-reset.rst: add some description to this ioctl
  media: ca-get-cap.rst: document this ioctl
  media: ca-get-slot-info.rst: document this ioctl
  media: ca-get-descr-info.rst: document this ioctl
  media: dvb CA docs: place undocumented data together with ioctls
  media: dvb rst: identify the documentation gap at the API
  media: dst_ca: remove CA_SET_DESCR boilerplate

 Documentation/media/ca.h.rst.exceptions            |    1 -
 Documentation/media/dmx.h.rst.exceptions           |   20 +-
 Documentation/media/dvb-drivers/ci.rst             |    1 -
 Documentation/media/frontend.h.rst.exceptions      |  185 ++-
 Documentation/media/uapi/dvb/ca-get-cap.rst        |   36 +-
 Documentation/media/uapi/dvb/ca-get-descr-info.rst |   29 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |   38 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  |   98 +-
 Documentation/media/uapi/dvb/ca-reset.rst          |    3 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |   10 +
 Documentation/media/uapi/dvb/ca-set-pid.rst        |   60 -
 Documentation/media/uapi/dvb/ca.rst                |    5 +
 Documentation/media/uapi/dvb/ca_data_types.rst     |  103 +-
 Documentation/media/uapi/dvb/ca_function_calls.rst |    1 -
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
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst   |    5 +
 Documentation/media/uapi/dvb/net.rst               |    1 -
 drivers/media/dvb-core/dmxdev.c                    |    4 +-
 drivers/media/dvb-core/dvb_frontend.c              |   11 +
 drivers/media/pci/bt8xx/dst_ca.c                   |   70 +-
 drivers/media/pci/ttpci/av7110.h                   |    2 +-
 drivers/media/pci/ttpci/av7110_ca.c                |   12 +-
 include/uapi/linux/dvb/ca.h                        |  128 +-
 include/uapi/linux/dvb/dmx.h                       |  191 ++-
 include/uapi/linux/dvb/frontend.h                  |  591 +++++++--
 45 files changed, 1267 insertions(+), 2880 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/ca-set-pid.rst
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
