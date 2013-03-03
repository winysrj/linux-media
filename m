Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:60654 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3CCJht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 04:37:49 -0500
Received: from leon.localnet (cs181242165.pp.htv.fi [82.181.242.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id E6FB620145
	for <linux-media@vger.kernel.org>; Sun,  3 Mar 2013 10:37:45 +0100 (CET)
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: uvcvideo USERPTR mode busted?
Date: Sun, 3 Mar 2013 11:37:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303031137.44917@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hello,

Trying to use USERPTR buffers with UVC, user space gets stuck either in 
poll(POLLIN) or in ioctl(VIDIOC_DQBUF). It seems the UVC driver never ever 
returns a frame in USERPTR mode. The symptoms are identical with kernel 
versions 3.6, 3.7 and 3.8. I also tested 3.2, but it did not support USERPTR.

Tested hardware was Logitech HD Pro Webcam C920 with YUY2 pixel format. The 
same hardware and the same driver work fine with MMAP buffers.
The same USERPTR userspace code works fine with the vivi test device...

Did any have any better luck?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
