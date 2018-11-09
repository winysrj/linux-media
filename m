Return-path: <linux-media-owner@vger.kernel.org>
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:36545 "EHLO lnfm1.sai.msu.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725758AbeKJFLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 00:11:42 -0500
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, stern@rowland.harvard.edu,
        ezequiel@collabora.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        isely@pobox.com, bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
Subject: [PATCH v6 0/2] media: usb: pwc: Don't use coherent DMA buffers for ISO transfer
Date: Fri,  9 Nov 2018 22:03:25 +0300
Message-Id: <20181109190327.23606-1-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DMA cocherency slows the transfer down on systems without hardware coherent
DMA. In order to demontrate this we introduce performance measurement
facilities in patch 1 and fix the performance issue in patch 2 in order to
obtain 3.3 times speedup.

Changes since v5:
 * add dma_sync_single_for_device() as required by Laurent Pinchart

Changes since v4:
 * fix fields order in trace events 
 * minor style fixes

Changes since v3:
 * fix scripts/checkpatch.pl errors
 * use __string to store name in trace events

Changes since v2:
 * use dma_sync_single_for_cpu() to achive better performance
 * remeasured performance

Changes since v1:
 * trace_pwc_handler_exit() call moved to proper place
 * detailed description added for commit 1
 * additional output added to trace to track separate frames

Matwey V. Kornilov (2):
  media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
  media: usb: pwc: Don't use coherent DMA buffers for ISO transfer

 drivers/media/usb/pwc/pwc-if.c | 69 ++++++++++++++++++++++++++++++++++--------
 include/trace/events/pwc.h     | 65 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 13 deletions(-)
 create mode 100644 include/trace/events/pwc.h

-- 
2.16.4
