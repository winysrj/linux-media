Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:53565 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540AbZHWNJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 09:09:26 -0400
Received: from [192.168.1.69] (dsl5402AB39.pool.t-online.hu [84.2.171.57])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail00a.mail.t-online.hu (Postfix) with ESMTPSA id 0D399267718
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 15:06:44 +0200 (CEST)
Message-ID: <4A913F86.7040704@freemail.hu>
Date: Sun, 23 Aug 2009 15:09:26 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l: zoom, pan and tilt?
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using lib4l to get access to my camera from Flash. I get the pictures
right. In Flash the usual used resolution is as low as 320x240.

I have a 1.3MegaPixel webcam which means it could do 1280x1024 resolution. The
problem with this webcam is that it has a fixed focus and the objects which
are too close to the camera are not sharp enough. This brakes some barcode
reader applications such as http://en.barcodepedia.com/ or
http://www.gurulib.com/_scripts/barcode/gurulib_barcode.html .

My idea would be to add support for creating 320x240 by not just downscaling
the image but doing digital
 - zooming (with controls V4L2_CID_ZOOM_ABSOLUTE, V4L2_CID_ZOOM_RELATIVE and
   V4L2_CID_ZOOM_CONTINUOUS)
 - panning (controls V4L2_CID_PAN_RELATIVE, V4L2_CID_PAN_ABSOLUTE
   and V4L2_CID_PAN_RESET) and
 - tilting (controls V4L2_CID_TILT_RELATIVE, V4L2_CID_TILT_ABSOLUTE and
   V4L2_CID_TILT_RESET)
based on a higher resolution image. In this case the object could be in the sharp
range in focus and the mentioned applications could work.

What do you think, is it possible to implement such functionality in libv4l?

Regards,

	Márton Németh
