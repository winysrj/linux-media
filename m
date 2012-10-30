Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44791 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2J3MQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:16:46 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so112185eek.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 05:16:45 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com
Subject: [PATCH 0/4] media: mx2_camera: Remove i.mx25 and clean up.
Date: Tue, 30 Oct 2012 13:16:31 +0100
Message-Id: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
[PATCH 2/4] media: mx2_camera: Add image size HW limits.
[PATCH 3/4] media: mx2_camera: Remove 'buf_cleanup' callback.
[PATCH 4/4] media: mx2_camera: Remove buffer states.
