Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m152D85m014238
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:13:08 -0500
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m152CY9J019257
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:34 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1202176995@localhost>
Date: Mon, 04 Feb 2008 18:03:15 -0800
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org, laurent.pinchart@skynet.be
Cc: v4l-dvb-maintainer@linuxtv.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com
Subject: [PATCH 0 of 3] Round Two: videodev2.h additions for UVC merge 
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

Hello All,

Please review and pull from http://ifup.org/hg/v4l-spec for:

- Backed out changeset d002378ff8c2
- [v4l] Add new user class controls and deprecate others
- [v4l] Add camera class control definitions

 b/linux/drivers/media/video/Kconfig |    9 --
 b/linux/include/linux/videodev2.h   |    5 -
 b/mailimport                        |    4 -
 linux/include/linux/videodev2.h     |   50 ++++++++++++++--
 4 files changed, 46 insertions(+), 22 deletions(-)

V4L specification updates related to these changes can be found here:
  http://ifup.org/~philips/review/v4l2-proposed/x784.htm#CAMERA-CLASS
  http://ifup.org/~philips/review/v4l2-proposed/x536.htm

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
