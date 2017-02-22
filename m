Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39074 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755145AbdBVTwk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 14:52:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sodagudi Prasad <psodagud@codeaurora.org>
Cc: James Morse <james.morse@arm.com>, mchehab@s-opensource.com,
        linux-media@vger.kernel.org, shijie.huang@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        tiffany.lin@mediatek.com, nick@shmanahar.org, shuah@kernel.org,
        ricardo.ribalda@gmail.com
Subject: Re: <Query> Looking more details and reasons for using orig_add_limit.
Date: Wed, 22 Feb 2017 21:53:08 +0200
Message-ID: <2944633.ljab0sy3Dg@avalon>
In-Reply-To: <568205ddc2e7af6a57a71b8c5cd47d68@codeaurora.org>
References: <def87360266193184dc013a055ec3869@codeaurora.org> <58A58162.2020101@arm.com> <568205ddc2e7af6a57a71b8c5cd47d68@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prasad,

On Tuesday 21 Feb 2017 06:20:58 Sodagudi Prasad wrote:
> Hi mchehab/linux-media,
>=20
> It is not clear why KERNEL_DS was set explicitly here. In this path
> video_usercopy() gets  called  and it
> copies the =E2=80=9Cstruct v4l2_buffer=E2=80=9D struct to user space =
stack memory.
>=20
> Can you please share reasons for setting to KERNEL_DS here?

It's a bit of historical hack. To implement compat ioctl handling, we c=
opy the=20
ioctl 32-bit argument from userspace, turn it into a native 64-bit ioct=
l=20
argument, and call the native ioctl code. That code expects the argumen=
t to be=20
stored in userspace memory and uses get_user() and put_user() to access=
 it. As=20
the 64-bit argument now lives in kernel memory, my understanding is tha=
t we=20
fake things up with KERNEL_DS.

The ioctl code should be refactored to get rid of this hack.

> static long do_video_ioctl(struct file *file, unsigned int cmd, unsig=
ned
> long arg)
> {
> =E2=80=A6
> =E2=80=A6
>=20
>          if (compatible_arg)
>                  err =3D native_ioctl(file, cmd, (unsigned long)up);
>          else {
>                  mm_segment_t old_fs =3D get_fs();
>=20
>                  set_fs(KERNEL_DS);
>                  err =3D native_ioctl(file, cmd, (unsigned long)&karg=
);
>                  set_fs(old_fs);
>          }
> =E2=80=A6
> }
>=20
> On 2017-02-16 02:39, James Morse wrote:
> > Hi Prasad,
> >=20
> > On 15/02/17 21:12, Sodagudi Prasad wrote:
> >> On 2017-02-15 04:09, James Morse wrote:
> >>> On 15/02/17 05:52, Sodagudi Prasad wrote:
> >>>> that driver is calling set_fs(KERNEL_DS) and  then copy_to_user(=
) to
> >>>> user space
> >>>> memory.
> >>>=20
> >>> Don't do this, its exactly the case PAN+UAO and the code you poin=
ted
> >>> to are
> >>> designed to catch. Accessing userspace needs doing carefully, set=
ting
> >>> USER_DS
> >>> and using the put_user()/copy_to_user() accessors are the require=
d
> >>> steps.
> >>>=20
> >>> Which driver is doing this? Is it in mainline?
> >>=20
> >> Yes. It is mainline driver -
> >> drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> >>=20
> >> In some v4l2 use-case kernel panic is observed. Below part
> >> of the code has set_fs to KERNEL_DS before calling native_ioctl().=

