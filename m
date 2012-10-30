Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2J3O3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 10:29:12 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so229509wgb.1
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 07:29:11 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com
Subject: [PATCH v2 0/4] media: mx2_camera: Remove i.mx25 and clean up.
Date: Tue, 30 Oct 2012 15:28:58 +0100
Message-Id: <1351607342-18030-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:
 - Remove i.MX25 support in the Kconfig file too in patch 1.

[PATCH v2 1/4] media: mx2_camera: Remove i.mx25 support.
[PATCH v2 2/4] media: mx2_camera: Add image size HW limits.
[PATCH v2 3/4] media: mx2_camera: Remove 'buf_cleanup' callback.
[PATCH v2 4/4] media: mx2_camera: Remove buffer states.
