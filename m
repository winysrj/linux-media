Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50714
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933579AbdHYPME (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 11:12:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 0/7] document types of hardware control for V4L2
Date: Fri, 25 Aug 2017 12:11:50 -0300
Message-Id: <cover.1503673702.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2010, we introduced a new way to control complex V4L2 devices used
on embedded systems, but this was never documented, nor it is possible
for an userspace applicatin to detect the kind of control a device supports.

This series fill the gap.

Mauro Carvalho Chehab (7):
  media: add glossary.rst with a glossary of terms used at V4L2 spec
  media: open.rst: better document device node naming
  media: open.rst: remove the minor number range
  media: open.rst: document devnode-centric and mc-centric types
  media: open.rst: Adjust some terms to match the glossary
  media: videodev2: add a flag for MC-centric devices
  media: open.rst: add a notice about subdev-API on vdev-centric

v3:

- Add a glossary to be used by the new documentation about hardware control;
- Add a patch removing minor number range
- Use glossary terms at open.rst
- Split the notice about subdev-API on vdev-centric, as this change
   will require further discussions.

v2:

- added a patch at the beginning of the series better defining the
  device node naming rules;
- better defined the differenes between device hardware and V4L2 device node
  as suggested by Laurent and with changes proposed by Hans and Sakari
- changed the caps flag to indicate MC-centric devices
- removed the final patch that would use the new caps flag. I'll write it
  once we agree on the new caps flag.


 Documentation/media/uapi/v4l/glossary.rst        |  95 +++++++++++++++++
 Documentation/media/uapi/v4l/open.rst            | 125 ++++++++++++++++++++---
 Documentation/media/uapi/v4l/v4l2.rst            |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst |   5 +
 include/uapi/linux/videodev2.h                   |   2 +
 5 files changed, 214 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

-- 
2.13.3
