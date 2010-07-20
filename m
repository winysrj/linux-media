Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6KACiJp020295
	for <video4linux-list@redhat.com>; Tue, 20 Jul 2010 06:12:45 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6KACYKK007257
	for <video4linux-list@redhat.com>; Tue, 20 Jul 2010 06:12:34 -0400
Received: from jim.nabble.com ([192.168.236.80])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <martin.moors@smail.inf.h-brs.de>) id 1Ob9oP-0002iP-Jr
	for video4linux-list@redhat.com; Tue, 20 Jul 2010 03:12:33 -0700
Date: Tue, 20 Jul 2010 03:12:33 -0700 (PDT)
From: maddin2010 <martin.moors@smail.inf.h-brs.de>
To: video4linux-list@redhat.com
Message-ID: <1279620753610-5316010.post@n2.nabble.com>
Subject: Philips SPC 900NC PC Camera via usb with v4l
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi,

Iam trying to capture a video or an image from the Philips SPC 900NC PC
Camera - Webcam.

I downloded the capture.c file and changed following lines.

...
//had to be replaced from - fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV; to
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
fmt.fmt.pix.field       = V4L2_FIELD_INTERLACED;
...

than after compiling and executing I get an output of dots.

Do I have to download somewhere a headerfile, becaue in the Spec is a header
file which is not on the homepage.

What I need is a little push, so I maybe see an image or an video from the
webcam, so that I can begin experimenting with it.

Is the video somewhere in the Memmory in form of a stream ?

Hopefully you can help me a bit,

Thx in advance,

Martin


-- 
View this message in context: http://video4linux-list.1448896.n2.nabble.com/Philips-SPC-900NC-PC-Camera-via-usb-with-v4l-tp5316010p5316010.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
