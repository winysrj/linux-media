Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:39610 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1HKJ5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 05:57:16 -0400
Message-ID: <4E43A770.7080308@matrix-vision.de>
Date: Thu, 11 Aug 2011 11:57:04 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: omap3isp buffer alignment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

If I understood your discussion with Russell [1] correctly, user pointer
buffers are required to be page-aligned because of the IOMMU API, and
it's desirable to keep the IOMMU driver that way for other subsystems
which may use it. So we're stuck with user buffers needing to be
page-aligned.

There's a check in ispvideo.c:isp_video_buffer_prepare() that the buffer
address is 32-byte aligned. Isn't this superfluous considering the
page-aligned restriction?

-Michael

[1]
http://www.mail-archive.com/linux-omap%40vger.kernel.org/msg50611.html

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
