Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MBMm7j030505
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 07:22:48 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MBMcA9010687
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 07:22:38 -0400
Received: by wr-out-0506.google.com with SMTP id c57so1115986wra.9
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 04:22:38 -0700 (PDT)
Message-ID: <d9def9db0804220422jfa83927p9ea572077a41e0ca@mail.gmail.com>
Date: Tue, 22 Apr 2008 13:22:37 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Mat <heavensdoor78@gmail.com>
In-Reply-To: <480DBCCD.7040402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480DBCCD.7040402@gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Empia em28xx based USB video device... (2)
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

On 4/22/08, Mat <heavensdoor78@gmail.com> wrote:
>
> Hi all.
> How do I test if the current driver support a specific kind of field type?
>
> The device I'm working with seems to work only in interlaced mode.
> V4L2_FIELD_NONE is ignored.
>
>  From v4l-info:
>
> video capture
>     VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
>         index                   : 0
>         type                    : VIDEO_CAPTURE
>         flags                   : 0
>         description             : "Packed YUY2"
>         pixelformat             : 0x56595559 [YUYV]
>     VIDIOC_G_FMT(VIDEO_CAPTURE)
>         type                    : VIDEO_CAPTURE
>         fmt.pix.width           : 720
>         fmt.pix.height          : 576
>         fmt.pix.pixelformat     : 0x56595559 [YUYV]
>         fmt.pix.field           : INTERLACED
>         fmt.pix.bytesperline    : 1440
>         fmt.pix.sizeimage       : 829440
>         fmt.pix.colorspace      : SMPTE170M
>         fmt.pix.priv            : 0
>
> Is it a module driver limit or an hardware limit?
> In Windows it seems ok... I don't think VLC ( I use it for testing on
> Win ) de-interlace automatically.
>
> Ideas?
> I have to de-interlace myself the frames I suppose...
>

The driver delivers full frames already since many TV applications
don't support deinterlacing of halfframes at all. That way is
hardcoded at the moment.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
