Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:37836
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754499AbeALJT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:19:26 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v3 0/6] Asynchronous UVC
Date: Fri, 12 Jan 2018 09:19:25 +0000 (UTC)
Message-Id: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
content-transfer-encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linux UVC driver has long provided adequate performance capabilities fo=
r=0D
web-cams and low data rate video devices in Linux while resolutions were lo=
w.=0D
=0D
Modern USB cameras are now capable of high data rates thanks to USB3 with=
=0D
1080p, and even 4k capture resolutions supported.=0D
=0D
Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO=0D
(isochronous transfers) can generate more data than an embedded ARM core is=
=0D
able to process on a single core, resulting in frame loss.=0D
=0D
A large part of this performance impact is from the requirement to=0D
=E2=80=98memcpy=E2=80=99 frames out from URB packets to destination frames.=
 This unfortunate=0D
requirement is due to the UVC protocol allowing a variable length header, a=
nd=0D
thus it is not possible to provide the target frame buffers directly.=0D
=0D
Extra throughput is possible by moving the actual memcpy actions to a work=
=0D
queue, and moving the memcpy out of interrupt context thus allowing work ta=
sks=0D
to be scheduled across multiple cores.=0D
=0D
This series has been tested on both the ZED and BRIO cameras on arm64=0D
platforms, however due to the intrinsic changes in the driver I would like =
to=0D
see it tested with other devices and other platforms, so I'd appreciate if=
=0D
anyone can test this on a range of USB cameras.=0D
=0D
In particular, any iSight devices, or devices which use UVC to encode data=
=0D
(output device) would certainly be great to be tested with these patches.=
=0D
=0D
v2:=0D
 - Fix race reported by Guennadi=0D
=0D
v3:=0D
 - Fix similar race reported by Laurent=0D
 - Only queue work if required (encode/isight do not queue work)=0D
 - Refactor/Rename variables for clarity=0D
=0D
Kieran Bingham (6):=0D
  uvcvideo: Refactor URB descriptors=0D
  uvcvideo: Convert decode functions to use new context structure=0D
  uvcvideo: Protect queue internals with helper=0D
  uvcvideo: queue: Simplify spin-lock usage=0D
  uvcvideo: queue: Support asynchronous buffer handling=0D
  uvcvideo: Move decode processing to process context=0D
=0D
 drivers/media/usb/uvc/uvc_isight.c |   4 +-=0D
 drivers/media/usb/uvc/uvc_queue.c  | 114 +++++++++++++----=0D
 drivers/media/usb/uvc/uvc_video.c  | 198 ++++++++++++++++++++++--------=0D
 drivers/media/usb/uvc/uvcvideo.h   |  56 +++++++-=0D
 4 files changed, 296 insertions(+), 76 deletions(-)=0D
=0D
base-commit: 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f=0D
-- =0D
git-series 0.9.1
