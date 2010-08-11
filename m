Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7BKpfQC007114
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:51:41 -0400
Received: from web35307.mail.mud.yahoo.com (web35307.mail.mud.yahoo.com
	[66.163.179.101])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o7BKpWLs015931
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:51:32 -0400
Message-ID: <757323.81341.qm@web35307.mail.mud.yahoo.com>
Date: Wed, 11 Aug 2010 13:51:31 -0700 (PDT)
From: Curtis Schroeder <cstarjewel@yahoo.com>
Subject: Re: Philips SPC 900NC PC Camera via usb with v4l
To: video4linux-list@redhat.com, maddin2010 <martin.moors@smail.inf.h-brs.de>
In-Reply-To: <1279620753610-5316010.post@n2.nabble.com>
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi Martin,



I'm not an expert on this, but with some help from this list I was able =

to get my SPC 600 NC working.=A0 Let's start with some of the same =

diagnostics.



Is there an entry for your web cam when you execute the following command?


lsusb



One of my problems with the SPC 600 NC was the sn9c102 module was being =

erroneously loaded.=A0 What do you get when you execute the following =

command?

lsmod | grep sn9c



In the case of the SPC 600 NC, I needed the system to use the gspca =

module.=A0 I had to remove the sn9c102 module and then blacklist it so =

future kernel updates wouldn't reload it.



Let us know what you find,



Curt

--- On Tue, 7/20/10, maddin2010 <martin.moors@smail.inf.h-brs.de> wrote:

From: maddin2010 <martin.moors@smail.inf.h-brs.de>
Subject: Philips SPC 900NC PC Camera via usb with v4l
To: video4linux-list@redhat.com
Date: Tuesday, July 20, 2010, 11:12 AM


Hi,

Iam trying to capture a video or an image from the Philips SPC 900NC PC
Camera - Webcam.

I downloded the capture.c file and changed following lines.

...
//had to be replaced from - fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_YUYV; =
to
fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_YUV420;
fmt.fmt.pix.field=A0 =A0 =A0=A0=A0=3D V4L2_FIELD_INTERLACED;
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


-- =

View this message in context: http://video4linux-list.1448896.n2.nabble.com=
/Philips-SPC-900NC-PC-Camera-via-usb-with-v4l-tp5316010p5316010.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list



      =

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
