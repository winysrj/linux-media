Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34724 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbdA0XPV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 18:15:21 -0500
Received: by mail-oi0-f49.google.com with SMTP id s203so34007763oie.1
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2017 15:15:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGS+X6PHC+f2kgtgxKQi6Z5wrFh-LbBDp_in54jR3jh=T++eWA@mail.gmail.com>
References: <CAGS+X6PHC+f2kgtgxKQi6Z5wrFh-LbBDp_in54jR3jh=T++eWA@mail.gmail.com>
From: Hamidreza Jafari <hamidrjafari@gmail.com>
Date: Sat, 28 Jan 2017 02:14:11 +0330
Message-ID: <CAGS+X6NE-U50jtp6=9=hPDUQm1v71SNCWstOUspRMgsBs8Y=jg@mail.gmail.com>
Subject: Fwd: Upside down webcam
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
There is a problem with the webcam that uses v4l code. If anyone has a
hint, contact me on hamidrjafari@gmail.com since I am going off the
mailing list since
The mailing list is sending numerous notifications

Hamid
=D8=A8=D8=A7 =D8=B3=D9=BE=D8=A7=D8=B3=D8=8C
=D8=AD=D9=85=DB=8C=D8=AF=D8=B1=D8=B6=D8=A7 =D8=AC=D8=B9=D9=81=D8=B1=DB=8C



=E2=80=8E---------- Forwarded message ----------=E2=80=8E
From: Hamidreza Jafari =E2=80=8E<hamidrjafari@gmail.com>=E2=80=8E
Date: 2017-01-27 22:08 GMT+03:30
Subject: Upside down webcam
To:  =E2=80=ABlinux-media@vger.kernel.org=E2=80=AC


Hello,

https://linuxtv.org/wiki/index.php/Libv4l_Upside_Down_Webcams

The webcam is upside down and the solution does not work (as it did in
a previous Ubuntu version). On Kubuntu 16.10 with 4.8.0-34 kernel I
installed an app called Webcamoid to test and ran the following
commands:

$export LIBV4LCONTROL_FLAGS=3D3 &&
LD_PRELOAD=3D/usr/lib/x86_64-linux-gnu/libv4l/v4l1compat.so webcamoid &
file:///usr/lib/x86_64-linux-gnu/qt5/qml/QtQuick/Controls/TextField.qml:635=
:5:
QML TextInputWithHandles: Binding loop detected for property "text"
file:///usr/lib/x86_64-linux-gnu/qt5/qml/QtQuick/Controls/TextField.qml:635=
:5:
QML TextInputWithHandles: Binding loop detected for property "text"
libv4l2: error setting pixformat: Device or resource busy
libv4l2: error setting pixformat: Device or resource busy
VideoCapture: No streams available.

$ v4l2-ctl -d /dev/video0 --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
Index : 0
Type : Video Capture
Pixel Format: 'YUYV'
Name : YUYV 4:2:2
Size: Discrete 640x480
Interval: Discrete 0.033s (30.000 fps)
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 352x288
Interval: Discrete 0.033s (30.000 fps)
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 320x240
Interval: Discrete 0.033s (30.000 fps)
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 176x144
Interval: Discrete 0.033s (30.000 fps)
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 160x120
Interval: Discrete 0.033s (30.000 fps)
Interval: Discrete 0.067s (15.000 fps)

$v4l2-ctl --device=3D/dev/video0 --list-inputs
ioctl: VIDIOC_ENUMINPUT
Input : 0
Name : Camera 1
Type : 0x00000002
Audioset : 0x00000000
Tuner : 0x00000000
Standard : 0x0000000000000000 ()
Status : 0x00000000 (ok)
Capabilities: 0x00000000 (not defined)

How to fix the problem?

Hamid
=D8=A8=D8=A7 =D8=B3=D9=BE=D8=A7=D8=B3=D8=8C
=D8=AD=D9=85=DB=8C=D8=AF=D8=B1=D8=B6=D8=A7 =D8=AC=D8=B9=D9=81=D8=B1=DB=8C
