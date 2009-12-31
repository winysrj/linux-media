Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1599 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZLaN4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 08:56:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Andy Walls is the new ivtv maintainer
Date: Thu, 31 Dec 2009 14:55:44 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912311455.44818.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Attached is a diff for the 2.6.33-rc2 MAINTAINERS file that removes me as
cx18 maintainer and makes Andy the new ivtv maintainer. After 4 1/2 years
I've decided to hand over the ivtv driver to Andy. Andy was already doing
more work on ivtv than I did, so this just makes official what was happening
in practice.

My SoB:

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Andy, can you add your own SoB as well?

Regards,

	Hans

--- MAINTAINERS.org	2009-12-31 13:25:48.000000000 +0100
+++ MAINTAINERS	2009-12-31 13:26:50.000000000 +0100
@@ -1638,7 +1638,6 @@
 F:	sound/pci/cs5535audio/
 
 CX18 VIDEO4LINUX DRIVER
-M:	Hans Verkuil <hverkuil@xs4all.nl>
 M:	Andy Walls <awalls@radix.net>
 L:	ivtv-devel@ivtvdriver.org
 L:	linux-media@vger.kernel.org
@@ -3021,7 +3020,7 @@
 F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
-M:	Hans Verkuil <hverkuil@xs4all.nl>
+M:	Andy Walls <awalls@radix.net>
 L:	ivtv-devel@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
