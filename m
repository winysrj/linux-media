Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732298AbeHIRoz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 13:44:55 -0400
Date: Thu, 9 Aug 2018 12:19:20 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        698668@bugs.debian.org, linux-media <linux-media@vger.kernel.org>,
        Johannes Stezenbach <js@linuxtv.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Marcus Metzler <mocm@mocm.de>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] Documentation/media: uapi: Explicitly say there are no
 Invariant Sections
Message-ID: <20180809121920.60d146bf@coco.lan>
In-Reply-To: <20180803144153.GA18030@decadent.org.uk>
References: <20180803144153.GA18030@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Aug 2018 15:41:53 +0100
Ben Hutchings <ben@decadent.org.uk> escreveu:

> The GNU Free Documentation License allows for a work to specify
> Invariant Sections that are not allowed to be modified.  (Debian
> considers that this makes such works non-free.)
>=20
> The Linux Media Infrastructure userspace API documentation does not
> specify any such sections, but it also doesn't say there are none (as
> is recommended by the license text).  Make it explicit that there are
> none.
>=20
> References: https://bugs.debian.org/698668
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

=46rom my side:

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

(I'm waiting for more SoBs before merging this)

I pinged some developers that don't use to listen to the media ML
as often as they used to do, and to the sub-maintainers, via the
sub-mainainers ML, and got some SoBs. Let me add them to this thread:

Gerd:

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Hans:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Sylwester:

Signed-off-by: Sylwester Nawrocki <snawrocki@kernel.org>

Johannes:

"I think I didn't contribute to that documentation?
 Anyway, just in case: I agree with the change to
 forbid adding invariant sections."

Signed-off-by: Johannes Stezenbach <js@linuxtv.org>

Ralph:

"I also do not think there is anything left in there which I contributed.
 The original documentation up to 2002 probably is copyright of Convergence.

 But I agree with the change to forbid adding invariant sections regarding
 anything in that documentation that might be my copyright."

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>

Markus:

"Ralph> I also do not think there is anything left in there which I
 Ralph> contributed.  The original documentation up to 2002
 Ralph> probably is copyright of Convergence. =20
 The same is true for me.

 I also agree with the change to forbid adding invariant sections
 regarding anything in that documentation that might be my copyright."

Signed-off-by: Marcus Metzler <mocm@metzlerbros.de>


> ---
>  Documentation/media/media_uapi.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/med=
ia_uapi.rst
> index 28eb35a1f965..5198ff24a094 100644
> --- a/Documentation/media/media_uapi.rst
> +++ b/Documentation/media/media_uapi.rst
> @@ -10,9 +10,9 @@ Linux Media Infrastructure userspace API
> =20
>  Permission is granted to copy, distribute and/or modify this document
>  under the terms of the GNU Free Documentation License, Version 1.1 or
> -any later version published by the Free Software Foundation. A copy of
> -the license is included in the chapter entitled "GNU Free Documentation
> -License".
> +any later version published by the Free Software Foundation, with no
> +Invariant Sections. A copy of the license is included in the chapter
> +entitled "GNU Free Documentation License".
> =20
>  .. only:: html
> =20



Thanks,
Mauro
