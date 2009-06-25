Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <COL103-W2753C79E5C866460426A1888340@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>, <hverkuil@xs4all.nl>
Date: Thu, 25 Jun 2009 10:34:56 -0400
In-Reply-To: <829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	<829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: RE: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick -
 what 	am I doing wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>


Y'all are very kind to help - thank you.  I am indeed running Ubuntu Hardy =
(8.04.2 LTS)=2C kernel on a quad-core Q9550 box.  I'll be happy to provide =
any other system details that may assist.  "uname -a" returns:

Linux spurgeon 2.6.24-24-server #1 SMP Wed Apr 15 16:36:01 UTC 2009 i686 GN=
U/Linux





> Date: Thu=2C 25 Jun 2009 10:00:05 -0400
> Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick -=
 what 	am I doing wrong?
> From: dheitmueller@kernellabs.com
> To: hverkuil@xs4all.nl
> CC: g_adams27@hotmail.com=3B linux-media@vger.kernel.org=3B video4linux-l=
ist@redhat.com
>=20
> On Thu=2C Jun 25=2C 2009 at 9:43 AM=2C Hans Verkuil<hverkuil@xs4all.nl> w=
rote:
> > Hmm=2C I have Hardy on my laptop at work so I can test this tomorrow wi=
th my
> > USB stick. It's a Hauppauge HVR<something>=2C but it does have a tvp515=
0. So
> > it should be close enough.
> >
> > Regards=2C
> >
> >       Hans
>=20
> Hans=2C
>=20
> Oh thank goodness.  I was really hoping you would volunteer since you
> are clearly the best candidate for debugging subdev issues.  It took
> me two days to debug my last issue with v4l2_subdev registration and
> it required me to recompile the distro's kernel from source to debug
> the i2c stack.
>=20
> If you've got an em28xx device with the tvp5150=2C then it's probably an
> HVR-950=2C which is almost identical to the Pinnacle 800e.
>=20
> Cheers=2C
>=20
> Devin
>=20
> --=20
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

_________________________________________________________________
Windows Live=99: Keep your life in sync.=20
http://windowslive.com/explore?ocid=3DTXT_TAGLM_WL_BR_life_in_synch_062009=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
