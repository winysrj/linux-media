Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58243
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751271AbdH1MyJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 08:54:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v5 0/7] document types of hardware control for V4L2
Date: Mon, 28 Aug 2017 09:53:54 -0300
Message-Id: <cover.1503924361.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Kernel 2.6.39, the omap3 driver was introduced together with a new way
to control complex V4L2 devices used on embedded systems, but this was
never documented, as the original idea were to have "soon" support for
standard apps to use it as well, via libv4l, but that didn't happen so far.

Also, it is not possible for an userspace applicatin to detect the kind of
control a device supports.

This series fill the gap, by documenting the new type of hardware
control and adding a way for userspace to detect if the device can be
used or not by an standard V4L2 application.

Notes:
====

1) For the sake of better review, this series start with the addition of a
glossary, as requested by Laurent. Please notice, however, that
the glossary there references some new captions that will only be added
by subsequent patches. So, when this series get applied, the glossary
patch should actually be merged after the patches that introduce those
new captions, in order to avoid warnings for non-existing references.

2) This series doesn't contain patches that actually use the new flag.
This will be added after such patch gets reviewed.

v5:
- Added more terms to the glossary
- Adjusted some wording as proposed by Hans on a few patches
  and added his ack on others

v4:

- Addressed Hans comments for v2;
- Fixed broken references at the glossary.rst

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


Mauro Carvalho Chehab (7):
  media: add glossary.rst with a glossary of terms used at V4L2 spec
  media: open.rst: better document device node naming
  media: open.rst: remove the minor number range
  media: open.rst: document devnode-centric and mc-centric types
  media: open.rst: Adjust some terms to match the glossary
  media: videodev2: add a flag for MC-centric devices
  media: open.rst: add a notice about subdev-API on vdev-centric

 Documentation/media/uapi/v4l/glossary.rst        | 147 +++++++++++++++++++++++
 Documentation/media/uapi/v4l/open.rst            | 114 +++++++++++++++---
 Documentation/media/uapi/v4l/v4l2.rst            |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst |   5 +
 Documentation/media/videodev2.h.rst.exceptions   |   1 +
 include/uapi/linux/videodev2.h                   |   2 +
 6 files changed, 256 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

-- 
2.13.5
