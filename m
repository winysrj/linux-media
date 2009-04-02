Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n32KFYHj015599
	for <video4linux-list@redhat.com>; Thu, 2 Apr 2009 16:15:35 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n32KEoiZ016887
	for <video4linux-list@redhat.com>; Thu, 2 Apr 2009 16:15:12 -0400
Received: by rv-out-0506.google.com with SMTP id l9so786223rvb.51
	for <video4linux-list@redhat.com>; Thu, 02 Apr 2009 13:15:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 02 Apr 2009 13:15:10 -0700
From: <gabrield@kinuxlinux.org>
To: video4linux-list@redhat.com
Message-ID: <f8d9f984eb34bbf706b879d4f59eeec3@kinuxlinux.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Subject: Porting from V4L to V4L2
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

Hello All!

I'm trying to port a code from V4l to V4L2, but I'm not being happy!

For example, this following code:

static struct video_mmap* mmaps;

  if ( ioctl( deviceHandle , VIDIOCMCAPTURE , mmaps ) == -1 ) {
    perror("VIDIOCMCAPTURE");
	  return NULL;
  }

  if ( ioctl( deviceHandle , VIDIOCSYNC , &(mmaps->frame) ) == -1 ) {
    perror("VIDIOCMCAPTURE");
	  return NULL;
  }



I'd like use V4L2. I saw the specifications at
http://v4l2spec.bytesex.org/spec-single/v4l2.html , but I can't get
success!
Anyone can help me?
Thanks!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
