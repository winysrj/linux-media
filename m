Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:12193 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdF0FrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 01:47:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] media: omap3isp: handle NULL return of omap3isp_video_format_info() in ccdc_is_shiftable().
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20170626201253.GU12407@valkosipuli.retiisi.org.uk>
Date: Tue, 27 Jun 2017 07:46:51 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, s-anna@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <87FCA101-D678-45E9-BD68-25819B9EF443@goldelico.com>
References: <a601fdb6d224f2e4f1a3c1249ebf8438f4b8b5ce.1498499658.git.hns@goldelico.com> <20170626201253.GU12407@valkosipuli.retiisi.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Am 26.06.2017 um 22:12 schrieb Sakari Ailus <sakari.ailus@iki.fi>:
>=20
> Hi Nikolaus,
>=20
> On Mon, Jun 26, 2017 at 07:54:19PM +0200, H. Nikolaus Schaller wrote:
>> If a camera module driver specifies a format that is not
>> supported by omap3isp this ends in a NULL pointer
>> dereference instead of a simple fail.
>=20
> Has this happened in practice?

Yes. I wouldn't have noticed it otherwise.

It happens with a new ov965x driver just submitted for review.
It seems to provide some format that the omap3isp does not understand.

I can send you a console stack log if needed.

> If it does, it is probably a driver bug ---
> the formats on its pads should be recognised by the driver.

>=20
> WARN_ON() around the condition would be good to avoid silently =
ignoring such
> issues.
>=20
> I wonder what Laurent thinks.
>=20
>>=20
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> drivers/media/platform/omap3isp/ispccdc.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>=20
>> diff --git a/drivers/media/platform/omap3isp/ispccdc.c =
b/drivers/media/platform/omap3isp/ispccdc.c
>> index 2fb755f20a6b..dcf16ee7c612 100644
>> --- a/drivers/media/platform/omap3isp/ispccdc.c
>> +++ b/drivers/media/platform/omap3isp/ispccdc.c
>> @@ -2397,6 +2397,9 @@ static bool ccdc_is_shiftable(u32 in, u32 out, =
unsigned int additional_shift)
>> 	in_info =3D omap3isp_video_format_info(in);
>> 	out_info =3D omap3isp_video_format_info(out);
>>=20
>> +	if (!in_info || !out_info)
>> +		return false;
>> +
>> 	if ((in_info->flavor =3D=3D 0) || (out_info->flavor =3D=3D 0))
>> 		return false;
>>=20
>=20
> --=20
> Regards,
>=20
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

BR and thanks,
Nikolaus
