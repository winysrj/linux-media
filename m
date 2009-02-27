Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZB0AsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 19:48:11 -0500
Date: Thu, 26 Feb 2009 21:47:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>
Subject: Conversion of vino driver for SGI to not use the legacy decoder API
Message-ID: <20090226214742.6576f30b@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the conversion of Zoran driver to V4L2, now almost all drivers are using
the new API. However, there are is one remaining driver using the
video_decoder.h API (based on V4L1 API) for message exchange between the bridge
driver and the i2c sensor: the vino driver.

This driver adds support for the Indy webcam and for a capture hardware on SGI.
Does someone have those hardware? If so, are you interested on helping to
convert those drivers to fully use V4L2 API?

The SGI driver is located at:
	drivers/media/video/vino.c

Due to vino, those two drivers are also using the old API:
	drivers/media/video/indycam.c
	drivers/media/video/saa7191.c

It shouldn't be hard to convert those files to use the proper APIs, but AFAIK
none of the current active developers has any hardware for testing it.

Cheers,
Mauro
