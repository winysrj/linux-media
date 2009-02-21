Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1LAtnqp019715
	for <video4linux-list@redhat.com>; Sat, 21 Feb 2009 05:55:49 -0500
Received: from yourtal3.yourtal.com (yourtal3.yourtal.com [209.172.44.134])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1LAtZKH026963
	for <video4linux-list@redhat.com>; Sat, 21 Feb 2009 05:55:35 -0500
Message-ID: <F13ADD43ECED4C45A8BE7A74E5B02BFE@W1>
From: "Sergei Antonov" <sa@sa.pp.ru>
To: <video4linux-list@redhat.com>
Date: Sat, 21 Feb 2009 13:55:27 +0300
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Subject: Genius Look 317
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

Hi!
I'm trying to make 'Genius Look 317' (0c45:60b0, gspca recognizes it) webcam work.

v4lgrab.c (from linux-2.6.28.5\Documentation\video4linux) loops infinitely in this code:

  do {
    int newbright;
    read(fd, buffer, win.width * win.height * bpp);
    f = get_brightness_adj(buffer, win.width * win.height, &newbright);
    if (f) {
      vpic.brightness += (newbright << 8);
      if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
        perror("VIDIOSPICT");
        break;
      }
    }
  } while (f);

because variable 'f' is always non-zero.
If I write 'while(0);' the resulting .ppm contains some random pixels in the top and the rest of the picture is black.
Need help.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
