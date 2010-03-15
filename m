Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2FMbJSp003186
	for <video4linux-list@redhat.com>; Mon, 15 Mar 2010 18:37:19 -0400
Received: from mail-ew0-f213.google.com (mail-ew0-f213.google.com
	[209.85.219.213])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2FMb63T011798
	for <video4linux-list@redhat.com>; Mon, 15 Mar 2010 18:37:06 -0400
Received: by ewy5 with SMTP id 5so1433263ewy.30
	for <video4linux-list@redhat.com>; Mon, 15 Mar 2010 15:37:05 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Mar 2010 00:36:56 +0200
Message-ID: <e11f65a41003151536h63467c8dh9f519a699baa9ea1@mail.gmail.com>
Subject: Frame Rate settings on gspca v4l1
From: mahmut gundes <m.gundes@gmail.com>
To: video4linux-list@redhat.com
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

Hi everybody, I am newbie on webcams and drivers. I tried to use my webcam
on a embedded device which has usb host. I used mjpeg-streamer application
with gspca. 2.6.22 version linux kernel run on my board. So I used old gspca
driver from http://mxhaard.free.fr/download.html. This driver works up to
v4l1 standart. I used mjpegstreamer's gspcav1 plugin and it worked well. But
I need to set frame rate for cpu performance issue.

I searched how I can set frame rate on v4l1 standart but I couldnt find any
usefull informations. May anyone has advice about this issue, or link, or
clue? [image: Smile]

Regards,

mgundes
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
