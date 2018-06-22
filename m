Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43087 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbeFVMEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 08:04:32 -0400
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ezequiel@collabora.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 0/2] Don't use coherent DMA buffers for ISO transfer
Date: Fri, 22 Jun 2018 15:04:17 +0300
Message-Id: <20180622120419.7675-1-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>

DMA cocherency slows the transfer down on systems without hardware coherent
DMA. In order to demontrate this we introduce performance measurement
facilities in patch 1 and fix the performance issue in patch 2 in order to
obtain 5.5 times speedup.

Changes since v1:
 * trace_pwc_handler_exit() call moved to proper place
 * detailed description added for commit 1
 * additional output added to trace to track separate frames

Matwey V. Kornilov (2):
  media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
  media: usb: pwc: Don't use coherent DMA buffers for ISO transfer

 drivers/media/usb/pwc/pwc-if.c | 19 +++++++------
 include/trace/events/pwc.h     | 64 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 9 deletions(-)
 create mode 100644 include/trace/events/pwc.h

-- 
2.16.4
