Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:50237 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbeJJQJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:09:29 -0400
Date: Wed, 10 Oct 2018 10:48:17 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] media: ov5640: Don't access ctrl regs when off
Message-ID: <20181010084817.GB7677@w540>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
 <1539067682-60604-4-git-send-email-sam@elite-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <1539067682-60604-4-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sam,
   thanks for the patch.

On Mon, Oct 08, 2018 at 11:48:01PM -0700, Sam Bobrowicz wrote:
> Add a check to g_volatile_ctrl to prevent trying to read
> registers when the sensor is not powered.
>
> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>

I've been carrying a similar patch in my tree. I found it is required
when the sensor control handler is add to the receiver driver control
handler, and thus g_voltaile_ctrl can be called when the sensor is
powered off.

Please add my:
Acked-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

> ---
>  drivers/media/i2c/ov5640.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index f183222..a50d884 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2336,6 +2336,13 @@ static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>
>  	/* v4l2_ctrl_lock() locks our own mutex */
>
> +	/*
> +	 * If the sensor is not powered up by the host driver, do
> +	 * not try to access it to update the volatile controls.
> +	 */
> +	if (sensor->power_count == 0)
> +		return 0;
> +
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTOGAIN:
>  		val = ov5640_get_gain(sensor);
> --
> 2.7.4
>

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbvbzQAAoJEHI0Bo8WoVY8aQMQALPPvYsfQ0bWTIrSoA5JXhDq
7DwnOV7koDj8L/rt2NABjYjw+xuQKKkxn8VHfUQb9Yr6M9EzYRrgESKP+zIatDy9
k38cbF2+p/CQc3E/aoSO6WK8lekVIg73vtU8b/MeXNObO8HTMxc/aAhLz+Wq4Ura
bwxcRuM5tWaRXSH84CXKd2LmII8b3nlZEdlAoha/lkBpC2I1xyaPtxzwsmIk3Vhc
wf8QVl8jygt4+dWPLyegLK12fMSsjy/Y/Oo7oel+RPUIeYQjePHTMIKNKt/PEVP8
hQRQdznu2ZEJFc+dztWJjGuzdAOFIQhsHdbbSywTdqyGdh6WFxLogxBdkaLj8/dI
5VmgKiUP0uTlRsbPAqomEhey0VW59TcNYgBKiPoGu25HMQHv326+clKuP9j1K4yn
oOy/p2WTrMivafJ0zO8pNamWJEaV6PtFdcBGLOwaNoPeoWaoU9i6J19KzsFSqbAQ
zWyfh5j3Q5IR1AEj5YNxxAPNl+BfeKQEYre7f8uQBX0g4DD04O7ob9MefHQ3buwx
iJRjcy47sE9bQ1anOXX50n3074PVoNOnzdfN2Hn5T5zejQ4A5dSAhsi1maxpN7Bl
+1/ahzJZp/Ua6LMBCwKhmn+OrOCS6243+bI6FY7J6GxoLQrhgQHNhgnbzqHvAMW1
zCtZhyorDlCWVaydbJBe
=u8KJ
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
