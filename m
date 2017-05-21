Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:48290 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdEUGvy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 02:51:54 -0400
Date: Sun, 21 May 2017 08:51:52 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 14/16] lirc_dev: cleanup includes
Message-ID: <20170521065152.q5amscfqbj4yb5xw@hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365468723.12922.7216057583221400867.stgit@zeus.hardeman.nu>
 <20170519182122.GA4136@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170519182122.GA4136@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 19, 2017 at 07:21:23PM +0100, Sean Young wrote:
>On Mon, May 01, 2017 at 06:04:47PM +0200, David Härdeman wrote:
>> Remove superfluous includes and defines.
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>>  drivers/media/rc/lirc_dev.c |   12 +-----------
>>  1 file changed, 1 insertion(+), 11 deletions(-)
>> 
>> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
>> index 7db7d4c57991..4ba6c7e2d41b 100644
>> --- a/drivers/media/rc/lirc_dev.c
>> +++ b/drivers/media/rc/lirc_dev.c
>> @@ -15,20 +15,11 @@
>>   *
>>   */
>>  
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/module.h>
>> -#include <linux/kernel.h>
>>  #include <linux/sched/signal.h>
>> -#include <linux/errno.h>
>>  #include <linux/ioctl.h>
>> -#include <linux/fs.h>
>>  #include <linux/poll.h>
>> -#include <linux/completion.h>
>>  #include <linux/mutex.h>
>> -#include <linux/wait.h>
>> -#include <linux/unistd.h>
>> -#include <linux/bitops.h>
>>  #include <linux/device.h>
>>  #include <linux/cdev.h>
>>  #include <linux/idr.h>
>> @@ -37,7 +28,6 @@
>>  #include <media/lirc.h>
>>  #include <media/lirc_dev.h>
>>  
>> -#define IRCTL_DEV_NAME	"BaseRemoteCtl"
>>  #define LOGHEAD		"lirc_dev (%s[%d]): "
>>  
>>  static dev_t lirc_base_dev;
>> @@ -545,7 +535,7 @@ static int __init lirc_dev_init(void)
>>  	}
>>  
>>  	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
>> -				     IRCTL_DEV_NAME);
>> +				     "BaseRemoteCtl");
>
>This has always surprised/annoyed me. Why is this called BaseRemoteCtl? As
>far as I know, this is only used for /proc/devices, where it says:
>
>$ grep 239 /proc/devices 
>239 BaseRemoteCtl
>
>And not lirc, as you would expect.

Yeah, I also find it a bit of an ugly wart. I didn't dare to change it
though since userspace might rely on "BaseRemoteCtl". For example:
https://build.opensuse.org/package/view_file/openSUSE:12.2/lirc/rc.lirc?expand=1)

-- 
David Härdeman
