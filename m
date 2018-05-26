Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031606AbeEZL2Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 07:28:24 -0400
Date: Sat, 26 May 2018 08:28:18 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180526082818.70a369b5@vento.lan>
In-Reply-To: <1657947.LKPPaiEoOV@avalon>
References: <10831984.07PNLvckhh@avalon>
        <20180525201027.1d5c82eb@vento.lan>
        <4867226.Y05TeWaCcJ@avalon>
        <1657947.LKPPaiEoOV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 26 May 2018 03:24:00 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
>=20
> On Saturday, 26 May 2018 02:39:16 EEST Laurent Pinchart wrote:
> > On Saturday, 26 May 2018 02:10:27 EEST Mauro Carvalho Chehab wrote: =20
> > > Em Sun, 20 May 2018 15:10:50 +0300 Laurent Pinchart escreveu: =20
> > >> Hi Mauro,
> > >>=20
> > >> The following changes since commit
> > >>=20
> > >> 8ed8bba70b4355b1ba029b151ade84475dd12991:
> > >>   media: imx274: remove non-indexed pointers from mode_table (2018-0=
5-17
> > >>=20
> > >> 06:22:08 -0400)
> > >>=20
> > >> are available in the Git repository at:
> > >>   git://linuxtv.org/pinchartl/media.git v4l2/vsp1/next
> > >>=20
> > >> for you to fetch changes up to 429f256501652c90a4ed82f2416618f82a77d=
37c:
> > >>   media: vsp1: Move video configuration to a cached dlb (2018-05-20
> > >>   09:46:51 +0300)
> > >>=20
> > >> The branch passes the VSP and DU test suites, both on its own and wh=
en
> > >> merged with the drm-next branch. =20
> > >=20
> > > This series added a new warning:
> > >=20
> > > drivers/media/platform/vsp1/vsp1_dl.c:69: warning: Function parameter=
 or
> > > member 'refcnt' not described in 'vsp1_dl_body' =20
> >=20
> > We'll fix that. Kieran, as you authored the code, would you like to giv=
e it
> > a go ?
> >  =20
> > > To the already existing one:
> > >=20
> > > drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx=
()
> > > error: we previously assumed 'pipe->brx' could be null (see line 244)=
 =20
> >=20
> > That's still on my todo list. I tried to give it a go but received plen=
ty of
> > SQL errors. How do you run smatch ? =20
>=20
> Nevermind, I found out what was wrong (had to specify the data directory=
=20
> manually).
>=20
> I've reproduced the issue and created a minimal test case.
>=20
>  1. struct vsp1_pipeline;
>  2.  =20
>  3. struct vsp1_entity {
>  4.         struct vsp1_pipeline *pipe;
>  5.         struct vsp1_entity *sink;
>  6.         unsigned int source_pad;
>  7. };
>  8.=20
>  9. struct vsp1_pipeline {
> 10.         struct vsp1_entity *brx;
> 11. };
> 12.=20
> 13. struct vsp1_brx {
> 14.         struct vsp1_entity entity;
> 15. };
> 16.=20
> 17. struct vsp1_device {
> 18.         struct vsp1_brx *bru;
> 19.         struct vsp1_brx *brs;
> 20. };
> 21.=20
> 22. unsigned int frob(struct vsp1_device *vsp1, struct vsp1_pipeline *pip=
e)
> 23. {
> 24.         struct vsp1_entity *brx;
> 25.=20
> 26.         if (pipe->brx)
> 27.                 brx =3D pipe->brx;
> 28.         else if (!vsp1->bru->entity.pipe)
> 29.                 brx =3D &vsp1->bru->entity;
> 30.         else
> 31.                 brx =3D &vsp1->brs->entity;
> 32.=20
> 33.         if (brx !=3D pipe->brx)
> 34.                 pipe->brx =3D brx;
> 35.=20
> 36.         return pipe->brx->source_pad;
> 37. }
>=20
> The reason why smatch complains is that it has no guarantee that vsp1->br=
s is=20
> not NULL. It's quite tricky:
>=20
> - On line 26, smatch assumes that pipe->brx can be NULL
> - On line 27, brx is assigned a non-NULL value (as pipe->brx is not NULL =
due=20
> to line 26)
> - On line 28, smatch assumes that vsp1->bru is not NULL
> - On line 29, brx is assigned a non-NULL value (as vsp1->bru is not NULL =
due=20
> to line 28)
> - On line 31, brx is assigned a possibly NULL value (as there's no inform=
ation=20
> regarding vsp1->brs)
> - On line 34, pipe->brx is not assigned a non-NULL value if brx is NULL
> - On line 36 pipe->brx is dereferenced
>=20
> The problem comes from the fact that smatch assumes that vsp1->brs isn't =
NULL.=20
> Adding a "(void)vsp1->brs->entity;" statement on line 25 makes the warnin=
g=20
> disappear.
>=20
> So how do we know that vsp1->brs isn't NULL in the original code ?
>=20
>         if (pipe->num_inputs > 2)
>                 brx =3D &vsp1->bru->entity;
>         else if (pipe->brx && !drm_pipe->force_brx_release)
>                 brx =3D pipe->brx;
>         else if (!vsp1->bru->entity.pipe)
>                 brx =3D &vsp1->bru->entity;
>         else
>                 brx =3D &vsp1->brs->entity;
>=20
> A VSP1 instance can have no brs, so in general vsp1->brs can be NULL. How=
ever,=20
> when that's the case, the following conditions are fulfilled.
>=20
> - drm_pipe->force_brx_release will be false
> - either pipe->brx will be non-NULL, or vsp1->bru->entity.pipe will be NU=
LL
>=20
> The fourth branch should thus never be taken.

