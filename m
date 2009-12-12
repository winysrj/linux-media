Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:40710 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZLLKV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 05:21:28 -0500
Date: Sat, 12 Dec 2009 11:21:45 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca m5602: eliminate sparse warnings
Message-ID: <20091212112145.228bb01c@tele>
In-Reply-To: <4B22BAB0.5070604@freemail.hu>
References: <4B22BAB0.5070604@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Dec 2009 22:33:36 +0100
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> Eliminate the following sparse warnings (see "make C=1"):
>  * v4l/m5602_s5k4aa.c:530:23: warning: dubious: x | !y
>  * v4l/m5602_s5k4aa.c:575:23: warning: dubious: x | !y
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> ../../m5602_s5k4aa_dubious.patch
> diff -r f5662ce08663
> linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c ---
> a/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c	Fri Dec
> 11 09:53:41 2009 +0100 +++
> b/linux/drivers/media/video/gspca/m5602/m5602_s5k4aa.c	Fri Dec
> 11 22:25:50 2009 +0100 @@ -527,7 +527,7 @@ err =
> m5602_read_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1); if (err < 0)
> return err;
> -	data = (data & 0xfe) | !val;
> +	data = (data & 0xfe) | (val ? 0 : 1);
>  	err = m5602_write_sensor(sd, S5K4AA_ROWSTART_LO, &data, 1);
>  	return err;
>  }
> @@ -572,7 +572,7 @@
>  	err = m5602_read_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
>  	if (err < 0)
>  		return err;
> -	data = (data & 0xfe) | !val;
> +	data = (data & 0xfe) | (val ? 0 : 1);
>  	err = m5602_write_sensor(sd, S5K4AA_COLSTART_LO, &data, 1);
>  	return err;
>  }

Thanks, but I fixed it in an other way.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
