Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56514 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2BMNwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 08:52:07 -0500
Received: by werb13 with SMTP id b13so3480142wer.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 05:52:05 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de
Subject: [PATCH 0/6] media: i.MX27 camera: Clean up series.
Date: Mon, 13 Feb 2012 14:51:49 +0100
Message-Id: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
This is the clean up series I promised to send this week. This has to be
applied on top of my previous patches.

These are already discussed issues so I don't think you have any concerns
with them.

While I wait for your confirmation, I'm going to prepare a new patch in order
to provide video resizing support.

[PATCH 1/6] media: i.MX27 camera: Remove goto from mx2_videobuf_queue().
[PATCH 2/6] media: i.MX27 camera: Use list_first_entry() whenever possible.
[PATCH 3/6] media: i.MX27 camera: Use spin_lock() inside the IRQ handler.
[PATCH 4/6] media: i.MX27 camera: return IRQ_NONE if no IRQ status bit is set.
[PATCH 5/6] media: i.MX27 camera: fix compilation warning.
[PATCH 6/6] media: i.MX27 camera:  more efficient discard buffer handling.
