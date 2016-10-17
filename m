Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55207 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbcJQNqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 09:46:36 -0400
Message-ID: <1476711990.4684.75.camel@ndufresne.ca>
Subject: Re: V4L2_DEC_CMD_STOP and last_buffer_dequeued
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Wu-Cheng Li =?UTF-8?Q?=28=E6=9D=8E=E5=8B=99=E8=AA=A0=29?=
        <wuchengli@google.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        pawel@osciak.com, Tiffany Lin <tiffany.lin@mediatek.com>
Date: Mon, 17 Oct 2016 09:46:30 -0400
In-Reply-To: <CAOMLVLhM006pYiP7xEmZoVFzwV4Zzw25wS1e1EPDDLXps873Mw@mail.gmail.com>
References: <CAOMLVLj9zwMCOCRawKZKDDtLkwHUN3VpLhpy2Qovn7Bv1X5SgA@mail.gmail.com>
         <1476469229.4684.70.camel@gmail.com>
         <CAOMLVLhM006pYiP7xEmZoVFzwV4Zzw25wS1e1EPDDLXps873Mw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-cLU8MkXEGKAPSA0u3NFw"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-cLU8MkXEGKAPSA0u3NFw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le samedi 15 octobre 2016 =C3=A0 08:16 +0800, Wu-Cheng Li (=E6=9D=8E=E5=8B=
=99=E8=AA=A0) a =C3=A9crit=C2=A0:
> last_buffer_dequeued is only cleared to false when CAPTURE queue is
> STREAMOFF (#1). Queuing a header to OUTPUT queue won't clear
> last_buffer_dequeued of CAPTURE queue. It looks to me that v4l2 core
> needs to intercept CMD_START and clear last_buffer_dequeued. What do
> you think?
>=20
> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-co=
re.c#L1951

That sounds reasonable, assuming it does not break drivers.

> >
> >
> > Note that for many a flush is the action of getting rid of the pending
> > images and achieve by using STREAMOFF. While the effect of CMD_STOP is
> > to signal the decoder that no more encoded image will be queued, hence
> > remaining images should be delivered to userspace. They will
> > differentiate as a flush operation vs as drain operation. This is no
> > rocket science of course.
>=20
> I see. What I want is drain operation. In Chromium terms, CMD_STOP
> maps to flush and STREAMOFF maps to reset.

Yes, that's the reason I was mentioning. This was a great source of
confusion during a workshop with some Google/Chromium folks.

A question on top of this, what are the use cases for you to drain
without flushing afteward ? Is it really needed ?

regards,
Nicolas
--=-cLU8MkXEGKAPSA0u3NFw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlgE1jYACgkQcVMCLawGqBxezwCfTFKs3qubcbEiZRxHmPNURfQh
5XEAmgIjco1HtDBgyzaNAbL7pm5jIdHq
=PenQ
-----END PGP SIGNATURE-----

--=-cLU8MkXEGKAPSA0u3NFw--