> >>=20
> >> static long do_video_ioctl(struct file *file, unsigned int cmd,
> >> unsigned long arg)
> >> {
> >> =E2=80=A6
> >> =E2=80=A6
> >>=20
> >>         if (compatible_arg)
> >>        =20
> >>                 err =3D native_ioctl(file, cmd, (unsigned long)up)=
;
> >>        =20
> >>         else {
> >>        =20
> >>                 mm_segment_t old_fs =3D get_fs();
> >>                =20
> >>                 set_fs(KERNEL_DS);   =3D=3D=3D=3D> KERNEL_DS.
> >>                 err =3D native_ioctl(file, cmd, (unsigned long)&ka=
rg);
> >>                 set_fs(old_fs);
> >>        =20
> >>         }
> >>=20
> >> Here is the call stack which is resulting crash, because user spac=
e
> >> memory has
> >> read only permissions.
> >> [27249.920041] [<ffffff8008357890>] __arch_copy_to_user+0x110/0x18=
0
> >> [27249.920047] [<ffffff8008847c98>] video_ioctl2+0x38/0x44
> >> [27249.920054] [<ffffff8008840968>] v4l2_ioctl+0x78/0xb4
> >> [27249.920059] [<ffffff80088542d8>] do_video_ioctl+0x91c/0x1160
> >> [27249.920064] [<ffffff8008854b7c>] v4l2_compat_ioctl32+0x60/0xcc
> >> [27249.920071] [<ffffff800822553c>] compat_SyS_ioctl+0x124/0xd88
> >> [27249.920077] [<ffffff8008084e30>] el0_svc_naked+0x24/0x2
> >=20
> > It's not totally clear to me what is going on here, but some
> > observations:
> > the ioctl is trying to copy_to_user() to some read-only memory.  Th=
is
> > would
> > normally fail gracefully with -EFAULT, but because KERNEL_DS has be=
en
> > set, the
> > kernel checks this before calling the fault handler and calls die()=
 on
> > your ioctl().
> >=20
> > The ioctl code is doing this deliberately as a compat mechanism, bu=
t
> > the code
> > behind file->f_op->unlocked_ioctl() expects fs=3D=3DUSER_DS when it=
 does
> > its work.
> > That code needs to be made aware of this compat translation, or a
> > compat_ioctl
> > call provided.
> >=20
> >=20
> > Which v4l driver is this? Which ioctl is being called? Does the dri=
ver
> > using the
> > v4l framework have a compat_ioctl() call?
>=20
> Yes. Same kernel crash is seen with both video and camera use cases.
> Yes. Driver have compact_ioctl().
>=20
> > What path does this call take through v4l2_compat_ioctl32()? It loo=
ks
> > like
> > compat_ioctl will be skipped in certain cases, v4l2_compat_ioctl32(=
)
> >=20
> > has:
> >> =09if (_IOC_TYPE(cmd) =3D=3D 'V' && _IOC_NR(cmd) < BASE_VIDIOC_PRI=
VATE)
> >> =09
> >> =09=09ret =3D do_video_ioctl(file, cmd, arg);
> >> =09
> >> =09else if (vdev->fops->compat_ioctl32)
> >> =09
> >> =09=09ret =3D vdev->fops->compat_ioctl32(file, cmd, arg);
> >=20
> > Is your ioctl matched by that top if()?
>=20
> Yes.  Top if condition in true and do_video_ioctl() getting called.
>=20
> >>>> If there is permission fault for user space address the above
> >>>> condition
> >>>> is leading to kernel crash. Because orig_add_limit is having
> >>>> KERNEL_DS as set_fs
> >>>> called before copy_to_user().
> >>>>=20
> >>>> 1)    So I would like to understand that,  is that user space
> >>>> pointer leading to
> >>>> permission fault not correct(condition_1) in this scenario?
> >>>=20
> >>> The correct thing has happened here. To access user space
> >>> set_fs(USER_DS) first.
> >>> (and set it back to whatever it was afterwards).
> >>=20
> >> So, Any clean up needed to above call path similar to what was don=
e in
> >> the below
> >> commit?
> >> commit a7f61e89af73e9bf760826b20dba4e637221fcb9 - compat_ioctl: do=
n't
> >> call
> >> do_ioctl under set_fs(KERNEL_DS)
> >=20
> > That's clever. Is that code doing a conversion, or do you have a
> > compat_ioctl()
> > in your driver?
> >=20
> > It's possible that fs/compat_ioctl.c has done this work, but
> > do_video_ioctl()
> > un-does it. Someone who knows about v4l and compat-ioctls should ta=
ke a
> > look...
> >=20
> > This looks like a case of:
> >> The accidental invocation of an unlocked_ioctl handler that
> >> unexpectedly
> >> calls copy_to_user could be a severe security issue.
> >=20
> > that Jann describes in the commit message. Fixing the code behind
> > file->f_op->unlocked_ioctl() to consider compat calls from
> > do_video_ioctl() is
> > one way to solve this.
> >=20
> >=20
> >=20
> > Thanks,
> >=20
> > James
>=20
> -Thanks, Prasad

--=20
Regards,

Laurent Pinchart
