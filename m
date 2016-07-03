Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcGCVSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2016 17:18:24 -0400
Subject: Re: ov519.c - allow setting i2c_detect_tries
To: Valdis.Kletnieks@vt.edu,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <43010.1437000713@turing-police.cc.vt.edu>
Cc: contact@demhlyr.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <9300bb88-846d-8167-bdf9-6b91b2927696@redhat.com>
Date: Sun, 3 Jul 2016 23:18:18 +0200
MIME-Version: 1.0
In-Reply-To: <43010.1437000713@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 16-07-15 00:51, Valdis.Kletnieks@vt.edu wrote:
> I encountered a user who was having troubles getting a PlayStation EyeToy
> (USB ID 054c:0155) working as a webcam. They reported that repeated attempts
> would often make it work.  Looking at the code, there was support for
> repeated attempts at I2C transactions - but only if you rebuilt the
> module from source.
>
> Added module parameter support so that users running a distro kernel
> can tune it for recalcitrant devices.

That is not necessary, this should be fixed by this commit:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/media/usb/gspca?id=f7c7ac480d246f2f625a70f56ea6650710c23f30

Regards,

Hans


>
> While we're at it, fix the comment to reflect the error message actually issued.
>
> Testing:
>
> [/usr/src/linux-next] insmod drivers/media/usb/gspca/gspca_ov519.ko
> [/usr/src/linux-next] cat /sys/module/gspca_ov519/parameters/i2c_detect_tries
> 10
> [/usr/src/linux-next] rmmod gspca_ov519
> [/usr/src/linux-next] insmod drivers/media/usb/gspca/gspca_ov519.ko i2c_detect_tries=50
> [/usr/src/linux-next] cat /sys/module/gspca_ov519/parameters/i2c_detect_tries
> 50
> [/usr/src/linux-next] modinfo drivers/media/usb/gspca/gspca_ov519.ko | grep parm
> parm:           i2c_detect_tries:Number of times to try to init I2C (default 10) (int)
> parm:           frame_rate:Frame rate (5, 10, 15, 20 or 30 fps) (int)
>
> Reported-By: Demhlyr <contact@demhlyr.de>
> Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> ---
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --- a/drivers/media/usb/gspca/ov519.c	2014-10-21 10:06:09.359806243 -0400
> +++ b/drivers/media/usb/gspca/ov519.c	2015-07-15 18:35:21.063790541 -0400
> @@ -57,8 +57,10 @@ MODULE_LICENSE("GPL");
>  static int frame_rate;
>
>  /* Number of times to retry a failed I2C transaction. Increase this if you
> - * are getting "Failed to read sensor ID..." */
> + * are getting "Can't determine sensor slave IDs" */
>  static int i2c_detect_tries = 10;
> +module_param(i2c_detect_tries, int, 0644);
> +MODULE_PARM_DESC(i2c_detect_tries,"Number of times to try to init I2C (default 10)");
>
>  /* ov519 device descriptor */
>  struct sd {
>
