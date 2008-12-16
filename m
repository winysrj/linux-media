Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGBPq1e028567
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 06:25:52 -0500
Received: from bay0-omc1-s29.bay0.hotmail.com (bay0-omc1-s29.bay0.hotmail.com
	[65.54.246.101])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGBPQC2008954
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 06:25:26 -0500
Message-ID: <BAY135-W42D66F5E93C125272EB2B0BFF50@phx.gbl>
From: Lehel Kovach <lehelkovach@hotmail.com>
To: <desktop1.peg@wipro.com>, <video4linux-list@redhat.com>
Date: Tue, 16 Dec 2008 03:25:25 -0800
In-Reply-To: <4538A50912F8FE4686913FFD3CD4C2931A19D2@pnd-iet-msg.wipro.com>
References: <BAY135-W47952C51F5ED0CAEE9809BFF50@phx.gbl>
	<4538A50912F8FE4686913FFD3CD4C2931A19D2@pnd-iet-msg.wipro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: RE: quickcam express
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


thx for the quick reply.

luvcview compiled fine and when ran i get this error:

Error opening device /dev/video0: unable to query device.
 Init v4L2 failed !! exit fatal=20

when i tried compiling uvcvideo=2C it fails with this output:

Building USB Video Class driver...
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-9-generic'
  CC [M]  /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.o
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:14:1: warning: "V4L2_CID=
_BACKLIGHT_COMPENSATION" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:869:1: warning: this is the location of the previ=
ous definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:15:1: warning: "V4L2_CID=
_POWER_LINE_FREQUENCY" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:860:1: warning: this is the location of the previ=
ous definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:16:1: warning: "V4L2_CID=
_SHARPNESS" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:868:1: warning: this is the location of the previ=
ous definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:17:1: warning: "V4L2_CID=
_HUE_AUTO" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:866:1: warning: this is the location of the previ=
ous definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:19:1: warning: "V4L2_CID=
_FOCUS_AUTO" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1085:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:20:1: warning: "V4L2_CID=
_FOCUS_ABSOLUTE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1083:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:21:1: warning: "V4L2_CID=
_FOCUS_RELATIVE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1084:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:23:1: warning: "V4L2_CID=
_PAN_RELATIVE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1075:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:24:1: warning: "V4L2_CID=
_TILT_RELATIVE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1076:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:27:1: warning: "V4L2_CID=
_EXPOSURE_AUTO" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1065:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:28:1: warning: "V4L2_CID=
_EXPOSURE_ABSOLUTE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:1072:1: warning: this is the location of the prev=
ious definition
In file included from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
45:
/home/lehel/drivers/uvcvideo-r104/trunk/uvcvideo.h:31:1: warning: "V4L2_CID=
_WHITE_BALANCE_TEMPERATURE" redefined
In file included from include/linux/videodev.h:16=2C
                 from /home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:=
36:
include/linux/videodev2.h:867:1: warning: this is the location of the previ=
ous definition
/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c: In function =91uvc_re=
gister_video=92:
/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:1322: error: incompati=
ble types in assignment
/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:1323: error: =91struct=
 video_device=92 has no member named =91type=92
/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:1324: error: =91struct=
 video_device=92 has no member named =91type2=92
/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.c:1325: error: =91struct=
 video_device=92 has no member named =91hardware=92
make[2]: *** [/home/lehel/drivers/uvcvideo-r104/trunk/uvc_driver.o] Error 1
make[1]: *** [_module_/home/lehel/drivers/uvcvideo-r104/trunk] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-9-generic'
make: *** [uvcvideo] Error 2


> Subject: RE: quickcam express
> Date: Tue=2C 16 Dec 2008 16:14:21 +0530
> From: desktop1.peg@wipro.com
> To: lehelkovach@hotmail.com=3B video4linux-list@redhat.com
>=20
> Dear=2C
>      Try for this.
>=20
> Regards=2C
> M.Karthikeyan.
> =20
> -----Original Message-----
> From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Lehel Kovach
> Sent: Tuesday=2C December 16=2C 2008 4:11 PM
> To: video4linux-list@redhat.com
> Subject: quickcam express
>=20
>=20
> does v4l have an issue with quickcam express?  i keep getting this
> unknown error 515 and dont know if its a v4l issue or an issue of my
> quickcam driver:
>=20
> ### video4linux device info [/dev/video0] ###
> general info
>     VIDIOCGCAP
>     name                    : "Logitech QuickCam USB"
>     type                    : 0x0 []
>     channels                : 1
>     audios                  : 0
>     maxwidth                : 360
>     maxheight               : 296
>     minwidth                : 32
>     minheight               : 32
>=20
> libv4l2: error getting capabilities: Unknown error 515
> ioctl:
> VIDIOC_QUERYCAP(driver=3D""=3Bcard=3D""=3Bbus_info=3D""=3Bversion=3D0.0.0=
=3Bcapabilities
> =3D0x0 []): Unknown error 515
>=20
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dsubscrib=
e
> https://www.redhat.com/mailman/listinfo/video4linux-list
>=20
> Please do not print this email unless it is absolutely necessary.=20
>=20
> The information contained in this electronic message and any attachments =
to this message are intended for the exclusive use of the addressee(s) and =
may contain proprietary=2C confidential or privileged information. If you a=
re not the intended recipient=2C you should not disseminate=2C distribute o=
r copy this e-mail. Please notify the sender immediately and destroy all co=
pies of this message and any attachments.=20
>=20
> WARNING: Computer viruses can be transmitted via email. The recipient sho=
uld check this email and any attachments for the presence of viruses. The c=
ompany accepts no liability for any damage caused by any virus transmitted =
by this email.=20
>=20
> www.wipro.com
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
