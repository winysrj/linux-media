Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42918 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab1GHKes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 06:34:48 -0400
References: <201107081100.37406.jdelvare@suse.de>
In-Reply-To: <201107081100.37406.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [media] tea5764: Fix module parameter permissions
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 08 Jul 2011 06:34:38 -0400
To: Jean Delvare <jdelvare@suse.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabio Belavenuto <belavenuto@gmail.com>
Message-ID: <fe03786e-e629-4260-b637-80a58ce37728@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Jean Delvare <jdelvare@suse.de> wrote:

>The third parameter of module_param is supposed to represent sysfs
>file permissions. A value of "1" leads to the following:
>
>$ ls -l /sys/module/radio_tea5764/parameters/
>total 0
>---------x 1 root root 4096 Jul  8 09:17 use_xtal
>
>I am changing it to "0" to align with the other module parameters in
>this driver.
>
>Signed-off-by: Jean Delvare <jdelvare@suse.de>
>Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>Cc: Fabio Belavenuto <belavenuto@gmail.com>
>---
> drivers/media/radio/radio-tea5764.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- linux-3.0-rc6.orig/drivers/media/radio/radio-tea5764.c	2011-05-20
>10:41:19.000000000 +0200
>+++ linux-3.0-rc6/drivers/media/radio/radio-tea5764.c	2011-07-08
>09:15:16.000000000 +0200
>@@ -596,7 +596,7 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
> MODULE_DESCRIPTION(DRIVER_DESC);
> MODULE_LICENSE("GPL");
> 
>-module_param(use_xtal, int, 1);
>+module_param(use_xtal, int, 0);
> MODULE_PARM_DESC(use_xtal, "Chip have a xtal connected in board");
> module_param(radio_nr, int, 0);
> MODULE_PARM_DESC(radio_nr, "video4linux device number to use");
>
>-- 
>Jean Delvare
>Suse L3
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

To whomever might know:

Was the intent of the "1" to set the default value of the parameter?

Regards,
Andy
