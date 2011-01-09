Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33503 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751793Ab1AIOqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 09:46:09 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] radio-si470x
Date: Sun, 9 Jan 2011 15:44:05 +0100
Cc: linux-media@vger.kernel.org,
	Joonyoung Shim <jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091544.06031.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please pull from http://linuxtv.org/hg/~tlorenz/v4l-dvb

for the following 5 changesets:

01/05: The de-emphasis should be setted if requested by module parameter
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/b29f01f1b11d

02/05: The si470x i2c and usb driver support the RDS, so this ifdef statement
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/74bf5826ae4e

03/05: We should go to err_video instead of err_all if this error is occured
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/7ea10526e134

04/05: V4L/DVB: radio-si470x: remove the BKL lock used internally at the driver
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/9ddfe7347b9a

05/05: V4L/DVB: radio-si470x: use unlocked ioctl
http://linuxtv.org/hg/~tlorenz/v4l-dvb/rev/87712135ac8d

Thanks,
Tobias
