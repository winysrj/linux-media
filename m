Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56469 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZGVBPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:15:34 -0400
Subject: [PATCH v2 0/4] ir-kbd-i2c, cx18: IR devices for CX23418 boards
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Mark Lord <lkml@rtr.ca>,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:16:47 -0400
Message-Id: <1248225407.3191.46.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

The following revised patch series, incorporating comments I received,
will allow the cx18 bridge driver to properly set up supported IR
devices to allow use by ir-kbd-i2c, lirc_i2c, lirc_pvr150, and
lirc_zilog for both old and new (>= 2.6.30) kernels.

They are:

1/4: ir-kbd-i2c: Remove superfulous inlines
2/4: ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key funcs and set ir_type
3/4: cx18: Add i2c initialization for Z8F0811/Hauppage IR transceivers
4/4: ir-kbd-i2c: Add support for Z8F0811/Hauppage IR transceivers

I will *not* add these to a repository and send a pull request, unless
necessary.

Once these changes are merged into the main v4l-dvb repository, I will
write a patch to fix up ivtv for boards with Zilog Z8F0811 based IR.

Regards,
Andy

