Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0VFi8qh002736
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 10:44:08 -0500
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0VFhn5K030630
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 10:43:49 -0500
Message-ID: <42400.82.95.89.49.1233416628.squirrel@webmail.xs4all.nl>
Date: Sat, 31 Jan 2009 16:43:48 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "TJ" <linux@tjworld.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: FTBFS: v4l/tvmixer.c:226: error: 'I2C_DRIVERID_TVMIXER'
 undeclared here
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


> http://www.linuxtv.org/hg/v4l-dvb
>
> v4l/tvmixer.c:226: error: 'I2C_DRIVERID_TVMIXER' undeclared here
>
> There is a FTBFS as a result of changeset 10402 (backport merge
> 3541eb5b56f7) where the definition of I2C_DRIVERID_TVMIXER was removed:

I've already asked Mauro to pull from my ~hverkuil/v4l-dvb tree to fix
this issue.

Regards,

      Hans

>
> +++ b/linux/include/linux/i2c-id.h	Thu Jan 29 10:57:25 2009 -0200
> @@ -40,9 +40,7 @@
> #define I2C_DRIVERID_SAA7185B	13	/* video encoder		*/
> #define I2C_DRIVERID_SAA7110	22	/* video decoder		*/
> #define I2C_DRIVERID_SAA5249	24	/* SAA5249 and compatibles	*/
> -#define I2C_DRIVERID_PCF8583	25	/* real time clock		*/
> #define I2C_DRIVERID_TDA7432	27	/* Stereo sound processor	*/
> -#define I2C_DRIVERID_TVMIXER    28      /* Mixer driver for tv cards
> */
> #define I2C_DRIVERID_TVAUDIO    29      /* Generic TV sound driver      */
>
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
