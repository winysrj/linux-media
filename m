Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34400 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2GKIzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 04:55:15 -0400
Received: by wgbdr13 with SMTP id dr13so815787wgb.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 01:55:13 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	linux@arm.linux.org.uk
Subject: [PATCH 0/2] Add video deinterlacing support.
Date: Wed, 11 Jul 2012 10:55:02 +0200
Message-Id: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[PATCH 1/2] media: Add mem2mem deinterlacing driver.
[PATCH 2/2] i.MX27: Visstrim_M10: Add support for deinterlacing
