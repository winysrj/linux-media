Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60806 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZDETii (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 15:38:38 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20090405160519.629ee7d0@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl>
	 <20090405160519.629ee7d0@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 15:35:52 -0400
Message-Id: <1238960152.3337.84.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 16:05 +0200, Jean Delvare wrote:
> Hi Hans,


Hi Jean,

> Updated patch set is available at:
> http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/
> 


--- v4l-dvb.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:58:36.000000000 +0200
[snip]
-
+		const unsigned short addr_list[] = {
+			0x1a, 0x18, 0x64, 0x30,
+			I2C_CLIENT_END
+		};
[snip]


I just noticed you're missing address 0x71 for ivtv.  At least some
PVR-150 boards have a Zilog chip at that address.

Regards,
Andy



