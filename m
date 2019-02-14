Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8EEC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 12:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE5421900
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 12:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="OhxGlE8A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436706AbfBNM7v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:59:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41976 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388917AbfBNM7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 07:59:51 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B51C42DF;
        Thu, 14 Feb 2019 13:59:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550149189;
        bh=jXfQGjQVnJqt0wo2J27qk2Jp6OVLphsME+Q3MpdczDI=;
        h=Date:From:To:Cc:Subject:From;
        b=OhxGlE8AGfCFIrKQHIplA4UFUpWcvPHfPJn+KtUuC8b4cGJEgwsOGRTrWrMt+PcMy
         cAx30n8iX+shaGMYnvhtgkmsL5M9Wwq/fvjmowv8WLA6dYC064zAwTI5cfr6bs3nlI
         uGLNvz+kmqNF7izJvtOC3WjoibwkrSlMuILfnMgc=
Date:   Thu, 14 Feb 2019 14:59:46 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] UVC and VSP changes
Message-ID: <20190214125946.GI3682@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git tags/v4l2-next-20190214

for you to fetch changes up to 1215f65c095d7b40784b331aa79611dbd0e303c5:

  dt-bindings: media: renesas-fcp: Add RZ/G2 support (2019-02-14 14:53:56 +0200)

----------------------------------------------------------------
UVC and VSP changes for v5.1

----------------------------------------------------------------
Fabrizio Castro (2):
      media: vsp1: Add RZ/G support
      dt-bindings: media: renesas-fcp: Add RZ/G2 support

Hans Verkuil (3):
      media: uvcvideo: Fix smatch warning
      media: uvcvideo: Use usb_make_path to fill in usb_info
      media: vsp1: Fix smatch warning

 Documentation/devicetree/bindings/media/renesas,fcp.txt  | 5 +++--
 Documentation/devicetree/bindings/media/renesas,vsp1.txt | 6 +++---
 drivers/media/platform/vsp1/vsp1_drm.c                   | 6 +++---
 drivers/media/usb/uvc/uvc_driver.c                       | 2 +-
 drivers/media/usb/uvc/uvcvideo.h                         | 6 ++++--
 5 files changed, 14 insertions(+), 11 deletions(-)

-- 
Regards,

Laurent Pinchart
