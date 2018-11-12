Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53024 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbeKMCqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 21:46:17 -0500
Message-ID: <c799ec2cf938e06a0ecbba770ed3344cd49d3af8.camel@bootlin.com>
Subject: Re: [PATCH v5 0/5] Make sure .device_run is always called in
 non-atomic context
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 12 Nov 2018 17:52:12 +0100
In-Reply-To: <2ef1f827b032d1a03f7fb010346ec7ae2ff75b7b.camel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
         <2ef1f827b032d1a03f7fb010346ec7ae2ff75b7b.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7RSt6KLX6ozvjSUcKY/1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7RSt6KLX6ozvjSUcKY/1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2018-11-11 at 18:26 -0300, Ezequiel Garcia wrote:
> On Thu, 2018-10-18 at 15:02 -0300, Ezequiel Garcia wrote:
> > This series goal is to avoid drivers from having ad-hoc code
> > to call .device_run in non-atomic context. Currently, .device_run
> > can be called via v4l2_m2m_job_finish(), not only running
> > in interrupt context, but also creating a nasty re-entrant
> > path into mem2mem drivers.
> >=20
> > The proposed solution is to add a per-device worker that is scheduled
> > by v4l2_m2m_job_finish, which replaces drivers having a threaded interr=
upt
> > or similar.
> >=20
> > This change allows v4l2_m2m_job_finish() to be called in interrupt
> > context, separating .device_run and v4l2_m2m_job_finish() contexts.
> >=20
> > It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
> > to flush or cancel the new worker, because the job_spinlock
> > synchronizes both and also because the core prevents simultaneous
> > jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
> > worker will be unable to run a new job.
> >=20
> > Patches apply on top of Request API and the Cedrus VPU
> > driver.
> >=20
> > Tested with cedrus driver using v4l2-request-test and
> > vicodec driver using gstreamer.
> >=20
> > Ezequiel Garcia (4):
> >   mem2mem: Require capture and output mutexes to match
> >   v4l2-ioctl.c: Simplify locking for m2m devices
> >   v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
> >   media: cedrus: Get rid of interrupt bottom-half
> >=20
> > Sakari Ailus (1):
> >   v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedul=
e
> >=20
> >  drivers/media/v4l2-core/v4l2-ioctl.c          | 47 +------------
> >  drivers/media/v4l2-core/v4l2-mem2mem.c        | 66 ++++++++++++-------
> >  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++------
> >  3 files changed, 51 insertions(+), 88 deletions(-)
> >=20
>=20
> Hans, Maxime:
>=20
> Any feedback for this?

I just tested the whole series with the cedrus driver and everything
looks good!

Removing the interrupt bottom-half in favor of a workqueue in the core
seems like a good way to simplify m2m driver development by avoiding
per-driver workqueues or threaded irqs.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-7RSt6KLX6ozvjSUcKY/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvpr7wACgkQ3cLmz3+f
v9E6LQf+Nwxinb6mvsxYyhzGccv/NtKTZa2C4Rx3WaQIv+FChHZIVLTNSBshT32F
/DZwKbjkcrnUWoj5Art2HSBoCZGpnJCPGOnllnQgU4fSP80C1L6shT3tvpFECmIR
OWiMLB8WrNOX4jPICdutrhliMV80z6fH3zTTJN/zrOPuRFaVdnogmvJq2oqFpxBR
OPi6NjIbsKN+La6szxE/12ppPw/huQqWrGhCxVubAbuvtg4jDVqjPJ3u2eZMYKuD
XuyIKeXEej0aNyutEc7hgpR/pyqyWmhXRK+lninrv1wVqwCbDCYAEe41dD8FRDzs
6sVkVw97NYGuq5wjtTXCRLPxrKwNkw==
=uHRn
-----END PGP SIGNATURE-----

--=-7RSt6KLX6ozvjSUcKY/1--
