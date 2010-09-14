Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o8E4taeM014115
	for <video4linux-list@redhat.com>; Tue, 14 Sep 2010 00:55:36 -0400
Received: from n63.bullet.mail.sp1.yahoo.com (n63.bullet.mail.sp1.yahoo.com
	[98.136.44.33])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o8E4tR55015585
	for <video4linux-list@redhat.com>; Tue, 14 Sep 2010 00:55:27 -0400
Message-ID: <768645.43657.qm@web45308.mail.sp1.yahoo.com>
Date: Mon, 13 Sep 2010 21:43:06 -0700 (PDT)
From: bad boy <badmash69@yahoo.com>
Subject: extend video capture example to capture mpeg video file
To: video4linux-list@redhat.com
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
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi

I have a Hauppage TV capture card that seems to be working . I can use the

cat /dev/video0 > test.mpeg to capture a video file to hard disk.

I am trying to adapt the video capture example, source  "capture.c" to  capture 
the mpeg file.

The example code ins capture.c calls the read_frame() function that then calls 
process image, which writes a "." to the screen.


What do I need to modify to capture a proper mpeg file ? 


Your help would be deeply appreciated.

Thanks
badam



      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
