Return-path: <linux-media-owner@vger.kernel.org>
Received: from hora-obscura.de ([213.133.111.163]:59181 "EHLO hora-obscura.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZFAHga (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 03:36:30 -0400
Received: from hora-obscura.de (localhost [127.0.0.1])
	(using TLSv1 with cipher ADH-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.hora-obscura.de (Postfix) with ESMTPS id 8DBDF82DC88
	for <linux-media@vger.kernel.org>; Mon,  1 Jun 2009 09:26:27 +0200 (CEST)
Received: from [127.0.0.1] (server2 [213.133.111.163])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.hora-obscura.de (Postfix) with ESMTPSA id 69A4C82DC7A
	for <linux-media@vger.kernel.org>; Mon,  1 Jun 2009 09:26:27 +0200 (CEST)
Message-ID: <4A238292.6000205@hora-obscura.de>
Date: Mon, 01 Jun 2009 10:26:10 +0300
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: webcam drivers and V4L2_MEMORY_USERPTR support
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

I have implemented support for V4L2_MEMORY_USERPTR buffers in gstreamers
v4l2src [1]. This allows to request shared memory buffers from xvideo,
capture into those and therefore save a memcpy. This works great with
the v4l2 driver on our embedded device.

When I was testing this on my desktop, I noticed that almost no driver
seems to support it.
I tested zc0301 and uvcvideo, but also grepped the kernel driver
sources. It seems that gspca might support it, but I ave not confirmed
it. Is there a technical reason for it, or is it simply not implemented?

Thanks
Stefan

[1] http://bugzilla.gnome.org/show_bug.cgi?id=583890
