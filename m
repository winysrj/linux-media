Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:32996 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2FRTXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:23:15 -0400
Received: by gglu4 with SMTP id u4so4008942ggl.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:23:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Jun 2012 16:23:14 -0300
Message-ID: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
Subject: [PATCH 0/12] struct i2c_algo_bit_data cleanup on several drivers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	stoth@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset cleans the i2c part of some drivers.
This issue was recently reported by Dan Carpenter [1],
and revealed wrong (and harmless) usage of struct i2c_algo_bit.

Also, I properly assigned bus->i2c_rc (return code variable) and
replaced struct memcpy with struct assignment.
The latter is, in my opinion, a much safer way for struct filling
and I'm not aware of any drawbacks.

The patches are based on today's linux-next; I hope this is okey.
As I don't own any of these devices, I can't test the changes beyond
compilation.

Ezequiel Garcia (12):
  cx25821: Replace struct memcpy with struct assignment
  cx25821: Remove useless struct i2c_algo_bit_data usage
  cx25821: Use i2c_rc properly to store i2c register status
  cx231xx: Replace struct memcpy with struct assignment
  cx231xx: Remove useless struct i2c_algo_bit_data usage
  cx231xx: Use i2c_rc properly to store i2c register status
  cx23885: Replace struct memcpy with struct assignment
  cx23885: Remove useless struct i2c_algo_bit_data
  cx23885: Use i2c_rc properly to store i2c register status
  saa7164: Replace struct memcpy with struct assignment
  saa7164: Remove useless struct i2c_algo_bit_data
  saa7164: Use i2c_rc properly to store i2c register status

 drivers/media/video/cx231xx/cx231xx-i2c.c |   10 +++-------
 drivers/media/video/cx231xx/cx231xx.h     |    2 --
 drivers/media/video/cx23885/cx23885-i2c.c |   12 +++---------
 drivers/media/video/cx23885/cx23885.h     |    2 --
 drivers/media/video/cx25821/cx25821-i2c.c |   12 +++---------
 drivers/media/video/cx25821/cx25821.h     |    2 --
 drivers/media/video/saa7164/saa7164-i2c.c |   13 +++----------
 drivers/media/video/saa7164/saa7164.h     |    2 --
 8 files changed, 12 insertions(+), 43 deletions(-)

Thanks,
Ezequiel.

[1] http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/49553
