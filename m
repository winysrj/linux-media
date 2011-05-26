Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34041 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1EZGsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 02:48:37 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 39FDCD4804B
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 08:48:30 +0200 (CEST)
Date: Thu, 26 May 2011 08:49:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] gspca/kinect: wrap gspca_debug with GSPCA_DEBUG
Message-ID: <20110526084912.1ac3ac37@tele>
In-Reply-To: <1306359272-30792-1-git-send-email-jarod@redhat.com>
References: <1306305788.2390.4.camel@porites>
 <1306359272-30792-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 25 May 2011 17:34:32 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
> index 66671a4..26fc206 100644
> --- a/drivers/media/video/gspca/kinect.c
> +++ b/drivers/media/video/gspca/kinect.c
> @@ -34,7 +34,7 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
>  MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
>  MODULE_LICENSE("GPL");
>  
> -#ifdef DEBUG
> +#ifdef GSPCA_DEBUG
>  int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
>  	D_USBI | D_USBO | D_V4L2;
>  #endif

Hi Jarod,

Sorry, it is not the right fix. In fact, the variable gspca_debug must
not be defined in gspca subdrivers:

--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -34,11 +34,6 @@
 MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-#ifdef DEBUG
-int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
-	D_USBI | D_USBO | D_V4L2;
-#endif
-
 struct pkt_hdr {
 	uint8_t magic[2];
 	uint8_t pad;

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
