Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:34527 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbZHJR44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 13:56:56 -0400
From: Ronny Brendel <ronny.brendel@tu-dresden.de>
To: linux-media@vger.kernel.org
Subject: libv4l2 woes
Date: Mon, 10 Aug 2009 19:29:58 +0200
Cc: Ronny Brendel <ronnybrendel@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101929.59041.ronny.brendel@tu-dresden.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I am currently trying to read image data from my webcam.
When I read raw data data by using open/read/close everything works just fine.

Since I want to use the auto-conversion of libv4l2, I tried out reading using 
the v4l2_ counterparts,
Unfortunately the library closes with an error message::

libv4l2: error requesting 4 buffers: Device or resource busy

Can some please give a suggestion what to do?


The source of my tool is available at 
http://github.com/hydroo/videocapture/tree/master (CaptureDevice.{hpp,cpp}

regards
Ronny
