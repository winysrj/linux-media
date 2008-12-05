Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5Dj4Nu029856
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 08:45:04 -0500
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5DhQKI012680
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 08:43:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Date: Fri, 5 Dec 2008 14:43:06 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051443.06154.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	davinci-linux-open-source-bounces@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Mauro,

Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb for the 
following:

- omap2: add OMAP2 camera driver.
- v4l2-int-if: add three new ioctls for std handling and routing
- v4l: add new tvp514x I2C video decoder driver

Thanks to Nokia and TI for these drivers!

Regards,

        Hans

diffstat:
 b/linux/drivers/media/video/omap24xxcam-dma.c |  601 ++++++++
 b/linux/drivers/media/video/omap24xxcam.c     | 1908 
++++++++++++++++++++++++++
 b/linux/drivers/media/video/omap24xxcam.h     |  593 ++++++++
 b/linux/drivers/media/video/tvp514x.c         | 1569 
+++++++++++++++++++++
 b/linux/drivers/media/video/tvp514x_regs.h    |  297 ++++
 b/linux/include/media/tvp514x.h               |  118 +
 linux/drivers/media/video/Kconfig             |   18
 linux/drivers/media/video/Makefile            |    4
 linux/include/media/v4l2-int-device.h         |    6
 9 files changed, 5114 insertions(+)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
