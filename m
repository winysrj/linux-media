Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37187 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdG0Jah (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 05:30:37 -0400
Received: from tschai.fritz.box (tschai [192.168.2.10])
        by tschai.lan (Postfix) with ESMTPSA id E1D66180231
        for <linux-media@vger.kernel.org>; Thu, 27 Jul 2017 11:30:32 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] media/doc: rename pixfmt files, improve colorspace docs
Date: Thu, 27 Jul 2017 11:30:29 +0200
Message-Id: <20170727093032.12663-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rename the pixfmt-0XX.rst files left over from the DocBook conversion to something
that is more human readable.

Improve the bt.2020 and SMPTE 2084 documentation.

Regards,

	Hans

Hans Verkuil (3):
  media/doc: rename and reorder pixfmt files
  media/doc: improve bt.2020 documentation
  media/doc: improve the SMPTE 2084 documentation

 .../v4l/{pixfmt-006.rst => colorspaces-defs.rst}   |  2 +-
 .../{pixfmt-007.rst => colorspaces-details.rst}    | 47 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-008.rst        | 32 ---------------
 .../v4l/{pixfmt-013.rst => pixfmt-compressed.rst}  |  0
 .../uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst}  |  0
 .../v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst} |  0
 .../uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst}   |  0
 Documentation/media/uapi/v4l/pixfmt.rst            | 15 ++++---
 8 files changed, 55 insertions(+), 41 deletions(-)
 rename Documentation/media/uapi/v4l/{pixfmt-006.rst => colorspaces-defs.rst} (98%)
 rename Documentation/media/uapi/v4l/{pixfmt-007.rst => colorspaces-details.rst} (92%)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-008.rst
 rename Documentation/media/uapi/v4l/{pixfmt-013.rst => pixfmt-compressed.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst} (100%)

-- 
2.13.1
