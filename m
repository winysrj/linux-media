Return-path: <mchehab@pedra>
Received: from cantor.suse.de ([195.135.220.2]:46153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1COC0N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 22:26:13 -0400
Subject: Re: [PATCH 00/20] world-writable files in sysfs and debugfs
From: James Bottomley <James.Bottomley@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net, rtc-linux@googlegroups.com,
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
	security@kernel.org
In-Reply-To: <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
References: <cover.1296818921.git.segoon@openwall.com>
	 <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 22:26:05 -0400
Message-ID: <1300155965.5665.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-03-12 at 23:23 +0300, Vasiliy Kulikov wrote:
> > Vasiliy Kulikov (20):
> >  mach-ux500: mbox-db5500: world-writable sysfs fifo file
> >  leds: lp5521: world-writable sysfs engine* files
> >  leds: lp5523: world-writable engine* sysfs files
> >  misc: ep93xx_pwm: world-writable sysfs files
> >  rtc: rtc-ds1511: world-writable sysfs nvram file
> >  scsi: aic94xx: world-writable sysfs update_bios file
> >  scsi: iscsi: world-writable sysfs priv_sess file
> 
> These are still not merged :(

OK, so I've not been tracking where we are in the dizzying ride on
security systems.  However, I thought we landed up in the privilege
separation arena using capabilities.  That means that world writeable
files aren't necessarily a problem as long as the correct capabilities
checks are in place, right?

James


