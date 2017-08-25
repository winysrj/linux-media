Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50087
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755018AbdHYMws (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 08:52:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 0/3] document types of hardware control for V4L2
Date: Fri, 25 Aug 2017 09:52:39 -0300
Message-Id: <cover.1503665390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2010, we introduced a new way to control complex V4L2 devices used
on embedded systems, but this was never documented, nor it is possible
for an userspace applicatin to detect the kind of control a device supports.

This series fill the gap.

Mauro Carvalho Chehab (3):
  media: open.rst: better document device node naming
  media: open.rst: document devnode-centric and mc-centric types
  media: videodev2: add a flag for MC-centric devices

-

v2:

- added a patch at the beginning of the series better defining the
  device node naming rules;
- better defined the differenes between device hardware and V4L2 device node
  as suggested by Laurent and with changes proposed by Hans and Sakari
- changed the caps flag to indicate MC-centric devices
- removed the final patch that would use the new caps flag. I'll write it
  once we agree on the new caps flag.

 Documentation/media/uapi/v4l/open.rst            | 104 +++++++++++++++++++++--
 Documentation/media/uapi/v4l/vidioc-querycap.rst |   5 ++
 include/uapi/linux/videodev2.h                   |   2 +
 3 files changed, 106 insertions(+), 5 deletions(-)

-- 
2.13.3
