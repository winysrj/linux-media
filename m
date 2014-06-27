Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56672 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbaF0ISW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 04:18:22 -0400
Message-ID: <1403857099.2048.15.camel@x220>
Subject: Kconfig symbol MX1_VIDEO
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Fri, 27 Jun 2014 10:18:19 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexander,

Your patch "[media] media: mx1_camera: Remove driver" landed in today's
linux-next (ie, next-20140627), as commit 90b055898e9d. It is archived
at http://www.spinics.net/lists/linux-media/msg76764.html .

It removes the Kconfig symbols MX1_VIDEO en VIDEO_MX1. It only removes
the code depending on VIDEO_MX1 (ie, in
drivers/media/platform/soc_camera).

A previous version of that patch is archived at
http://www.spinics.net/lists/linux-media/msg76432.html . (Please, next
time you submit a second version of a patch mark it as a v2 and add some
info below the --- marker about the differences to the first version.)
That previous version removed the code depending on both symbols. But a
quick glance at the discussion about that patch shows that you were
asked to not remove the code depending on MX1_VIDEO (ie, in
arch/arm/mach-imx/).

Would you perhaps know whether a patch to remove the arch/arm/mach-imx/
code is pending somewhere?


Paul Bolle

