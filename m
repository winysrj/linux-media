Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m27IW8TJ013742
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 13:32:08 -0500
Received: from bay0-omc1-s23.bay0.hotmail.com (bay0-omc1-s23.bay0.hotmail.com
	[65.54.246.95])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m27IVaiR004334
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 13:31:36 -0500
Message-ID: <BAY122-W224CF334D059C7EE3E815AAA130@phx.gbl>
From: Elvis Chen <chene77@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Fri, 7 Mar 2008 18:30:52 +0000
In-Reply-To: <BAY122-W14E297EBF5690C81018A37AA130@phx.gbl>
References: <BAY122-W356EE227C3E496A044E7B3AA120@phx.gbl>
	<BAY122-W14E297EBF5690C81018A37AA130@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: RE: is it possible to grab images from 2 PVR-150 in a loop/timer?
 (CODE ATTACHED)
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


hi all,

Thanks for who replied.  It turned out to be a bug in the ivtv driver, whic=
h was fixed in kernel 2.6.24.  I've upgraded the kernel on my linux machine=
 and it works now.

Elvis


> From: chene77@hotmail.com
> To: video4linux-list@redhat.com
> Date: Fri, 7 Mar 2008 00:08:19 +0000
> Subject: RE: is it possible to grab images from 2 PVR-150 in a loop/timer=
? (CODE ATTACHED)
>=20
>=20
> hi all,
>=20
> I thought I should follow up with more technical detail.  Here is the cod=
e example that would causes corrupted image:
>=20
>=20
>=20
>   int i =3D 1, j =3D 1;
>   int iwidth =3D 720, iheight =3D 480;
>=20
>   struct v4l2_format vf, vf1;
>   int fd =3D open( "/dev/video32", O_RDWR);
>   ioctl( fd, VIDIOC_S_INPUT, &i );
>   memset(&vf,0,sizeof(vf));
>   vf.type=3DV4L2_BUF_TYPE_VIDEO_CAPTURE;
>   vf.fmt.pix.width=3Diwidth;
>   vf.fmt.pix.height=3Diheight;
>   vf.fmt.pix.pixelformat=3DV4L2_PIX_FMT_HM12;
>   vf.fmt.pix.field=3DV4L2_FIELD_INTERLACED;
>   vf.fmt.pix.bytesperline=3Dvf.fmt.pix.width;
>   ioctl(fd,VIDIOC_S_FMT,&vf);
>=20
>   int fd1 =3D open( "/dev/video33", O_RDWR);
>   ioctl( fd1, VIDIOC_S_INPUT, &j );
>   memset(&vf1,0,sizeof(vf1));
>   vf1.type=3DV4L2_BUF_TYPE_VIDEO_CAPTURE;
>   vf1.fmt.pix.width=3Diwidth;
>   vf1.fmt.pix.height=3Diheight;
>   vf1.fmt.pix.pixelformat=3DV4L2_PIX_FMT_HM12;
>   vf1.fmt.pix.field=3DV4L2_FIELD_INTERLACED;
>   vf1.fmt.pix.bytesperline=3Dvf1.fmt.pix.width;
>   ioctl(fd1,VIDIOC_S_FMT,&vf1);
>=20
>   uint8_t *image, *imagey, *imageu, *imagev, *imageRGB;
>   image    =3D new uint8_t[ iwidth * iheight * 3 / 2 ];
>   imagey   =3D new uint8_t[ iwidth * iheight  ];
>   imageu   =3D new uint8_t[ iwidth * iheight / 4 ];
>   imagev   =3D new uint8_t[ iwidth * iheight / 4 ];
>   imageRGB =3D new uint8_t[ iwidth * iheight * 3 ];
>  =20
> // read from tuner 1
>   if ( read( fd, image, iwidth*iheight*3/2 ) =3D=3D -1 ) {
>     std::cerr << "error grabbing YUV image" << std::endl;
>     exit(1);
>   }
>  =20
> // read from tuner 2
>   if ( read( fd1, image, iwidth*iheight*3/2 ) =3D=3D -1 ) {
>     std::cerr << "error grabbing YUV image" << std::endl;
>     exit(1);
>   }
>  =20
> // read from tuner 1 again
>   if ( read( fd, image, iwidth*iheight*3/2 ) =3D=3D -1 ) {
>     std::cerr << "error grabbing YUV image" << std::endl;
>     exit(1);
>   }
>  =20
>   // decrypt the microblocks
>   de_macro_y( imagey, image, iwidth, iwidth, iheight );
>   de_macro_uv( imageu, imagev, image+(iwidth*iheight),
>            iwidth/2, iwidth/2, iheight/2 );
>   // convert the YUV image to RGB
>   YUV2RGB( imageRGB, imagey, imageu, imagev, iwidth, iheight );
>  =20
> if one displays the RGB array (imageRGB), the image stored in it is corru=
pted.  It loos like all pixels are quadruple in both x/y direction; the ima=
ge also appear to be duplicated/shifted.
>=20
>=20
> if one *DOES NOT* read from tuner 2, then the image is fine.
>=20
> Any idea how I can fix this problem?
>=20
> any help is very much appreciated,
>=20
> Elvis
>=20
> _________________________________________________________________
>=20
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dsubscrib=
e
> https://www.redhat.com/mailman/listinfo/video4linux-list

_________________________________________________________________

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
