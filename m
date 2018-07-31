Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44569 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbeGaLLR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 07:11:17 -0400
Received: by mail-lj1-f193.google.com with SMTP id q127-v6so13077249ljq.11
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2018 02:31:50 -0700 (PDT)
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [Xen-devel][PATCH 0/1] cameraif: Add ABI for para-virtualized
Date: Tue, 31 Jul 2018 12:31:41 +0300
Message-Id: <20180731093142.3828-1-andr2000@gmail.com>
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

Thank you,
Oleksandr Andrushchenko

[1] https://www.xenproject.org/
[2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io

Oleksandr Andrushchenko (1):
  cameraif: add ABI for para-virtual camera

 xen/include/public/io/cameraif.h | 981 +++++++++++++++++++++++++++++++
 1 file changed, 981 insertions(+)
 create mode 100644 xen/include/public/io/cameraif.h

-- 
2.18.0
