Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2FZTeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:34:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 0/4] Defer probe() on em28xx when firmware load is required
Date: Tue, 26 Jun 2012 16:34:18 -0300
Message-Id: <1340739262-13747-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4FE9169D.5020300@redhat.com>
References: <4FE9169D.5020300@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is an attempt to solve the recent issues with udev-182
and media drivers.

The .probe() callback should "bind the driver to a given device.  That
includes verifying that the device is present, that it's a version the
driver can handle, that driver data structures can be allocated and 
initialized, and that any hardware can be initialized".

In order to comply witht he above, sometimes firmware is needed. However,
PM and udev have problems with that.

Newer versions of request_firmware block firmware load on some situations,
due to PM. Also, udev simply refuses to load firmware when module_init
doesn't finish, and .probe() can be called during USB/PCI bus register,
if the device is plugged.

This patch series consists of 4 patches:
	1) a change at kmod, in order to export the information that
	   userspace mode is disabled;

	2) a patch at em28xx that defers probe() if firmware is needed
	   and userspace mode is disabled;

	3) a workaround due to udev-182 limitation of not loading firmware
	   while a driver is modprobed;

	4) a patch for tuner-xc2028, in order to indicate what firmware
	   files are used there.

I was hoping that dracut-018-40.git20120522.fc17.noarch would get the
MODULE_FIRMWARE info while creating the initfs filesystem, copying there
the right firmwares, but, unfortunately, this didn't work (at least while
copiling tuners as builtin). Maybe will would honour it if I re-compile
everything as module and force dracut to load em28xx at init time.

Comments?

Regards,
Mauro

Mauro Carvalho Chehab (4):
  kmod: add a routine to return if usermode is disabled
  em28xx: defer probe() if udev is not ready to request_firmware
  em28xx: Workaround for new udev versions
  tuner-xc2028: tag the usual firmwares to help dracut

 drivers/media/common/tuners/tuner-xc2028.c |    2 +
 drivers/media/video/em28xx/em28xx-cards.c  |   73 +++++++++++++++++++++++++++-
 drivers/media/video/em28xx/em28xx.h        |    1 +
 include/linux/firmware.h                   |    6 +++
 kernel/kmod.c                              |    6 +++
 5 files changed, 87 insertions(+), 1 deletion(-)

-- 
1.7.10.2

