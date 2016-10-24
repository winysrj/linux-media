Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51984 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbcJXGNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 02:13:45 -0400
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 18DBE2003E
        for <linux-media@vger.kernel.org>; Mon, 24 Oct 2016 08:12:51 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] UVC driver changes
Date: Mon, 24 Oct 2016 09:13:41 +0300
Message-ID: <4247746.8dSoutiVZG@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bc9b91e6be38b54a7b245969d0a9247791705e6a:

  [media] v4l: vsp1: Add support for capture and output in HSV formats 
(2016-10-21 15:55:43 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to faf38c5540fcf8bd9806cfc7f3b9518205efee9d:

  uvcvideo: uvc_scan_fallback() for webcams with broken chain (2016-10-24 
09:11:06 +0300)

----------------------------------------------------------------
Henrik Ingo (1):
      uvcvideo: uvc_scan_fallback() for webcams with broken chain

 drivers/media/usb/uvc/uvc_driver.c | 118 +++++++++++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

