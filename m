Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:42319 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZC2MhJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 08:37:09 -0400
Received: from localhost (unknown [78.52.195.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 9F32C90002
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 14:36:46 +0200 (CEST)
Date: Sun, 29 Mar 2009 14:36:48 +0200
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 0 of 6] Use usb_interface.dev for v4l2_device_register
Message-ID: <20090329123647.GA637@aniel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the documentation suggest and the current usb driver are using struct device
from the usb_device. As discussed for video_device parent the usb_interface
should be used. This has the advantage that v4l2_device_register creates
meaningfull names, for example "hdpvr usb2-3:1.0" instead of "usb 2-3".

This patch series updates Documentation/video4linux/v4l2-framework.txt and
hopefully all usb drivers uing v4l2_device.

The pvrusb2 and au0828 drivers are already overriding v4l2_device.name with a
driver name and a device counter. I removed that code since I suspect it was
only added to get meaningful names.
If the current names are preferred I'll update the patches.

regards,
Janne

