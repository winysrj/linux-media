Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1GIAl0u009368
	for <video4linux-list@redhat.com>; Sat, 16 Feb 2008 13:10:47 -0500
Received: from as4.cineca.com (as4.cineca.com [130.186.84.251])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1GIAEAV016629
	for <video4linux-list@redhat.com>; Sat, 16 Feb 2008 13:10:14 -0500
From: Luca Risolia <luca.risolia@studio.unibo.it>
To: Roel Kluin <12o3l@tiscali.nl>
Date: Sat, 16 Feb 2008 19:09:44 +0100
References: <47B70B6A.1070404@tiscali.nl>
In-Reply-To: <47B70B6A.1070404@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802161909.44284.luca.risolia@studio.unibo.it>
Cc: video4linux-list@redhat.com, linux-usb@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drivers/media/video/sn9c102/sn9c102_core.c Fix
	Unlikely(x) == y
Reply-To: luca.risolia@studio.unibo.it
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

It's okay, thanks.

Reviewed-by: Luca Risolia <luca.risolia@studio.unibo.it>
---

On Saturday 16 February 2008 17:12:26 Roel Kluin wrote:
> The patch below was not yet tested. If it's incorrect, please comment.
> ---
> Fix Unlikely(x) == y
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c
> b/drivers/media/video/sn9c102/sn9c102_core.c index c40ba3a..66313b1 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -528,7 +528,7 @@ sn9c102_find_sof_header(struct sn9c102_device* cam,
> void* mem, size_t len)
>
>  		/* Search for the SOF marker (fixed part) in the header */
>  		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
> -			if (unlikely(i+j) == len)
> +			if (unlikely(i+j == len))
>  				return NULL;
>  			if (*(m+i+j) == marker[cam->sof.bytesread]) {
>  				cam->sof.header[cam->sof.bytesread] = *(m+i+j);


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
