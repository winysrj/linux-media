Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1CLUXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:08 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Date: Sat, 12 Mar 2011 23:23:06 +0300
Message-ID: <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
Subject: Re: [PATCH 00/20] world-writable files in sysfs and debugfs
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net, rtc-linux@googlegroups.com,
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
	security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Vasiliy Kulikov (20):
>  mach-ux500: mbox-db5500: world-writable sysfs fifo file
>  leds: lp5521: world-writable sysfs engine* files
>  leds: lp5523: world-writable engine* sysfs files
>  misc: ep93xx_pwm: world-writable sysfs files
>  rtc: rtc-ds1511: world-writable sysfs nvram file
>  scsi: aic94xx: world-writable sysfs update_bios file
>  scsi: iscsi: world-writable sysfs priv_sess file

These are still not merged :(
