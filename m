Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MAOmTc002155
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 06:24:48 -0400
Received: from MTA010E.interbusiness.it (MTA010E.interbusiness.it
	[88.44.62.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MAOQr7003552
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 06:24:28 -0400
Message-ID: <480DBCCD.7040402@gmail.com>
Date: Tue, 22 Apr 2008 12:24:13 +0200
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Empia em28xx based USB video device... (2)
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


Hi all.
How do I test if the current driver support a specific kind of field type?

The device I'm working with seems to work only in interlaced mode.
V4L2_FIELD_NONE is ignored.

 From v4l-info:

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "Packed YUY2"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 720
        fmt.pix.height          : 576
        fmt.pix.pixelformat     : 0x56595559 [YUYV]
        fmt.pix.field           : INTERLACED
        fmt.pix.bytesperline    : 1440
        fmt.pix.sizeimage       : 829440
        fmt.pix.colorspace      : SMPTE170M
        fmt.pix.priv            : 0

Is it a module driver limit or an hardware limit?
In Windows it seems ok... I don't think VLC ( I use it for testing on 
Win ) de-interlace automatically.

Ideas?
I have to de-interlace myself the frames I suppose...

Thanks in advance.
-Mat-

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
