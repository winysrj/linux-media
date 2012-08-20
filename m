Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2143 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2HTH4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 03:56:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: sh_mobile_csi2.c confusion
Date: Mon, 20 Aug 2012 09:55:54 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208200955.54411.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Guennadi,

The daily build fails with:

make[4]: *** No rule to make target `drivers/media/platform/sh_mobile_csi2.c',
needed by `drivers/media/platform/sh_mobile_csi2.o'.  Stop.

Further investigation shows that the sh_mobile_csi2.o make rule is in
drivers/media/platform/Makefile, while the actual source is in
drivers/media/i2c/soc_camera/sh_mobile_csi2.c.

That can't be right. As far as I can tell sh_mobile_csi2.c should be moved to
drivers/media/platform as it doesn't belong in i2c/soc_camera.

Guennadi, can you confirm? Mauro, can you move it to the right place?

Regards,

	Hans
