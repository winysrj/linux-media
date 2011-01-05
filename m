Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1487 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AEQm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 11:42:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nsekhar@ti.com, manjunath.hadli@ti.com
Subject: [RFC PATCH 0/2] davinci: convert to core-assisted locking
Date: Wed,  5 Jan 2011 17:42:38 +0100
Message-Id: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


These two patches convert vpif_capture and vpif_display to core-assisted
locking and now use .unlocked_ioctl instead of .ioctl.

These patches assume that the 'DaVinci VPIF: Support for DV preset and DV
timings' patch series was applied first. See:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg26594.html

These patches are targeted for 2.6.38.

Regards,

	Hans
