Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:41851 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZK2Ki3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 05:38:29 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 845FD8181CB
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 11:38:30 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 4C9D28180BA
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 11:38:28 +0100 (CET)
Date: Sun, 29 Nov 2009 11:38:34 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca main: reorganize loop
Message-ID: <20091129113834.6b47767a@tele>
In-Reply-To: <4B124BDF.50309@freemail.hu>
References: <4B124BDF.50309@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Nov 2009 11:24:31 +0100
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> Eliminate redundant code by reorganizing the loop.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r 064a82aa2daa linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Thu Nov 26
> 19:36:40 2009 +0100 +++
> b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 29 11:09:33
> 2009 +0100 @@ -623,12 +623,12 @@ if (ret < 0)
>  			goto out;
>  	}
> -	ep = get_ep(gspca_dev);
> -	if (ep == NULL) {
> -		ret = -EIO;
> -		goto out;
> -	}
>  	for (;;) {
> +		ep = get_ep(gspca_dev);
> +		if (ep == NULL) {
> +			ret = -EIO;
> +			goto out;
> +		}
>  		PDEBUG(D_STREAM, "init transfer alt %d",
> gspca_dev->alt); ret = create_urbs(gspca_dev, ep);
>  		if (ret < 0)
> @@ -677,12 +677,6 @@
>  			ret =
> gspca_dev->sd_desc->isoc_nego(gspca_dev); if (ret < 0)
>  				goto out;
> -		} else {
> -			ep = get_ep(gspca_dev);
> -			if (ep == NULL) {
> -				ret = -EIO;
> -				goto out;
> -			}
>  		}
>  	}
>  out:

Hello Márton,

As you may see, in the loop, get_ep() is called only when isoc_nego()
is not called. So, your patch does not work.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
