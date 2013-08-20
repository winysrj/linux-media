Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58482 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3HTOrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 10:47:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VBnDC-0002x5-T2
	for linux-media@vger.kernel.org; Tue, 20 Aug 2013 16:47:10 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 16:47:10 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 20 Aug 2013 16:47:10 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: OMAP3 ISP change image format 
Date: Tue, 20 Aug 2013 14:46:49 +0000 (UTC)
Message-ID: <loom.20130820T114431-434@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I try from my own application out to grab an image with a ov3640 sensor. For
this I need to understand the media-api and the isp pipeline correctly.

I had problems with the use of media-ctl so I implemented the functionality
into my application and it seems to work fine. Without an error I grabbed an
image, but it was black.

So maybe my format settings are not correctly set. My Question is:

For example I want to grab a rgb565 image from my camera sensor and display
it on a webpage. my pipeline looks like this:

ov3640->ccdc->memory

Would it be enough to just set a raw bayer format on the source and sink
pads and just the format of the video device (/dev/video2) as rgb565?

Regards, Tom





