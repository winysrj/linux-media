Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp1.conexant.com ([198.62.9.252]:13131 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2FRUsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 16:48:04 -0400
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Ezequiel Garcia" <elezegarcia@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
cc: "linux-media" <linux-media@vger.kernel.org>,
	"Dan Carpenter" <dan.carpenter@oracle.com>,
	"stoth@kernellabs.com" <stoth@kernellabs.com>
Date: Mon, 18 Jun 2012 13:30:26 -0700
Subject: RE: [PATCH 0/12] struct i2c_algo_bit_data cleanup on several drivers
Message-ID: <34B38BE41EDBA046A4AFBB591FA311320509E66E05@NBMBX01.bbnet.ad>
References: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
In-Reply-To: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Ezequiel and Dan. The changes look ok. I'll have someone check out the changes on the CX devices.

Rgds,
Palash

-----Original Message-----
From: Ezequiel Garcia [mailto:elezegarcia@gmail.com] 
Sent: Monday, June 18, 2012 12:23 PM
To: Mauro Carvalho Chehab
Cc: linux-media; Dan Carpenter; Palash Bandyopadhyay; stoth@kernellabs.com
Subject: [PATCH 0/12] struct i2c_algo_bit_data cleanup on several drivers

Hi Mauro,

This patchset cleans the i2c part of some drivers.
This issue was recently reported by Dan Carpenter [1], and revealed wrong (and harmless) usage of struct i2c_algo_bit.

Also, I properly assigned bus->i2c_rc (return code variable) and replaced struct memcpy with struct assignment.
The latter is, in my opinion, a much safer way for struct filling and I'm not aware of any drawbacks.

The patches are based on today's linux-next; I hope this is okey.
As I don't own any of these devices, I can't test the changes beyond compilation.

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

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

