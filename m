Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35303 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752838AbdBRKya (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Feb 2017 05:54:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shaobo <shaobo@cs.utah.edu>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com,
        ricardo.ribalda@gmail.com
Subject: Re: Dead code in v4l2-mem2mem.c?
Date: Sat, 18 Feb 2017 12:53:43 +0200
Message-ID: <2249581.t3xTjk4llj@avalon>
In-Reply-To: <00a901d2894d$95c553b0$c14ffb10$@cs.utah.edu>
References: <002201d288a9$93dd7360$bb985a20$@cs.utah.edu> <5573207.UYLCxH4UDO@avalon> <00a901d2894d$95c553b0$c14ffb10$@cs.utah.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaobo,

On Friday 17 Feb 2017 11:42:25 Shaobo wrote:
> Hi Laurent,
>=20
> Thanks a lot for your reply.
>=20
> I would like to also point out the inconsistency of using `v4l2_m2m_g=
et_vq`
> inside drivers/media/v4l2-core/v4l2-mem2mem.c and inside other files.=
 It
> appears to me almost all call sites of `v4l2_m2m_get_vq` in
> drivers/media/v4l2-core/v4l2-mem2mem.c does not have NULL check after=
wards
> while in other files (e.g., drivers/media/platform/mx2_emmaprp.c) the=
y do. I
> was wondering if there is special assumption on this function in mem2=
mem.c.

I don't see any case where the function could reasonably be called with=
 a NULL=20
context other than a severe driver bug. This being said, we need to aud=
it the=20
callers to make sure that's really the case. Would you like to do so an=
d=20
submit a patch ? :-)

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: 2017=E5=B9=B42=E6=9C=8817=E6=97=A5 3:26
> To: Shaobo <shaobo@cs.utah.edu>
> Cc: linux-media@vger.kernel.org; mchehab@kernel.org; hverkuil@xs4all.=
nl;
> sakari.ailus@linux.intel.com; ricardo.ribalda@gmail.com
> Subject: Re: Dead code in v4l2-mem2mem.c?
>=20
> Hi Shaobo,
>=20
> First of all, could you please make sure you send future mails to the=
 linux-
> media mailing list in plain text only (no HTML) ? The mailing list se=
rver
> rejects HTML e-mails.
>=20
> On Thursday 16 Feb 2017 16:08:25 Shaobo wrote:
> > Hi there,
> >=20
> > My name is Shaobo He and I am a graduate student at University of
> > Utah. I am applying a static analysis tool to the Linux device
> > drivers, looking for NULL pointer dereference and accidentally foun=
d a
> > plausible dead code location in v4l2-mem2mem.c due to undefined beh=
avior.
> >=20
> > The following is the problematic code segment,
> >=20
> > static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx=

> > *m2m_ctx,
> >=20
> > =09=09=09=09=09=09  enum v4l2_buf_type type)
> >=20
> > {
> >=20
> > =09if (V4L2_TYPE_IS_OUTPUT(type))
> > =09
> > =09=09return &m2m_ctx->out_q_ctx;
> > =09
> > =09else
> > =09
> > =09=09return &m2m_ctx->cap_q_ctx;
> >=20
> > }
> >=20
> > struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> >=20
> > =09=09=09=09    enum v4l2_buf_type type)
> >=20
> > {
> >=20
> > =09struct v4l2_m2m_queue_ctx *q_ctx;
> > =09
> > =09q_ctx =3D get_queue_ctx(m2m_ctx, type);
> > =09if (!q_ctx)
> > =09
> > =09=09return NULL;
> > =09
> > =09return &q_ctx->q;
> >=20
> > }
> >=20
> > `get_queue_ctx` returns a pointer value that is an addition of the
> > base pointer address (`m2m_ctx`) to a non-zero offset. The followin=
g
> > is the definition of struct v4l2_m2m_ctx,
> >=20
> > struct v4l2_m2m_ctx {
> >=20
> > =09/* optional cap/out vb2 queues lock */
> > =09struct mutex=09=09=09*q_lock;
> > =09
> > =09/* internal use only */
> > =09struct v4l2_m2m_dev=09=09*m2m_dev;
> > =09
> > =09struct v4l2_m2m_queue_ctx=09cap_q_ctx;
> > =09
> > =09struct v4l2_m2m_queue_ctx=09out_q_ctx;
> > =09
> > =09/* For device job queue */
> > =09struct list_head=09=09queue;
> > =09unsigned long=09=09=09job_flags;
> > =09wait_queue_head_t=09=09finished;
> > =09
> > =09void=09=09=09=09*priv;
> >=20
> > };
> >=20
> > There is a NULL test in a caller of `get_queue_ctx` (line 85), whic=
h
> > appears problematic to me. I'm not sure if it is defined or feasibl=
e
> > under the context of Linux kernel. This blog
> > (https://wdtz.org/undefined-behavior-in-binutils-causes-segfault.ht=
ml)
> > suggests that the NULL check can be optimized away because the only=

> > case that the return value can be NULL triggers pointer overflow,
> > which is undefined.
> >=20
> > Please let me know if it makes sense or not. Thanks for your time a=
nd
> > I am looking forward to your reply.
>=20
> The NULL check is indeed wrong. I believe that the m2m_ctx argument p=
assed
> to the v4l2_m2m_get_vq() function should never be NULL. We will howev=
er need
> to audit drivers to make sure that's the case. The NULL check could t=
hen be
> removed. Alternatively we could check m2m_ctx above the get_queue_ctx=
()
> call, which wouldn't require auditing drivers. It's a safe option, bu=
t
> would likely result in an unneeded NULL check.
>=20
> --
> Regards,
>=20
> Laurent Pinchart

--=20
Regards,

Laurent Pinchart
