Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56821 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2F0Qvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:51:39 -0400
Received: by obbuo13 with SMTP id uo13so1698050obb.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:51:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
References: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
Date: Wed, 27 Jun 2012 13:51:38 -0300
Message-ID: <CALF0-+UuQ9u87xw-UJDHJsYcvnQDEdWWNetLasdNxc9EWWyq8w@mail.gmail.com>
Subject: [PATCH v2 0/9] struct i2c_algo_bit_data cleanup on several drivers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	stoth@kernellabs.com, Ezequiel Garcia <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset cleans the i2c part of some drivers.
This issue was recently reported by Dan Carpenter [1],
and revealed wrong (and harmless) usage of struct i2c_algo_bit_data.

This series consist in two kinds of patches:
 - remove one unused function
 - remove unused field i2c_algo
 - replace struct memcpy with struct assignment

This last change is, in my opinion, a much safer way for struct filling
and (in this case) I'm not aware of any change in functionality.

Also I've dropped i2c_rc cleaning entirely. I'm still working on these
and they are not related to this patchset.

As I don't own any of these devices, I can't test the changes beyond
compilation.

Changes from v1:
 - Drop i2c_rc clean patches
 - Verbose commit messages

Ezequiel Garcia (9):
 cx25821: Replace struct memcpy with struct assignment
 cx231xx: Replace struct memcpy with struct assignment
 cx23885: Replace struct memcpy with struct assignment
 saa7164: Replace struct memcpy with struct assignment
 saa7164: Remove unused saa7164_call_i2c_clients()
 cx25821: Remove useless struct i2c_algo_bit_data
 cx231xx: Remove useless struct i2c_algo_bit_data
 cx23885: Remove useless struct i2c_algo_bit_data
 saa7164: Remove useless struct i2c_algo_bit_data

 drivers/media/video/cx231xx/cx231xx-i2c.c |    8 ++------
 drivers/media/video/cx231xx/cx231xx.h     |    2 --
 drivers/media/video/cx23885/cx23885-i2c.c |   10 ++--------
 drivers/media/video/cx23885/cx23885.h     |    2 --
 drivers/media/video/cx25821/cx25821-i2c.c |   10 ++--------
 drivers/media/video/cx25821/cx25821.h     |    2 --
 drivers/media/video/saa7164/saa7164-i2c.c |   20 ++------------------
 drivers/media/video/saa7164/saa7164.h     |    2 --
 8 files changed, 8 insertions(+), 48 deletions(-)

Thanks,
Ezequiel.

[1] http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/49553
