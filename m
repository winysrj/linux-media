Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752601AbcISVJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:09:36 -0400
Date: Mon, 19 Sep 2016 23:09:29 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 08/17] smiapp: Merge smiapp_init() with smiapp_probe()
Message-ID: <20160919210928.hnfqrgztxvwzdiwi@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-9-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qkfysbh25peinhre"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-9-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qkfysbh25peinhre
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:22PM +0300, Sakari Ailus wrote:
> The smiapp_probe() is the sole caller of smiapp_init(). Unify the two.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--qkfysbh25peinhre
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FQIAAoJENju1/PIO/qa+lEP/1Q5bH4Bv2JYT5cNpgCUMtMt
e6zTjUyZ9u9hkxzXrHrKW92eVf3pcl5HRsVFFxagxHg5B9v7lR5GCjuVFLEE0oOJ
rIYEE277pOGT+UOxmGvV8hUpiR9mUQGmxbVrm+Ix7c5jNkMGQXIlI5RLQbgN8vi2
UQm8+pgKdmfltj0mAMA4kdAabPwNsiWv9FgnfgtDpFHjNU54jcC77hAAW7XL80Qc
lLIDYZHYOKW5bZS/wjHe3fPusMElOCjado2zl2YOZjWjR1DJ6lTHNa6bB6dxmhNj
VJ4HKbUdEuHJ4tE10bL+a0BokLXX3sgzrWJO+zX1OId+F9ZFR76uA3GbN89a4a4a
rTN+FK9npSbX6ztLS5YP3GJRxDRDOUUXCyx48SK5znunphdfMG5oURyWft25H+Nw
OpF1i2dAo5F21zemUixSh5IpETM7eJGjR4XpaESSTFqky+02r0Nm10AV+118cO15
QVXsa1MlQnDTC3kl6oaDjJpk5XDTHW5ly7LlboAoQHf/xzprJuIgMloLLCm6VCGg
hqnt57l8c5X/XIr9vZeCYIeYE4oPfTaIeSTHrop1N/H+73bHHNo599foePez32R6
MzcUMtDSUYGgvTOl8Vh1fikYiPg9ef19ed6a6VCGGnHyY+fnePXoPxXRUSqs6/Td
3cwu0tBJltCuiisZ06g0
=41xE
-----END PGP SIGNATURE-----

--qkfysbh25peinhre--
