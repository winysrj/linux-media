Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40278 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2ATLgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 06:36:42 -0500
Received: by werb13 with SMTP id b13so314396wer.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 03:36:40 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de, baruch@tkos.co.il
Subject: [PATCH 0/4] media i.MX27 camera: fix buffer handling and videobuf2 support.  
Date: Fri, 20 Jan 2012 12:36:28 +0100
Message-Id: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The way video buffer handling is programmed for i.MX27 leads
to buffers being written when they are not ready.

It can be easily checked enabling DEBUG features of the driver.

This series migrate the driver to videobuf2 and provide an   
additional discard queue to make sure all the events are handled
in the right order.

I've only tested the series with an i.MX27 device and so I've 
tried not to touch code scpecific for mx25. However, any mx25
tester would be more than welcome.

[PATCH 1/4] media i.MX27 camera: migrate driver to videobuf2
[PATCH 2/4] media i.MX27 camera: add start_stream and stop_stream callbacks.
[PATCH 3/4] media i.MX27 camera: improve discard buffer handling.
[PATCH 4/4] media i.MX27 camera: handle overflows properly.
