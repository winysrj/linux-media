Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:29609 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1ARPEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 10:04:46 -0500
Subject: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 17:04:23 +0200
Message-ID: <1295363063.25951.67.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello

I have been trying to get the WL1273 FM radio driver into the kernel for
some time. It has been kind of difficult, one of the reasons is that I
didn't realize I should have tried to involve all relevant maintainers
to the discussion form the beginning (AsoC, Media and MFD). At Mark's
suggestion I'm trying to reopen the discussion now.

The driver consists of an MFD core and two child drivers (the audio
codec and the V4L2 driver). And the question is mainly about the role of
the MFD driver: the original design had the IO functions in the core.
Currently the core is practically empty mainly because Mauro very
strongly wanted to have “everything” in the V4L2 driver.

I liked the original design because it didn't have the bug that the
current MFD has: the codec can be initialized before the V4L2 part sets
the IO function pointers. Having in principle equally capable interface
drivers is symmetrical and esthetically pleasing:-) Also somebody could
easily leave out the existing interfaces and create a completely new one
based for example to sysfs or something... Having the IO in the core
would also conveniently hide the physical communication layer and make
it easy to change I2C to UART, which is also supported by the chip.

Thanks,
Matti


