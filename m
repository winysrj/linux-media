Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66588C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B0512147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfBGJNm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45173 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP3j; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/6] sparse/smatch fixes
Date:   Thu,  7 Feb 2019 10:13:32 +0100
Message-Id: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAjd/7ltqEPSxaBb9dbLcekKaGTns7bLf0arAdM6etvugChb7Cwt41l1ho9UHofXm/ORxKFn//31Cpi41SRvi2NGHGUnVF0c8EW+5JyyjkhbwTr/bo5x
 3Wj5TNqIrlGBCf3NY6XnuQdmjhystB1yegIy3mMXL5Cn23q3VFm0Z0aSGtzK2cNmmv96Sdvgv5gB0dgd+36td+oIk3LNK3IdmuvDK40AGHcdV7EY7vid0MaD
 +r/sgzzkbQstNxNSW+IbvMvfJIoMT8wzpOLYfB4RT2EF6C3t8he2rkxQoIJvfLHR5mtWhj9YrTDn+G+FID+RB4qHZYzuImz0Ne3xDT+uwDpPSuJZOMPNc/Wi
 8KF0c/QTmI9ea3PaV6SJ9uEHV/lfaxmjdWAiJ1tOG9CNkn3a3+o=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Various sparse and smatch fixes.

Together with https://patchwork.linuxtv.org/patch/53375/ and
https://patchwork.linuxtv.org/patch/54237/ we have a clean bill
of health. The vsp1 patch supersedes this by now outdated old patch:
https://patchwork.linuxtv.org/patch/49263/

Kieran, Laurent, please review the uvc, vsp1 and omap3isp patches.

Sakari, Mauro, the pxa_camera patch supersedes this older patch:
https://patchwork.linuxtv.org/patch/53378/ and has Sakari's
comments included.

Regards,

	Hans

Hans Verkuil (6):
  hdpvr: fix smatch warning
  vim2m: fix smatch warning
  uvc: fix smatch warning
  vsp1: fix smatch warning
  omap3isp: fix sparse warning
  pxa_camera: fix smatch warning

 drivers/media/platform/omap3isp/ispvideo.c |  5 +++--
 drivers/media/platform/pxa_camera.c        |  8 +++++---
 drivers/media/platform/vim2m.c             |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c     |  6 +++---
 drivers/media/usb/hdpvr/hdpvr-i2c.c        | 14 +++++++-------
 drivers/media/usb/uvc/uvcvideo.h           |  6 ++++--
 6 files changed, 23 insertions(+), 18 deletions(-)

-- 
2.20.1

