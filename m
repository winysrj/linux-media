Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab1F1BuV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 21:50:21 -0400
Message-ID: <4E093357.8070303@redhat.com>
Date: Mon, 27 Jun 2011 22:50:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/14] Remove linux/version.h from most drivers/media
References: <20110626130620.4b5ed679@pedra>	<20110626201420.018490cd@tele>	<4E07808C.9060105@redhat.com> <20110627124558.08cd8684@tele>
In-Reply-To: <20110627124558.08cd8684@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-06-2011 07:45, Jean-Francois Moine escreveu:
> On Sun, 26 Jun 2011 15:55:08 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> I'll move it to the right changeset at the version 2 of this series.
> 
> Hi Mauro,
> 
> I have some changes to the gspca.c patch
> - the version must stay 2.12.0
> - the 'info' may be simplified:
> 
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> index e526aa3..1aa6ae2 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -24,7 +24,6 @@
>  #define MODULE_NAME "gspca"
>  
>  #include <linux/init.h>
> -#include <linux/version.h>
>  #include <linux/fs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched.h>
> @@ -51,11 +50,12 @@
>  #error "DEF_NURBS too big"
>  #endif
>  
> +#define DRIVER_VERSION_NUMBER	"2.12.0"
> +
>  MODULE_AUTHOR("Jean-François Moine <http://moinejf.free.fr>");
>  MODULE_DESCRIPTION("GSPCA USB Camera Driver");
>  MODULE_LICENSE("GPL");
> -
> -#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 12, 0)

Hmm... So, you want to revert this change?

commit 5943ba139182f6a3f27492efecb29b0a514b787f
Author: Jean-François Moine <moinejf@free.fr>
Date:   Tue May 17 04:03:51 2011 -0300

    [media] gspca - main: Version change to 2.13
    
    Signed-off-by: Jean-François Moine <moinejf@free.fr>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index e526aa3..739abd4 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -55,7 +55,7 @@ MODULE_AUTHOR("Jean-François Moine <http://moinejf.free.fr>");
 MODULE_DESCRIPTION("GSPCA USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 12, 0)
+#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 13, 0)
 
 #ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE;

If so, I prefer if you do it on a separate patch.


> +MODULE_VERSION(DRIVER_VERSION_NUMBER);
>  
>  #ifdef GSPCA_DEBUG
>  int gspca_debug = D_ERR | D_PROBE;
> @@ -1291,7 +1291,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  	}
>  	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
>  			sizeof(cap->bus_info));
> -	cap->version = DRIVER_VERSION_NUMBER;
>  	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
>  			  | V4L2_CAP_STREAMING
>  			  | V4L2_CAP_READWRITE;
> @@ -2478,10 +2477,7 @@ EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
>  /* -- module insert / remove -- */
>  static int __init gspca_init(void)
>  {
> -	info("v%d.%d.%d registered",
> -		(DRIVER_VERSION_NUMBER >> 16) & 0xff,
> -		(DRIVER_VERSION_NUMBER >> 8) & 0xff,
> -		DRIVER_VERSION_NUMBER & 0xff);
> +	info("v" DRIVER_VERSION_NUMBER " registered");

Ok, I'll add this change into the patch.

>  	return 0;
>  }
>  static void __exit gspca_exit(void)
> 
> 

