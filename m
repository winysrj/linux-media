Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:43020 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdA3UGf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 15:06:35 -0500
From: Eric Anholt <eric@anholt.net>
To: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: bcm2835-v4l2: Apply spelling fixes from checkpatch.
In-Reply-To: <1485556233.12563.142.camel@perches.com>
References: <20170127215503.13208-1-eric@anholt.net> <20170127215503.13208-7-eric@anholt.net> <1485556233.12563.142.camel@perches.com>
Date: Mon, 30 Jan 2017 12:05:10 -0800
Message-ID: <87inowfh55.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Joe Perches <joe@perches.com> writes:

> On Fri, 2017-01-27 at 13:55 -0800, Eric Anholt wrote:
>> Generated with checkpatch.pl --fix-inplace and git add -p out of the
>> results.
>
> Maybe another.
>
>> diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drive=
rs/staging/media/platform/bcm2835/mmal-vchiq.c
> []
>> @@ -239,7 +239,7 @@ static int bulk_receive(struct vchiq_mmal_instance *=
instance,
>>  		pr_err("buffer list empty trying to submit bulk receive\n");
>>=20=20
>>  		/* todo: this is a serious error, we should never have
>> -		 * commited a buffer_to_host operation to the mmal
>> +		 * committed a buffer_to_host operation to the mmal
>>  		 * port without the buffer to back it up (underflow
>>  		 * handling) and there is no obvious way to deal with
>>  		 * this - how is the mmal servie going to react when
>
> Perhaps s/servie/service/ ?

I was trying to restrict this patch to just the fixes from checkpatch.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAliPnHYACgkQtdYpNtH8
nugD9A/8C5h8ysOew54cNBUcnAuXlBduGV45FglBjGPaP1IexSUjmMb71TdqxmxO
cspigZYe4EUIu5hGX954alN8is7Zk9L5K4WfuK8yxqHO+N56OPu89eOehECjf9Lr
1L+LDRTfM/32j05hOi+Hf4Awd3vzNiRljDVieFnDqZh5TrBvu+HUho7MtRs+NeQz
2ZAo0XU4UqFY8QMQokQ5Xrc9Gmwx57OzImjo4W0sTfnscotI4g5v/na3coLUMLW3
IO1c632Le40TF9GhksDJdw57iyAOOanWjVN3/mVUq4u2ytfhCRSveSaV5p4TF4/c
nhb+vcHPC7mz7cAv168xAYuSLkehC/bmMzbnK2Xl4x61E3/n03NzgWIwfdYhK0nD
GKOC/PrTlwFeMv60mXyJYD5SkwK8cTzKJeE1TZLfNJ2StFiitTEEWGkJ0fiA6swQ
ewqq/D9I5GkqKRmo09zzsN3zK9Q/c4t/1CIT0WKCHFZrqR6wt0Szb1q/V9zsd+d+
rblewveQ8u+UjsYfoWdSkXtjNJpoG+zt8KSuSkoqV1roKOEGTvlLbYq7Y/k6e4uQ
f4m/tkLsbbUD4kv4WlAXcsDtlix26sBz8GRiJyO4NEgoMa0nzNqCEFIfF89HMjJa
e/AxzNieYEgIE9BBEQfX4qgFfcg1BYWrmHppur/lpYKVWr3BGFI=
=kSxd
-----END PGP SIGNATURE-----
--=-=-=--
