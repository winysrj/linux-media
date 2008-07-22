Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MIsGbU019982
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 14:54:16 -0400
Received: from smtp-vbr17.xs4all.nl (smtp-vbr17.xs4all.nl [194.109.24.37])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MIs16Y004116
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 14:54:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Date: Tue, 22 Jul 2008 20:53:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222053.46671.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	roel kluin <roel.kluin@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Fix for has_ir usage
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

Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-fixes for 
the following:

- tveeprom/ivtv: fix usage of has_ir field

Thanks to Roel Kluin for showing the problem. I fixed it differently 
than his patch, but I wouldn't have noticed the problem without him.

Regards,

        Hans

diffstat:
 drivers/media/video/ivtv/ivtv-driver.c |    5 ++---
 drivers/media/video/tveeprom.c         |   16 ++++++++--------
 include/media/tveeprom.h               |    7 ++++++-
 3 files changed, 16 insertions(+), 12 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
