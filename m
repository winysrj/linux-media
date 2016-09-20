Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41223 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752187AbcITHuw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 03:50:52 -0400
Subject: Re: [PATCH v1.1 4/5] smiapp: Use runtime PM
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
 <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160919225127.ncjux2ybgqt66axu@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E0EA42.8070108@linux.intel.com>
Date: Tue, 20 Sep 2016 10:50:26 +0300
MIME-Version: 1.0
In-Reply-To: <20160919225127.ncjux2ybgqt66axu@earth>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ipeS6KIi7xcQuibNsn294EWRUf0WArL9L"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ipeS6KIi7xcQuibNsn294EWRUf0WArL9L
Content-Type: multipart/mixed; boundary="emc3etpuOki2nmcXKKTFoLTcmXL0nF7Kj"
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
Message-ID: <57E0EA42.8070108@linux.intel.com>
Subject: Re: [PATCH v1.1 4/5] smiapp: Use runtime PM
References: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
 <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160919225127.ncjux2ybgqt66axu@earth>
In-Reply-To: <20160919225127.ncjux2ybgqt66axu@earth>

--emc3etpuOki2nmcXKKTFoLTcmXL0nF7Kj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

Thank you for the review.

On 09/20/16 01:51, Sebastian Reichel wrote:
> Hi,
>=20
> On Fri, Sep 16, 2016 at 01:53:29AM +0300, Sakari Ailus wrote:
>> [...]
>>
>> diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2=
c/smiapp/smiapp-regs.c
>> index 1e501c0..a9c7baf 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-regs.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-regs.c
>> @@ -18,6 +18,7 @@
>> =20
>>  #include <linux/delay.h>
>>  #include <linux/i2c.h>
>> +#include <linux/pm_runtime.h>
>> =20
>>  #include "smiapp.h"
>>  #include "smiapp-regs.h"
>> @@ -288,8 +289,12 @@ int smiapp_write_no_quirk(struct smiapp_sensor *s=
ensor, u32 reg, u32 val)
>>   */
>>  int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
>>  {
>> +	struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->src->sd);=

>>  	int rval;
>> =20
>> +	if (pm_runtime_suspended(&client->dev))
>> +		return 0;
>> +
>=20
> This looks racy. What if idle countdown runs out immediately after
> this check? If you can't call get_sync in this function you can
> call pm_runtime_get() before the suspend check and pm_runtime_put
> before returning from the function, so that the device keeps being
> enabled.

Good point. It was probably late when I wrote the patch. X-)

I guess I need to put pm_runtime_get_noresume() before that, and then
put_autosuspend() it later on.

>=20
> Also I would expect some error code instead of success for early
> return due to device being suspended?

That's by design.

If the sensor is off, there's no need to write anything there. The
configuration is re-applied to the sensor when it's powered on.

--=20
Sakari Ailus
sakari.ailus@linux.intel.com


--emc3etpuOki2nmcXKKTFoLTcmXL0nF7Kj--

--ipeS6KIi7xcQuibNsn294EWRUf0WArL9L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlfg6lgACgkQbUA2G24owZPm9QD/agGvmRRfSGEL1HiigBNEtZl9
OlevwmK8NAWCPz+8T1EBAIRyTUtQ9H3CMKNW8ZFYXSkmJF9leWppD87rOb/YF/A+
=TJsx
-----END PGP SIGNATURE-----

--ipeS6KIi7xcQuibNsn294EWRUf0WArL9L--
