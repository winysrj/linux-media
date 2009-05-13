Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:16885 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761534AbZEMTqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 15:46:39 -0400
Date: Wed, 13 May 2009 21:45:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 0/8] ir-kbd-i2c conversion to the new i2c binding model (v3)
Message-ID: <20090513214559.0f009231@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here comes an update of my conversion of ir-kbd-i2c to the new i2c
binding model. I've split it into 8 pieces for easier review. Firstly
there is 1 preliminary patch:

01-ir-kbd-i2c-dont-abuse-client-name.patch

Then 3 patches doing the actual conversion:

02-ir-kbd-i2c-convert-to-new-style.patch
03-configure-ir-receiver.patch
04-ir-kbd-i2c-dont-bind-to-unsupported-devices.patch

Then 2 patches cleaning up saa7134-input thanks to the new
possibilities offered by the conversion:

05-saa7134-input-cleanup-msi-ir.patch
06-saa7134-input-cleanup-avermedia-cardbus.patch

And lastly driver-specific adjustments:
07-ir-add-lirc-addresses.patch
08-pvrusb2-enable-ir_video-by-default.patch

This patch set is against the v4l-dvb repository, but I didn't pay
attention to the compatibility issues. I simply build-tested it on
2.6.27, 2.6.29 and 2.6.30-rc5.

This patch set touches many different drivers and I can't test any of
them. My only TV card with an IR receiver doesn't make use of
ir-kbd-i2c. So I would warmly welcome testers. The more testing my
changes can get, the better.

And of course I welcome reviews and comments as well. I had to touch
many drivers I don't know anything about so it is possible that I
missed something.

The main difference with my previous patch set is that it is adjusted
to apply after Mike Isely's recent prvusb2 patches.

I'll post all 8 patches as replies to this post. They can also be
temporarily downloaded from:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/
Additionally I've put a combined patch there, to make testing easier:
  http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/ir-kbd-i2c-conversion-ALL-IN-ONE.patch
But for review the individual patches are much better.

Thanks,
-- 
Jean Delvare
