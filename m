Return-path: <linux-media-owner@vger.kernel.org>
Received: from eyemagnet.com ([202.160.117.202]:33246 "EHLO eyemagnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZGaXUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 19:20:16 -0400
Received: from [192.168.1.183] (adsl-76-199-64-226.dsl.pltn13.sbcglobal.net [76.199.64.226])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by eyemagnet.com (Postfix) with ESMTP id CD9B88240
	for <linux-media@vger.kernel.org>; Sat,  1 Aug 2009 11:20:15 +1200 (NZST)
Subject: USB devices supporting raw or sliced VBI for closed captioning?
From: Steve Castellotti <sc@eyemagnet.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 31 Jul 2009 16:20:37 -0700
Message-Id: <1249082438.18313.30.camel@odyssey.sc.user.nz.vpn>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


	I was wondering if anyone could please point me at a list or similar
resource for USB capture devices which support raw (or sliced) VBI
access for producing a closed caption transcript through software such
as zbvi-ntsc-cc or ccextractor? Specifically I'm wanting a device
capable of S-Video, Composite, or even Component input, not just ATSC,
as most USB devices seem focused around these days.

	I've managed to get this working with various ivtv and saa713x based
PCI devices, but aren't aware of any USB implementations of chipsets
which use those drivers.


	Searching online, I found this archived message:

http://lists.zerezo.com/video4linux/msg16402.html

which states:

> some em2840 and newer devices are able to capture raw vbi in
> linux (sliced vbi isn't possible yet)
> em2820, em2800, em2750 do not support vbi at all.


	Checking the em28xx driver homepage for recent models, I found this
entry:

http://mcentral.de/wiki/index.php5/Em2880

> officially the em2880 is em2840 + DVB_T


	which implies that not only is the "em2880" series a "newer" device,
but it should in fact already contain the "em2840" chip specifically
mentioned.


	Later on that same page, in the list of devices:

ATI/AMD TV Wonder 600


	and on the manufacturer's page:

http://ati.amd.com/products/tvwonder600/usb/index.html


	Under the list of "Input Connectors":

> S-video input with adapter



	Picking up one of these devices, I attempted to tune into the S-Video
feed and check the /dev/vbi0 device, but received the same error message
as I do with all other em28xx devices encountered thus far:

> Cannot capture vbi data with v4l interface:
> /dev/vbi0 (AMD ATI TV Wonder HD 600) is not a raw vbi device.



	Can anyone please point me in the right direction?

	I would much prefer to be certain the next purchase is supported.



Thanks!


Steve


-- 

Steve Castellotti
sc@eyemagnet.com
Technical Director
Eyemagnet Limited
http://www.eyemagnet.com

