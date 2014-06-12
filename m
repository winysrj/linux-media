Return-path: <linux-media-owner@vger.kernel.org>
Received: from taro.utanet.at ([213.90.36.45]:50033 "EHLO taro.utanet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFLRrL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:47:11 -0400
Message-ID: <5399E357.3040203@utanet.at>
Date: Thu, 12 Jun 2014 19:28:55 +0200
From: Bernhard Praschinger <shadowlord@utanet.at>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [Mjpeg-users] [patch] [media] zoran: remove duplicate ZR050_MO_COMP
 define
References: <20140609152135.GQ9600@mwanda>
In-Reply-To: <20140609152135.GQ9600@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo

More than 15 years have passed since the first working module for a 
zoran chipset based PCI card existed. Well not included into the Linux 
kernel at that time.
According to my experience, the driver started to make problems when 64 
Bit and more than 2GB Ram became popular. In May 2011 there was a patch 
available that made the cards working in machines with more than 2GB 
Ram, and AMD&Intel x64 architectures. According to my information that 
patch did not make it into the linux kernel (the Patch was for the Linux 
2.6.38 Kernel)

So people spend time looking at code that does not work (well it 
compiles and does not cause troubles), and send patches the world will 
never honor.

I haven't had a question related to a zoran based card's in years. So 
I'm quite sure there are not much users out there that use a zoran based 
video cards in a up to date environment.

Because of that I would really suggest that somebody removes the whole 
zoran driver from the linux kernel.

Dan Carpenter wrote:
> The ZR050_MO_COMP define is cut and pasted twice so we can delete the
> second instance.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/pci/zoran/zr36050.h b/drivers/media/pci/zoran/zr36050.h
> index 9f52f0c..ea083ad 100644
> --- a/drivers/media/pci/zoran/zr36050.h
> +++ b/drivers/media/pci/zoran/zr36050.h
> @@ -126,7 +126,6 @@ struct zr36050 {
>   /* zr36050 mode register bits */
>
>   #define ZR050_MO_COMP                0x80
> -#define ZR050_MO_COMP                0x80
>   #define ZR050_MO_ATP                 0x40
>   #define ZR050_MO_PASS2               0x20
>   #define ZR050_MO_TLM                 0x10
>
> ------------------------------------------------------------------------------
> HPCC Systems Open Source Big Data Platform from LexisNexis Risk Solutions
> Find What Matters Most in Your Big Data with HPCC Systems
> Open Source. Fast. Scalable. Simple. Ideal for Dirty Data.
> Leverages Graph Analysis for Fast Processing & Easy Data Exploration
> http://p.sf.net/sfu/hpccsystems
> _______________________________________________
> Mjpeg-users mailing list
> Mjpeg-users@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/mjpeg-users

Kind Regards
Bernhard Praschinger
Docwriter, probably the last mjpegtools maintainer
