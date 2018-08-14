Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbeHNLlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:41:50 -0400
Date: Tue, 14 Aug 2018 05:55:33 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 16/34] v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
Message-ID: <20180814055533.41959406@coco.lan>
In-Reply-To: <ef84cba0-52d4-b532-8469-ff4fdc10192d@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-17-hverkuil@xs4all.nl>
        <20180813080703.4ce872c1@coco.lan>
        <ef84cba0-52d4-b532-8469-ff4fdc10192d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 10:45:57 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 13/08/18 13:07, Mauro Carvalho Chehab wrote:
> > Em Sat,  4 Aug 2018 14:45:08 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >  =20
> >> If a driver needs to find/inspect the controls set in a request then
> >> it can use these functions.
> >>
> >> E.g. to check if a required control is set in a request use this in the
> >> req_validate() implementation:
> >>
> >> 	int res =3D -EINVAL;
> >>
> >> 	hdl =3D v4l2_ctrl_request_hdl_find(req, parent_hdl);
> >> 	if (hdl) {
> >> 		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
> >> 			res =3D 0;
> >> 		v4l2_ctrl_request_hdl_put(hdl);
> >> 	}
> >> 	return res;
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ctrls.c | 25 ++++++++++++++++
> >>  include/media/v4l2-ctrls.h           | 44 +++++++++++++++++++++++++++-
> >>  2 files changed, 68 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2=
-core/v4l2-ctrls.c
> >> index 86a6ae54ccaa..2a30be824491 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> @@ -2976,6 +2976,31 @@ static const struct media_request_object_ops re=
q_ops =3D {
> >>  	.release =3D v4l2_ctrl_request_release,
> >>  };
> >> =20
> >> +struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_req=
uest *req,
> >> +					struct v4l2_ctrl_handler *parent)
> >> +{
> >> +	struct media_request_object *obj;
> >> +
> >> +	if (WARN_ON(req->state !=3D MEDIA_REQUEST_STATE_VALIDATING &&
> >> +		    req->state !=3D MEDIA_REQUEST_STATE_QUEUED))
> >> +		return NULL;
> >> +
> >> +	obj =3D media_request_object_find(req, &req_ops, parent);
> >> +	if (obj)
> >> +		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
> >> +	return NULL;
> >> +}
> >> +EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
> >> +
> >> +struct v4l2_ctrl *
> >> +v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
> >> +{
> >> +	struct v4l2_ctrl_ref *ref =3D find_ref_lock(hdl, id);
> >> +
> >> +	return (ref && ref->req =3D=3D ref) ? ref->ctrl : NULL; =20
> >=20
> > Doesn't those helper functions (including this one) be serialized? =20
>=20
> v4l2_ctrl_request_hdl_find() checks the request state to ensure this:
> it is either VALIDATING (then the req_queue_mutex is locked) or QUEUED
> and then it is under control of the driver. Of course, in that case the
> driver should make sure that it doesn't complete the request in the
> middle of calling this function. If a driver does that, then it is a driv=
er
> bug.

Please document it then, as I guess anyone that didn't worked at the
request API patchset wouldn't guess when the driver needs to take
the lock themselves.

=46rom what I'm understanding, the driver needs to take the lock only
when it is running a code that it is not called from an ioctl.
right?

Thanks,
Mauro
