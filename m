Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:37130 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbeBXSeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:34:18 -0500
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH 0/2] usbtv: Add SECAM support
Date: Sat, 24 Feb 2018 19:24:17 +0100
Message-Id: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for the SECAM standard to the USBTV
video grabber driver.

The first patch prepares for the inclusion of further decoder
configuration sequences by making them follow the same order and length
as the sequences which can be found inside the Windows driver's .INF
file.

The second patch adds the SECAM decoder configuration sequence found in
the .INF file, and exposes SECAM support to userspace.

Hugo Grostabussiat (2):
  usbtv: Use same decoder sequence as Windows driver
  usbtv: Add SECAM support

 drivers/media/usb/usbtv/usbtv-video.c | 60 +++++++++++++++++++++++++++++------
 drivers/media/usb/usbtv/usbtv.h       |  2 +-
 2 files changed, 51 insertions(+), 11 deletions(-)

-- 
2.16.2
