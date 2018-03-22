Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:43990 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbeCVQgX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 12:36:23 -0400
Received: by mail-qt0-f181.google.com with SMTP id s48so9574357qtb.10
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 09:36:23 -0700 (PDT)
Message-ID: <1521736580.18466.3.camel@ndufresne.ca>
Subject: Re: [RFC] Request API
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Mar 2018 12:36:20 -0400
In-Reply-To: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-xcTe+7fqTQZ5zjoqu26Y"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xcTe+7fqTQZ5zjoqu26Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 22 mars 2018 =C3=A0 15:18 +0100, Hans Verkuil a =C3=A9crit :
> RFC Request API
> ---------------
>=20
> This document proposes the public API for handling requests.
>=20
> There has been some confusion about how to do this, so this summarizes th=
e
> current approach based on conversations with the various stakeholders tod=
ay
> (Sakari, Alexandre Courbot, Tomasz Figa and myself).
>=20
> The goal is to finalize this so the Request API patch series work can
> continue.
>=20
> 1) Additions to the media API
>=20
>    Allocate an empty request object:
>=20
>    #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)

I see this is MEDIA_IOC namespace, I thought that there was an opening
for m2m (codec) to not have to expose a media node. Is this still the
case ?

>=20
>    This will return a file descriptor representing the request or an erro=
r
>    if it can't allocate the request.
>=20
>    If the pointer argument is NULL, then this will just return 0 (if this=
 ioctl
>    is implemented) or -ENOTTY otherwise. This can be used to test whether=
 this
>    ioctl is supported or not without actually having to allocate a reques=
t.
>=20
> 2) Operations on the request fd
>=20
>    You can queue (aka submit) or reinit a request by calling these ioctls=
 on the request fd:
>=20
>    #define MEDIA_REQUEST_IOC_QUEUE   _IO('|',  128)
>    #define MEDIA_REQUEST_IOC_REINIT  _IO('|',  129)
>=20
>    Note: the original proposal from Alexandre used IOC_SUBMIT instead of
>    IOC_QUEUE. I have a slight preference for QUEUE since that implies tha=
t the
>    request end up in a queue of requests. That's less obvious with SUBMIT=
. I
>    have no strong opinion on this, though.
>=20
>    With REINIT you reset the state of the request as if you had just allo=
cated
>    it. You cannot REINIT a request if the request is queued but not yet c=
ompleted.
>    It will return -EBUSY in that case.
>=20
>    Calling QUEUE if the request is already queued or completed will retur=
n -EBUSY
>    as well. Or would -EPERM be better? I'm open to suggestions. Either er=
ror code
>    will work, I think.
>=20
>    You can poll the request fd to wait for it to complete. A request is c=
omplete
>    if all the associated buffers are available for dequeuing and all the =
associated
>    controls (such as controls containing e.g. statistics) are updated wit=
h their
>    final values.
>=20
>    To free a request you close the request fd. Note that it may still be =
in
>    use internally, so this has to be refcounted.
>=20
>    Requests only contain the changes since the previously queued request =
or
>    since the current hardware state if no other requests are queued.
>=20
> 3) To associate a v4l2 buffer with a request the 'reserved' field in stru=
ct
>    v4l2_buffer is used to store the request fd. Buffers won't be 'prepare=
d'
>    until the request is queued since the request may contain information =
that
>    is needed to prepare the buffer.
>=20
>    Queuing a buffer without a request after a buffer with a request is eq=
uivalent
>    to queuing a request containing just that buffer and nothing else. I.e=
. it will
>    just use whatever values the hardware has at the time of processing.
>=20
> 4) To associate v4l2 controls with a request we take the first of the
>    'reserved[2]' array elements in struct v4l2_ext_controls and use it to=
 store
>    the request fd.
>=20
>    When querying a control value from a request it will return the newest
>    value in the list of pending requests, or the current hardware value i=
f
>    is not set in any of the pending requests.
>=20
>    Setting controls without specifying a request fd will just act like it=
 does
>    today: the hardware is immediately updated. This can cause race condit=
ions
>    if the same control is also specified in a queued request: it is not d=
efined
>    which will be set first. It is therefor not a good idea to set the sam=
e
>    control directly as well as set it as part of a request.
>=20
> Notes:
>=20
> - Earlier versions of this API had a TRY command as well to validate the
>   request. I'm not sure that is useful so I dropped it, but it can easily
>   be added if there is a good use-case for it. Traditionally within V4L t=
he
>   TRY ioctl will also update wrong values to something that works, but th=
at
>   is not the intention here as far as I understand it. So the validation
>   step can also be done when the request is queued and, if it fails, it w=
ill
>   just return an error.

I think it's worth to understand that this would mimic DRM Atomic
interface. The reason atomic operation can be tried like this is
because it's not possible to generically represent all the constraints.
So this would only be useful we we do have this issue.

>=20
> - If due to performance reasons we will have to allocate/queue/reinit mul=
tiple
>   requests with a single ioctl, then we will have to add new ioctls to th=
e
>   media device. At this moment in time it is not clear that this is reall=
y
>   needed and it certainly isn't needed for the stateless codec support th=
at
>   we are looking at now.
>=20
> Regards,
>=20
> 	Hans
--=-xcTe+7fqTQZ5zjoqu26Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWrPbhAAKCRBxUwItrAao
HACeAKChtHYMxj5pryhVlmyktZo+8KTZ2ACgm6H5NT6Y1xfXw3UguAgLJHuCb/s=
=WYsK
-----END PGP SIGNATURE-----

--=-xcTe+7fqTQZ5zjoqu26Y--
