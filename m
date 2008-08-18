Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I4ZZje030979
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 00:35:35 -0400
Received: from relay01.pair.com (relay01.pair.com [209.68.5.15])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7I4ZP0a004760
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 00:35:25 -0400
Message-ID: <013a01c900eb$d77a7090$2000a8c0@Sneha>
From: "ravi" <ravi@mrt-communication.com>
To: <video4linux-list@redhat.com>
Date: Mon, 18 Aug 2008 10:05:27 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: video errors while running USB webcam on ARM linux system
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

This is my first post in this forum.


I am using a USB webcam from Dream Logic-AP1501,a taiwanese company.I =
have downloaded the provided by you i.e gspca-20071224 tar file.I am =
trying this USB webcam=20

to work on ARM9 processor,after cross compiling  and porting the module, =
i am able to detect my USB webcam  as "SONIX JPEG camera".


As an application,i have downloaded spcaview-2006108 and i am able =
develop spcacat,spcasev executables.These are the applications which are =
supported by thr driver which i have downloaded.


Second problem: [On ARM based system]


while running this command:


spcaserv -d /dev/video0 320*240 -w 30 -f yuv


i am getting error: "Error in opening V4L interface".I checked with =
dmesg command:

I am getting this messages:


"/source/gspcav1-20071224/gspca_core.c:init isoc:usb_submit_urb(0) ret =
-38"

split I/O support disabled"


After googling and reading some discussions, i have came to know that:


error -38  is ENOSYS comming from the usb layer, and the the Webcam =
driver writer has suggested to change the USB socket.
I need your support for these problems.


Thanks & Regards,
Ravi Chobey
Embedded Engineer,
MRT Communication,
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
