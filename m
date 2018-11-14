Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:36299 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbeKNKVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 05:21:30 -0500
Date: Wed, 14 Nov 2018 01:20:39 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 0/7] media: i2c: small enhancements for camera sensor
 drivers
Message-ID: <20181114002039.GC19257@w540>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Mita-san,
   thanks for the patches

On Tue, Nov 13, 2018 at 01:00:47AM +0900, Akinobu Mita wrote:
> This patchset addds relatively small enhancements (log_status ioctl, event
> interface, V4L2_CID_TEST_PATTERN control, and V4L2_CID_COLORFX control) for
> mt9m111, ov2640, ov5640, ov7670, and ov772x drivers.  I have these devices
> so these patches are tested with real devices.
>

For the ov772x part:
Acked-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

> Akinobu Mita (7):
>   media: mt9m111: support log_status ioctl and event interface
>   media: mt9m111: add V4L2_CID_COLORFX control
>   media: ov2640: add V4L2_CID_TEST_PATTERN control
>   media: ov2640: support log_status ioctl and event interface
>   media: ov5640: support log_status ioctl and event interface
>   media: ov7670: support log_status ioctl and event interface
>   media: ov772x: support log_status ioctl and event interface
>
>  drivers/media/i2c/mt9m111.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  drivers/media/i2c/ov2640.c  | 21 +++++++++++++++++++--
>  drivers/media/i2c/ov5640.c  |  7 ++++++-
>  drivers/media/i2c/ov7670.c  |  6 +++++-
>  drivers/media/i2c/ov772x.c  |  7 ++++++-
>  5 files changed, 78 insertions(+), 7 deletions(-)
>
> Cc: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> --
> 2.7.4
>

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb62pXAAoJEHI0Bo8WoVY8sqoP/Az6AvxHm8J313WoEJ/3+ar4
P+nsTFxfiTQ9HJBFEeM2kjNmPTTA7KbdzV+VXXDLF2RjWHB8H8lZicDDdkeqkV9n
rUoDwvIY/F/y5kXbFPqUFNVaMtwQrUrTcmX5PezBKcubvw+W1SFVh4kFxj7hE1+Y
/vQ1h/cGKSRhkXIGSIkhbFvEpfgYwfHeUSbuB4lZeenlM8xfjoLoilXQ2doFYnLB
LaV5x41W8wk7x3OG9uwJoy6jlAFqHY3KkIzJnBPC5zNd/ogw5LCTk9YXaWvEg75B
wFKR9kK+WlMOYQ2Veg8MbcI7pbQIKFVHloA+mepk0hqxW5OnUKoPGH6MqwwpxdmC
peFupfFGw7P0PKCGJYkTvdUmE9xr1oL5snLTauvkp7VV44XNUdjSO2VRSoOmW0VB
LCAnZdHuZ5EGQHhx6wR8Cucnqdb/ccXVq3dxc9VCoYESj1HuuiF2Xiiy2D2zLzKB
JgyxA1bJ004oU0rB8j9LvMa3Uh8p3u1/beycnzpOwSFFSAJ51TiXiYzPY50SjhL0
+1AwgpCbvWHWI9gpaHkGsMLhwpxCc6vwT8eXr9JodGiKTlVyOI2X38nZ2wUOi4qB
h/C05exe+W2KMNTKGwA/if6qMgAJ86ru3Ch+9W+4ECBExkOgj0C/hih3SHxOKa6k
BdCCAcAWnL2vIdFM48QE
=W1BT
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
