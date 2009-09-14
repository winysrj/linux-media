Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8E5os3P011721
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 01:50:54 -0400
Received: from col0-omc3-s8.col0.hotmail.com (col0-omc3-s8.col0.hotmail.com
	[65.55.34.146])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8E5oeji018595
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 01:50:40 -0400
Message-ID: <COL124-W6F59C0DE926F2BC8DA4C288E40@phx.gbl>
From: Guilherme Longo <incorpnet1@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Mon, 14 Sep 2009 02:50:39 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Subject: I can't get all pixels values from my driver. plz help ;0(
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

After 3 weeks trying to solve my problem=2C I am about to give up and find =
another solution instead of trying to fix this one.
I have changed few things in the capture.c example available for download a=
t http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/ and
the altered code can be seen here: http://pastebin.com/m7ef25480

So... what is the problem?

Well=2C I have set the following configuration for capture:

        fmt.type                =3D V4L2_BUF_TYPE_VIDEO_CAPTURE=3B
        fmt.fmt.pix.width       =3D 160=3B
        fmt.fmt.pix.height      =3D 120=3B
        fmt.fmt.pix.pixelformat =3D V4L2_PIX_FMT_RGB32=3B
        fmt.fmt.pix.field       =3D V4L2_FIELD_INTERLACED=3B

All the process is implemented in a function called process_image(void * p)=
 where p is a void pointer to the buffer where the frames captures should b=
e stored.

this is the function that reads the buffer:

if (-1 =3D=3D read (fd=2C buffers[0].start=2C buffers[0].length))   (length=
 =3D 160x120 -> 19200)

then after=2C I call the process_image function:
process_image (buffers[0].start)=3B

What I need is read the buffer separation the R=2C G=2C B=2C A storing them=
 in unsigned char variables.=20

It should have 19.200 pixel (160x120) but instead=2C look what i have got:

[0]87 [0]110 [0]68 [0]134
[1]202 [1]73 [1]119 [1]109
[2]213 [2]36 [2]73 [2]33
.....
.....
[1287]73 [1287]100 [1287]150 [1287]133
[1288]69 [1288]133 [1288]4 [1288]0
[1289]0 [1289]0 [1289]0 [1289]0
[1290]0 [1290]0 [1290]0 [1290]0
[1291]0 [1291]0 [1291]0 [1291]0
.....
[4799]0 [4799]0 [4799]0 [4799]0
[0]80 [0]105 [0]145 [0]4
[1]146 [1]18 [1]108 [1]182
[2]68 [2]136 [2]137 [2]170

As you can see=2C I get only 1289 pixels with values and all the rest are 0=
=3B=20
When the function is called again=2C the same happens over and over.

So... why am I getting only 1289 pixel with values when in fact it should b=
e 160x120 pixel corresponding to 1 frame?
I am begging help 'cause my arsenal's over.. I am really out of ideas!

Thanks a lot!



_________________________________________________________________
Drag n=92 drop=97Get easy photo sharing with Windows Live=99 Photos.

http://www.microsoft.com/windows/windowslive/products/photos.aspx=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
