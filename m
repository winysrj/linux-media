Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SBpeGD018512
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 07:51:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9SBpQNf023351
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 07:51:26 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 28 Oct 2008 12:51:23 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281251.24176.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PULL] radio-si470x
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

Please pull from http://linuxtv.org/hg/~tlorenz/v4l-dvb

for the following changeset:

01/01: Documentation, especially regarding audio and informational links
http://linuxtv.org/hg/~tlorenz/v4l-dvb?cmd=changeset;node=a8ac01a911c6bc547039e67d9421644b016ad524


 b/linux/Documentation/video4linux/si470x.txt |  118 +++++++++++++++++++++++++++
 linux/drivers/media/radio/Kconfig            |   14 +++
 linux/drivers/media/radio/radio-si470x.c     |   13 --
 3 files changed, 132 insertions(+), 13 deletions(-)

Thanks,
Tobias

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
