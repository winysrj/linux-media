Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m23KAWfH030431
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 15:10:32 -0500
Received: from bay0-omc3-s26.bay0.hotmail.com (bay0-omc3-s26.bay0.hotmail.com
	[65.54.246.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m23K9vQl012746
	for <video4linux-list@redhat.com>; Mon, 3 Mar 2008 15:09:57 -0500
Message-ID: <BAY122-W521F20C3B234BFCFC64FA0AA170@phx.gbl>
From: Elvis Chen <chene77@hotmail.com>
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Date: Mon, 3 Mar 2008 20:09:51 +0000
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



Thank you all.

With the following code and the documentation for hm12, I managed to grab a=
 video from /dev/video32 (YUV) and converted the input YUV image to RGB out=
put.  I was then able to view it using imagemagick.

My code turned out to be similar to hm12toyuv (available at http://highlab.=
com/~seb/hm12toyuv/ ) so I won't bother posting it here.  It isn't surprisi=
ng since hm12toyuv is based on the example on the same documention (for hm1=
2) as well.

I do find the grabbing process slow and may not be suitable for my applicat=
ion.  I'll investigate on using memory mapped I/O once the rest of my appli=
cation is at a reasonable state.

Thanks again,

Elvis


> Date: Sun, 2 Mar 2008 00:48:21 +0100
> From: daniel-gl@gmx.net
> To: chene77@hotmail.com
> CC: video4linux-list@redhat.com
> Subject: Re: newbie programming help:  grabbing image(s) from /dev/video0=
, example code?
>=20
> On Sat, Mar 01, 2008 at 09:33:08PM +0000, Elvis Chen wrote:
> > We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 mac=
hine.
> > They appear to the linux as /dev/video0 and /dev/video1, respectively.
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
> No need to find another API, V4L2 is small enough:
>=20
> #include <linux/videodev2.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <unistd.h>
>=20
> static unsigned char image[720*480*3/2];
>=20
> int main()
> {
>   struct v4l2_format vf;
>   int i=3D1,fd=3Dopen("/dev/video32",O_RDWR);
>   ioctl(fd,VIDIOC_S_INPUT,&i);
>   memset(&vf,0,sizeof(vf));
>   vf.type=3DV4L2_BUF_TYPE_VIDEO_CAPTURE;
>   vf.fmt.pix.width=3D720;
>   vf.fmt.pix.height=3D480;
>   vf.fmt.pix.pixelformat=3DV4L2_PIX_FMT_HM12;
>   vf.fmt.pix.field=3DV4L2_FIELD_INTERLACED;
>   vf.fmt.pix.bytesperline=3Dvf.fmt.pix.width;
>   ioctl(fd,VIDIOC_S_FMT,&vf);
>   write(1,image,read(fd,image,sizeof(image)));
>   return 0;
> }
>=20
> You may want to insert some error checks :-)
> And if you want better performance, use memory mapped I/O.
>=20
>   Daniel

_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
