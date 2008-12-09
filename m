Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9NLoRb028005
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:50 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9NLdNZ008947
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:39 -0500
Received: from hypnosis.jim.sh (BUCKET.MIT.EDU [18.90.1.139])
	by psychosis.jim.sh (8.14.3/8.14.3/Debian-5) with SMTP id
	mB9NLaVL029533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=OK)
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:37 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1228864538@hypnosis.jim>
Date: Tue, 09 Dec 2008 18:15:38 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Subject: [PATCH 0 of 2] gspca, ov534 framerate support
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

Hi,

These two patches add frame rate support to ov534, as expected by
programs like luvcview.  The first adds a gspca passthrough for
VIDIOC_G_PARM and VIDIOC_S_PARM to subdrivers, and the second adds
their implementation to ov534.

Mplayer still doesn't get the FPS (it must do something different),
but luvcview works correctly:

$ luvcview -i 50
luvcview 0.2.4

SDL information:
  Video driver: x11
  A window manager is available
Device information:
  Device path:  /dev/video0
Stream settings:
  Frame format: YUYV (MJPG is not supported by device)
  Frame size:   640x480
  Frame rate:   50 fps

Comments?

-jim

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
