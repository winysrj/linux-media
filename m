Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40553 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdBWA0R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 19:26:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>,
        James Morse <james.morse@arm.com>, linux-media@vger.kernel.org,
        shijie.huang@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        mark.rutland@arm.com, akpm@linux-foundation.org,
        sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, tiffany.lin@mediatek.com,
        nick@shmanahar.org, shuah@kernel.org, ricardo.ribalda@gmail.com
Subject: Re: <Query> Looking more details and reasons for using orig_add_limit.
Date: Thu, 23 Feb 2017 02:25:53 +0200
Message-ID: <1721361.FT1A3EpsKm@avalon>
In-Reply-To: <20170222172541.49b7cbb1@vento.lan>
References: <def87360266193184dc013a055ec3869@codeaurora.org> <2944633.ljab0sy3Dg@avalon> <20170222172541.49b7cbb1@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 22 Feb 2017 17:25:41 Mauro Carvalho Chehab wrote:
> Em Wed, 22 Feb 2017 21:53:08 +0200 Laurent Pinchart escreveu:
> > On Tuesday 21 Feb 2017 06:20:58 Sodagudi Prasad wrote:
> >> Hi mchehab/linux-media,
> >>=20
> >> It is not clear why KERNEL_DS was set explicitly here. In this pat=
h
> >> video_usercopy() gets  called  and it
> >> copies the =E2=80=9Cstruct v4l2_buffer=E2=80=9D struct to user spa=
ce stack memory.
> >>=20
> >> Can you please share reasons for setting to KERNEL_DS here?
> >=20
> > It's a bit of historical hack. To implement compat ioctl handling, =
we copy
> > the ioctl 32-bit argument from userspace, turn it into a native 64-=
bit
> > ioctl argument, and call the native ioctl code. That code expects t=
he
> > argument to be stored in userspace memory and uses get_user() and
> > put_user() to access it. As the 64-bit argument now lives in kernel=

> > memory, my understanding is that we fake things up with KERNEL_DS.
>=20
> Precisely. Actually, if I remember well, this was needed to pass poin=
ter
> arguments from 32 bits userspace to 64 bits kernelspace. There are a =
lot of
> V4L2 ioctls that pass structures with pointers on it. Setting DS caus=
e
> those pointers to do the right thing, but yeah, it is hackish.

We should restructure the core ioctl code to decouple copy from/to user=
 and=20
ioctl execution (this might just be a matter of exporting a currently s=
tatic=20
function), and change the compat code to perform the copy/from to user=20=

directly when converting between 32-bit and 64-bit structures (dropping=
 all=20
the alloc in userspace hacks) and call the ioctl execution handler. Tha=
t will=20
fix the problem. Any volunteer ? :-)

> This used to work fine on x86_64 (when such code was written e. g. Ke=
rnel
> 2.6.1x). I never tested myself on ARM64, but I guess it used to work,=
 as we
> received some patches fixing support for some ioctl compat code due t=
o
> x86_64/arm64 differences in the past.
>=20
> On what Kernel version it started to cause troubles? 4.9? If so, then=

> maybe the breakage is a side effect of VM stack changes.
>=20
> > The ioctl code should be refactored to get rid of this hack.
>=20
> Agreed.

--=20
Regards,

Laurent Pinchart
