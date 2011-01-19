Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58656 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753811Ab1ASKSd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 05:18:33 -0500
Date: Wed, 19 Jan 2011 10:18:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110119101850.GA16453@opensource.wolfsonmicro.com>
References: <1295363063.25951.67.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295363063.25951.67.camel@masi.mnp.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 18, 2011 at 05:04:23PM +0200, Matti J. Aaltonen wrote:

> The driver consists of an MFD core and two child drivers (the audio
> codec and the V4L2 driver). And the question is mainly about the role of
> the MFD driver: the original design had the IO functions in the core.
> Currently the core is practically empty mainly because Mauro very
> strongly wanted to have “everything” in the V4L2 driver.

> I liked the original design because it didn't have the bug that the
> current MFD has: the codec can be initialized before the V4L2 part sets
> the IO function pointers. Having in principle equally capable interface
> drivers is symmetrical and esthetically pleasing:-) Also somebody could
> easily leave out the existing interfaces and create a completely new one
> based for example to sysfs or something... Having the IO in the core
> would also conveniently hide the physical communication layer and make
> it easy to change I2C to UART, which is also supported by the chip.

The above pattern with the core taking responsibility for register I/O
is used by all the other MFD drivers in part because it's much less
fragile against initialisation ordering issues.  It ensures that before
any subdevices can instantiate and try to do register I/O all the
infrastructure required to do that is present.  Is there any great
reason for following a different pattern, and if we are going to do so
how do we deal with the init ordering?