I don't think that adding a forth branch there would solve.

The thing is that Smatch knows that pipe->brx can be NULL, as the function
explicly checks if pipe->brx !=3D NULL.

When Smatch handles this if:

	if (brx !=3D pipe->brx) {

It wrongly assumes that this could be false if pipe->brx is NULL.
I don't know why, as Smatch should know that brx can't be NULL.

On such case, the next code to be executed would be:

	format.pad =3D pipe->brx->source_pad;

With would be trying to de-ref a NULL pointer.

There are two ways to fix it:

1) with my patch.

It is based to the fact that, if pipe->brx is null, then brx won't be
NULL. So, the logic that "Switch BRx if needed." will always be called:

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platfor=
m/vsp1/vsp1_drm.c
index 095dc48aa25a..cb6b60843400 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_devic=
e *vsp1,
 		brx =3D &vsp1->brs->entity;
=20
 	/* Switch BRx if needed. */
-	if (brx !=3D pipe->brx) {
+	if (brx !=3D pipe->brx || !pipe->brx) {
 		struct vsp1_entity *released_brx =3D NULL;
=20
 		/* Release our BRx if we have one. */

The code with switches BRx ensures that pipe->brx won't be null, as
in the end, it sets:

	pipe->brx =3D brx;

And brx can't be NULL.

=46rom my PoV, this patch has the advantage of explicitly showing
to humans that the code inside the if statement will always be
executed when pipe->brx is NULL.

-

Another way to solve would be to explicitly check if pipe->brx is still
null before de-referencing:

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platfor=
m/vsp1/vsp1_drm.c
index edb35a5c57ea..9fe063d6df31 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -327,6 +327,9 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_devic=
e *vsp1,
 		list_add_tail(&pipe->brx->list_pipe, &pipe->entities);
 	}
=20
+	if (!pipe->brx)
+		return -EINVAL;
+
 	/*
 	 * Configure the format on the BRx source and verify that it matches the
 	 * requested format. We don't set the media bus code as it is configured

The right fix would be, instead, to fix Smatch to handle the:

	if (brx !=3D pipe->brx)

for the cases where one var can be NULL while the other can't be NULL,
but, as I said before, I suspect that this can be a way more complex.

Thanks,
Mauro
