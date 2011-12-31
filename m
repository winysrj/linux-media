Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1LaH5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 02:57:00 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH for 3.2 URGENT] gspca: Fix falling back to lower isoc alt
Date: Sat, 31 Dec 2011 08:57:59 +0100
Message-Id: <1325318280-13222-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et all,

I'm afraid my recent work on gscpa has uncovered another regression in
the gspca core. It no longer properly falls back to a lower alt setting
if there is not enough bandwidth for the initially choosen one.

This is a problem when usb1 devices are plugged into a usb2 hub, or into
a sandybridge motherboard (which uses usb2 hubs internally), since the ehci
scheduling code in the kernel does not allow usb1 devices to use full iso
bandwidth (long story). So we must fall back to a lower setting there!

This means that many (iso mode) usb1 devices supported by gscpa won't work
at their highest resolution with such systems. This patch fixes the
falling back to lower alt settings, thereby also fixing these devices no
longer working (reproduced and fix tested with several cams).

Therefor I'm suggesting this fix as a last minute regression fix for 3.2
Mauro, please send this patch on its merry way to Linus, thanks!

Regards,

Hans
