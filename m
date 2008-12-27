Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <49568AEE.20506@gmail.com>
Date: Sat, 27 Dec 2008 21:07:10 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
References: <49564CF1.2060307@gmail.com>
In-Reply-To: <49564CF1.2060307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mchehab@redhat.com
Subject: Re: [PATCH] V4L/DVB: gspca: &/&& typo
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Roel Kluin wrote:
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> index 14b1eac..c3ebcca 100644
> --- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> +++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> @@ -114,7 +114,7 @@ int s5k4aa_read_sensor(struct sd *sd, const u8 address,
>  	if (err < 0)
>  		goto out;
>  
> -	for (i = 0; (i < len) & !err; i++) {
> +	for (i = 0; (i < len) && !err; i++) {
>  		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
>  
>  		PDEBUG(D_CONF, "Reading sensor register "
> 

Thanks Roel,

Current 2.6.29 ready code doesn't have this bug as the driver is
reworked. It's there in the 2.6.28 code but shouldn't pose a problem
as the err variable should normally evaluate itself to 0 which is
inverted to true (== 1?) thus as (1 < len) is evaluated to true the
statement should work as intended. I don't have hardware supporting
the s5k4aa but I replicated the bug with my ov9650 sensor code and
it still worked as intended.

Summary: Mauro, If you want to add this fix for 2.6.28, go ahead but
 the current code 2.6.28 shouldn't prevent the driver from working
as intended. This is not an issue in the current gspca-m5602 tree.

Regards,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklWiusACgkQN7qBt+4UG0EHLQCeK+lbrEM/upfGjcwQAQxSgNNG
SvEAmQGSHlgRJfxZX981jgHH8akpLsbM
=gpZy
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
