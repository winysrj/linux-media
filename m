Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40265 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeIKN2O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 09:28:14 -0400
Received: by mail-wm0-f68.google.com with SMTP id 207-v6so407076wme.5
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 01:30:00 -0700 (PDT)
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com, hverkuil@xs4all.nl
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH v2 0/1] cameraif: add ABI for para-virtual camera
Date: Tue, 11 Sep 2018 11:29:51 +0300
Message-Id: <20180911082952.23322-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Hello!

At the moment Xen [1] already supports some virtual multimedia
features [2] such as virtual display, sound. It supports keyboards,
pointers and multi-touch devices all allowing Xen to be used in
automotive appliances, In-Vehicle Infotainment (IVI) systems
and many more.

This work adds a new Xen para-virtualized protocol for a virtual
camera device which extends multimedia capabilities of Xen even
farther: video conferencing, IVI, high definition maps etc.

The initial goal is to support most needed functionality with the
final idea to make it possible to extend the protocol if need be:

1. Provide means for base virtual device configuration:
 - pixel formats
 - resolutions
 - frame rates
2. Support basic camera controls:
 - contrast
 - brightness
 - hue
 - saturation
3. Support streaming control
4. Support zero-copying use-cases

I hope that Xen and V4L and other communities could give their
valuable feedback on this work, so I can update the protocol
to better fit any additional requirements I might have missed.

I would like to thank Hans Verkuil <hverkuil@xs4all.nl> for valuable
comments and help.

Thank you,
Oleksandr Andrushchenko

Changes since v1:
=================

1. Added XenStore entries:
 - frame-rates
2. Do not require the FOURCC code in XenStore to be upper case only
3. Added/changed command set:
 - configuration get/set
 - buffer queue/dequeue
 - control get
4. Added control flags, e.g. read-only etc.
5. Added colorspace configuration support, relevant constants
6. Added events:
 - configuration change
 - control change
7. Changed control values to 64-bit
8. Added sequence number to frame avail event
9. Coding style cleanup

[1] https://www.xenproject.org/
[2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io

Oleksandr Andrushchenko (1):
  cameraif: add ABI for para-virtual camera

 xen/include/public/io/cameraif.h | 1263 ++++++++++++++++++++++++++++++
 1 file changed, 1263 insertions(+)
 create mode 100644 xen/include/public/io/cameraif.h

-- 
2.18.0
