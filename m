Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754388Ab0AIW0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 17:26:12 -0500
Date: Sat, 9 Jan 2010 23:26:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [Q] hg patches with non-ASCII symbols
Message-ID: <alpine.DEB.2.00.1001092321200.18115@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, all

I've got a couple of patches from authors with non-ASCII characters in 
their names. I'm sending this email on purpose from a utf-8 client to 
better demonstrait this. Here is a header of one of such _git_ patches:

<quote>

>From 7984cae1e117149392548ff102c7a22fce7ae92c Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Wed, 16 Dec 2009 17:10:04 +0100
Subject: [PATCH 1/5] V4L/DVB mx1_camera: don't check platform_get_irq's return value against zero
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

platform_get_irq returns -ENXIO on failure, so !irq was probably
always true.  Better use (int)irq <= 0.  Note that a return value of
zero is still handled as error even though this could mean irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
changed the return value of platform_get_irq from 0 to -ENXIO on error.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

</quote>

As you see, the name in the header is converted to a string like

From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

but UTF-8 is preserved in Sob. Is this also how I shall commit such 
patches to hg or shall I do this somehow differently. Or shall I just wait 
with these patches until v4l switches to git...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
