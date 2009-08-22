Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx06.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7MLgVYX010142
	for <video4linux-list@redhat.com>; Sat, 22 Aug 2009 17:42:31 -0400
Received: from col0-omc3-s7.col0.hotmail.com (col0-omc3-s7.col0.hotmail.com
	[65.55.34.145])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7MLgIIT010888
	for <video4linux-list@redhat.com>; Sat, 22 Aug 2009 17:42:19 -0400
Message-ID: <COL121-W59DBB36A6C20DA86B99BA8D8FB0@phx.gbl>
From: not disclosed <n0td1scl0s3d@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Sat, 22 Aug 2009 21:42:18 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: UVC / V4L2 webcam / grab
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




I need to grab single frames from a UVC / V4L2 webcam with low latency and =
I need the frame
to be acquired ASAP _after_ another event has occurred.  The code I am usin=
g is ~ that below
and the problem I have is that unless I grab one frame and discard it I fin=
d the frame I grab (the=20
image) sometimes contains things that could only occur _prior_ to the captu=
re code being called.

In pseudo code my problem looks like this:

set_condition(1)=3B
usleep(DELAY)=3B
...
set_condition(2)=3B
usleep(DELAY)=3B
grabframe(data)=3B

The problem is the data may contain output from condition (1) even if DELAY=
 is long enough=20
to guarantee the image should only contain and image from condition (2). If=
 I do something like:



set_condition(1)=3B

usleep(DELAY)=3B

...

set_condition(2)=3B

usleep(DELAY)=3B

grabframe(data)=3B

grabframe(data)=3B


the second grab returns the correct image regardless of what DELAY I use.

This may be a stupid problem and I am not too familiar with how V4L2 works =
but here goes:

What is the easiest way to use V4L2 to grab an individual frame from a UVC =
webcam and
ensure that the data in the frame relates to an image that occurred _after_=
 the grab was=20
requested? second part is=2C what is the fastest / simplest way to do this?

I don't even know if it is possible to ensure this because I suppose hardwa=
re limitations=20
may prevent a deterministic result. =20

Sorry for cryptic explanation=2C the detailed one would take a huge space t=
o explain. =20
Simplest terms I am changing the lighting conditions then capturing the res=
ult=2C say this was
from red->blue lighting=2C some of my grabbed images contain red when it wo=
uld be impossible
to do so unless the data I received was captured before I requested it.

Cheers=2C

SA

// code snippet



// set up...
int type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE=3B
ret =3D ioctl (vd->fd=2C VIDIOC_STREAMON=2C &type)=3B



// code to run at capture
memset (&vd->buf=2C 0=2C sizeof (struct v4l2_buffer))=3B
vd->buf.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE=3B
vd->buf.memory =3D V4L2_MEMORY_MMAP=3B
ret =3D ioctl (vd->fd=2C VIDIOC_DQBUF=2C &vd->buf)=3B
memcpy (vd->framebuffer=2C vd->mem[vd->buf.index]=2C(size_t) vd->framesizeI=
n)=3B
ret =3D ioctl (vd->fd=2C VIDIOC_QBUF=2C &vd->buf)=3B

_________________________________________________________________
Share your memories online with anyone you want.
http://www.microsoft.com/middleeast/windows/windowslive/products/photos-sha=
re.aspx?tab=3D1=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
