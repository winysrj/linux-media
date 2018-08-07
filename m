Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52160 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbeHGLLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 07:11:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nadav Amit <namit@vmware.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: fix uvc_alloc_entity() allocation alignment
Date: Tue, 07 Aug 2018 11:59:01 +0300
Message-ID: <3561796.imRZE4xQI7@avalon>
In-Reply-To: <0B044CD5-B4F5-4614-B97A-E02E5C1E8A17@vmware.com>
References: <20180604134713.101064-1-namit@vmware.com> <15813968.YrTFj7ZbY9@avalon> <0B044CD5-B4F5-4614-B97A-E02E5C1E8A17@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nadav,

On Tuesday, 7 August 2018 03:58:05 EEST Nadav Amit wrote:
> at 4:58 PM, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > On Monday, 4 June 2018 16:47:13 EEST Nadav Amit wrote:
> >=20
> >> The use of ALIGN() in uvc_alloc_entity() is incorrect, since the size =
of
> >> (entity->pads) is not a power of two. As a stop-gap, until a better
> >> solution is adapted, use roundup() instead.
> >>=20
> >> Found by a static assertion. Compile-tested only.
> >>=20
> >> Fixes: 4ffc2d89f38a ("uvcvideo: Register subdevices for each entity")
> >>=20
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >>=20
> >> Signed-off-by: Nadav Amit <namit@vmware.com>
> >> ---
> >> drivers/media/usb/uvc/uvc_driver.c | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >> b/drivers/media/usb/uvc/uvc_driver.c index 2469b49b2b30..6b989d41c034
> >> 100644
> >> --- a/drivers/media/usb/uvc/uvc_driver.c
> >> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >> @@ -909,7 +909,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 typ=
e,
> >> u8 id,
> >>  	unsigned int size;
> >> 	unsigned int i;
> >>=20
> >> -	extra_size =3D ALIGN(extra_size, sizeof(*entity->pads));
> >> +	extra_size =3D roundup(extra_size, sizeof(*entity->pads));
> >> 	num_inputs =3D (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
> >> 	size =3D sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_p=
ads
> >> 	     + num_inputs;
> >=20
> > The purpose of this alignment is to make sure that entity->pads will be=
=20
> > properly aligned. In theory the size of uvc_entity should be taken into=
=20
> > account too, but the structure contains pointers, so its size should
> > already be properly aligned. This patch thus looks good to me. What
> > made you say it's a stop-gap measure ?
>=20
>=20
> Thanks. It=E2=80=99s been a while. Anyhow, I don=E2=80=99t know how =E2=
=80=9Chot=E2=80=9D this code is, but
> roundup uses a div operations, so if it is =E2=80=9Chot=E2=80=9D you may =
want a different
> way to align with lower overhead.
>=20
> I presume it is not=E2=80=A6

You're right, it isn't. I'll include this patch in my next pull request for=
=20
v4.20.

=2D-=20
Regards,

Laurent Pinchart
