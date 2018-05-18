Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40834 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752430AbeERPS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:18:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>,
        Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras on generic apps
Date: Fri, 18 May 2018 18:19:18 +0300
Message-ID: <2499458.KJkn9g4ItI@avalon>
In-Reply-To: <f2d8be6e6a1754afc253be816a0307f46c957b59.camel@ndufresne.ca>
References: <20180517160708.74811cfb@vento.lan> <3216261.G88TfqiCiH@avalon> <f2d8be6e6a1754afc253be816a0307f46c957b59.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Friday, 18 May 2018 17:22:47 EEST Nicolas Dufresne wrote:
> Le vendredi 18 mai 2018 =E0 11:15 +0300, Laurent Pinchart a =E9crit :
> >> I need to clarify a little bit on why we disabled libv4l2 in GStreamer,
> >> as it's not only for performance reason, there is couple of major issu=
es
> >> in the libv4l2 implementation that get's in way. Just a short
> >> list:
> >=20
> > Do you see any point in that list that couldn't be fixed in libv4l ?
>=20
> Sure, most of it is features being added into the kernel uAPI but not
> added to the emulation layer. But appart from that, libv4l will only
> offer legacy use case, we need to think how generic userspace will be
> able to access these camera, and leverage the per request controls,
> multi-stream, etc. features. This is mostly what Android Camera HAL2
> does (and it does it well), but it won't try and ensure this stays Open
> Source in any ways. I would not mind if Android Camera HAL2 leads the
> way, and a facilitator (something that does 90% of the work if you have
> a proper Open Source driver) would lead the way in getting more OSS
> drivers submitted.

There are a few issues with the Android camera HAL that make implementation=
s=20
very painful. If we were to model a camera stack on such an API, we should =
at=20
least fix those. The biggest issue in my opinion is that the HAL mandates t=
hat=20
a request captures to a specific buffer, making implementations very comple=
x,=20
and requiring memcpy() from time to time when losing race conditions. It wo=
uld=20
be much simpler to instead require capture to any buffer from a given pool.

> >>    - Crash when CREATE_BUFS is being used
>=20
> This is a side effect of CREATE_BUFS being passed-through, implementing
> emulation for this should be straightforward.
>=20
> >>    - Crash in the jpeg decoder (when frames are corrupted)
>=20
> A minimalist framing parser would detect just enough of this, and would
> fix it.
>=20
> >>    - App exporting DMABuf need to be aware of emulation, otherwise the
> >>      DMABuf exported are in the orignal format
>=20
> libv4l2 can return ENOTTY to expbufs calls in
>=20
> >>    - RW emulation only initialize the queue on first read (causing
> >>      userspace poll() to fail)
>=20
> This is not fixable, only place it would be fixed is by moving this
> emulation into VideoBuf2. That would assume someone do care about RW
> (even though it could be nicer uAPI when dealing with muxed or byte-
> stream type of data).

I personally don't care much about R/W. I have heard that the recent=20
implementation of mmap'ed buffer support in DVB showed impressive performan=
ce=20
improvements, so a R/W API isn't something I'd prioritize.

> > >    - Signature of v4l2_mmap does not match mmap() (minor)
> > >    - The colorimetry does not seem emulated when conversion
>=20
> This one is probably tricky, special is the converter plugin API is
> considered stable. Maybe just resetting everything to DEFAULT would
> work ?

I'd actually like to rework that API. The conversion code should be moved t=
o a=20
separate library that would allow its usage without a V4L2 device.

> > >    - Sub-optimal locking (at least deadlocks were fixed)
>=20
> Need more investigation really, and proper measurement.

=2D-=20
Regards,

Laurent Pinchart
