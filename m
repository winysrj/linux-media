Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8TKw973032477
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 16:58:09 -0400
Received: from bay0-omc3-s20.bay0.hotmail.com (bay0-omc3-s20.bay0.hotmail.com
	[65.54.246.220])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8TKw6f4007469
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 16:58:07 -0400
Message-ID: <BAY122-W277E26F7DB592126DD2175AA400@phx.gbl>
From: Elvis Chen <chene77@hotmail.com>
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Date: Mon, 29 Sep 2008 20:58:05 +0000
In-Reply-To: <20080301234821.GA1691@daniel.bse>
References: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
	<20080301234821.GA1691@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: RE: newbie programming help:  grabbing image(s) from /dev/video0,
 example code?
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


hi Daniel and others=2C

First off=2C thanks for your reply.  I have written a small c application t=
hat basically is your code=2C I'm able to capture an image=2C decode the yu=
v frame=2C and display it on the screen.  However=2C I think it drops frame=
 once a while.

Can you please tell me if pvr-150 support memory mapped IO?=20

I have tried to run the capture_example from=20
http://www.video4linux.org/browser/v4l2-apps/test

and it appears that the Hauppauge pvr-150 does not:

or1float [4:51pm]>./capture_example -m -d /dev/video32
/dev/video32 does not support streaming i/o

or1float [4:51pm]>./capture_example -m -d /dev/video0
/dev/video0 does not support streaming i/o


is there another way to increase the performance?

thanks=2C



> Date: Sun=2C 2 Mar 2008 00:48:21 +0100
> From: daniel-gl@gmx.net
> To: chene77@hotmail.com
> CC: video4linux-list@redhat.com
> Subject: Re: newbie programming help:  grabbing image(s) from /dev/video0=
=2C example code?
>=20
> On Sat=2C Mar 01=2C 2008 at 09:33:08PM +0000=2C Elvis Chen wrote:
> > We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 mac=
hine.
> > They appear to the linux as /dev/video0 and /dev/video1=2C respectively=
.
>=20
> On this card video0 and video1 are for MPEG captures.
> Use video32 and video33 for YUV captures.
>=20
> The only possible YUV format is 4:2:0 with rearranged bytes.
> Read Documentation/video4linux/cx2341x/README.hm12.
>=20
> > My first attempt was to find a small/simple API to access the linux/vid=
eo device.
>=20
> No need to find another API=2C V4L2 is small enough:
>=20
> #include <linux/videodev2.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <unistd.h>
>=20
> static unsigned char image[720*480*3/2]=3B
>=20
> int main()
> {
>   struct v4l2_format vf=3B
>   int i=3D1=2Cfd=3Dopen("/dev/video32"=2CO_RDWR)=3B
>   ioctl(fd=2CVIDIOC_S_INPUT=2C&i)=3B
>   memset(&vf=2C0=2Csizeof(vf))=3B
>   vf.type=3DV4L2_BUF_TYPE_VIDEO_CAPTURE=3B
>   vf.fmt.pix.width=3D720=3B
>   vf.fmt.pix.height=3D480=3B
>   vf.fmt.pix.pixelformat=3DV4L2_PIX_FMT_HM12=3B
>   vf.fmt.pix.field=3DV4L2_FIELD_INTERLACED=3B
>   vf.fmt.pix.bytesperline=3Dvf.fmt.pix.width=3B
>   ioctl(fd=2CVIDIOC_S_FMT=2C&vf)=3B
>   write(1=2Cimage=2Cread(fd=2Cimage=2Csizeof(image)))=3B
>   return 0=3B
> }
>=20
> You may want to insert some error checks :-)
> And if you want better performance=2C use memory mapped I/O.
>=20
>   Daniel

_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
