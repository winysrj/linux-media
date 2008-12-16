Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGAfXTs003988
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:41:33 -0500
Received: from bay0-omc1-s18.bay0.hotmail.com (bay0-omc1-s18.bay0.hotmail.com
	[65.54.246.90])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGAfIcY014507
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:41:18 -0500
Message-ID: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
From: Lehel Kovach <lehelkovach@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Tue, 16 Dec 2008 02:41:17 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: quickcam express
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


does v4l have an issue with quickcam express?  i keep getting this unknown =
error 515 and dont know if its a v4l issue or an issue of my quickcam drive=
r:

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
    name                    : "Logitech QuickCam USB"
    type                    : 0x0 []
    channels                : 1
    audios                  : 0
    maxwidth                : 360
    maxheight               : 296
    minwidth                : 32
    minheight               : 32

libv4l2: error getting capabilities: Unknown error 515
ioctl: VIDIOC_QUERYCAP(driver=3D""=3Bcard=3D""=3Bbus_info=3D""=3Bversion=3D=
0.0.0=3Bcapabilities=3D0x0 []): Unknown error 515

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
