Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41446 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbeKMS66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 13:58:58 -0500
Message-ID: <befdcfb6e2a39aa0da3f1197d5aab853e8bebc58.camel@bootlin.com>
Subject: Re: [PATCH v5 0/5] Make sure .device_run is always called in
 non-atomic context
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Tue, 13 Nov 2018 10:01:12 +0100
In-Reply-To: <20181018180224.3392-1-ezequiel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QlO9p02HyL6JInvI9Lhl"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-QlO9p02HyL6JInvI9Lhl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-10-18 at 15:02 -0300, Ezequiel Garcia wrote:
> This series goal is to avoid drivers from having ad-hoc code
> to call .device_run in non-atomic context. Currently, .device_run
> can be called via v4l2_m2m_job_finish(), not only running
> in interrupt context, but also creating a nasty re-entrant
> path into mem2mem drivers.
>=20
> The proposed solution is to add a per-device worker that is scheduled
> by v4l2_m2m_job_finish, which replaces drivers having a threaded interrup=
t
> or similar.
>=20
> This change allows v4l2_m2m_job_finish() to be called in interrupt
> context, separating .device_run and v4l2_m2m_job_finish() contexts.
>=20
> It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
> to flush or cancel the new worker, because the job_spinlock
> synchronizes both and also because the core prevents simultaneous
> jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
> worker will be unable to run a new job.
>=20
> Patches apply on top of Request API and the Cedrus VPU
> driver.
>=20
> Tested with cedrus driver using v4l2-request-test and
> vicodec driver using gstreamer.

For the entire series, tested with the cedrus driver:
Tested-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Ezequiel Garcia (4):
>   mem2mem: Require capture and output mutexes to match
>   v4l2-ioctl.c: Simplify locking for m2m devices
>   v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
>   media: cedrus: Get rid of interrupt bottom-half
>=20
> Sakari Ailus (1):
>   v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule
>=20
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 47 +------------
>  drivers/media/v4l2-core/v4l2-mem2mem.c        | 66 ++++++++++++-------
>  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++------
>  3 files changed, 51 insertions(+), 88 deletions(-)
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-QlO9p02HyL6JInvI9Lhl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvqktgACgkQ3cLmz3+f
v9F4iAf9HJlonJFwdJPCRpGTNT6Ta8UTdtIgBdIxF/hUARqW6ezvelFzQgu+X90y
9sRvLdmj/6rszCy6XCrKlIO1C24WE9UjspmGdEl/Tp9pDMtLbpX52/YcGMoe7VNB
7OEiZlu6Q70HdEzZndoEOeV9OkGz5ncoDY0d4w0AZYytJYka19xg+46l+tiI7gMv
xBK3XBg1m9BnEPZf+cPbJfzU2/Rfx6VTh3XyWnsOPmMs/pFwzNAIX7xkOlgoJQ01
G/ccdx3GXDOVibcwJNXfJNPxMEXV392geMswiVQ+fjTjhZTeZTrl2KQkLzFtIQYS
Z40lXSCmk2ieuuv8YMqwAr0FJT+aNA==
=H+0T
-----END PGP SIGNATURE-----

--=-QlO9p02HyL6JInvI9Lhl--
