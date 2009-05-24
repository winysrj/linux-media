Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator4.ecc.gatech.edu ([130.207.185.174]:46785 "EHLO
	deliverator4.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbZEXGA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 02:00:27 -0400
Message-ID: <4A18E279.5010800@gatech.edu>
Date: Sun, 24 May 2009 02:00:25 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Chaithrika U S <chaithrika@ti.com>, linux-media@vger.kernel.org
Subject: Re: v4l-dvb rev 11757 broke building under Ubuntu Hardy
References: <1242345230.3169.49.camel@palomino.walls.org>
In-Reply-To: <1242345230.3169.49.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2009 07:53 PM, Andy Walls wrote:
> David Ward wrote:
>    
>> I am using v4l-dvb in order to add the cx18 driver under Ubuntu Hardy
>> (8.04).
>>
>> The build is currently broken under Hardy, which uses kernel 2.6.24. I
>> have traced the origin of the problem to revision 11757. As seen in
>> the latest cron job output, the build produces the error when trying
>> to compile adv7343.c:
>>
>> /usr/local/src/v4l-dvb/v4l/adv7343.c:506: error: array type has incomplete element type
>> /usr/local/src/v4l-dvb/v4l/adv7343.c:518: warning: initialization from incompatible pointer type
>> /usr/local/src/v4l-dvb/v4l/adv7343.c:520: error: unknown field 'id_table' specified in initializer
>>
>> Thanks for resolving this.
>>
>> David Ward
>>      
> David,
>
> Please try the patch below.
>
> Chaithrika,
>
> Please review (and test if it is OK) the patch below.  It modifies
> adv7343.c to what the cs5345.c file does for backward compatability.
>
> It adds some checks against kernel version, which would not go into the
> actual kernel, and changes some code to use the v4l2 i2c module template
> from v4l2-i2c-drv.h, which *would* go into the actual kenrel.
>
>
> Regards,
> Andy
>
>    
Andy and Chaithrika, sorry for the late reply.  Is a different patch 
being created to replace the ones you posted already, for adv7343.c and 
ths7303.c?  This is still broken in the repository.

Andy, your initial patch at least did resolve the build errors for 
adv7343.c under the Ubuntu Hardy kernel (2.6.24).

Thanks,

David
> Signed-off-by: Andy Walls<awalls@radix.net>
>
> diff -r 0018ed9bbca3 linux/drivers/media/video/adv7343.c
> --- a/linux/drivers/media/video/adv7343.c	Tue May 12 16:13:13 2009 +0000
> +++ b/linux/drivers/media/video/adv7343.c	Thu May 14 19:51:10 2009 -0400
> @@ -29,6 +29,8 @@
>   #include<media/adv7343.h>
>   #include<media/v4l2-device.h>
>   #include<media/v4l2-chip-ident.h>
> +#include<media/v4l2-i2c-drv.h>
> +#include "compat.h"
>
>   #include "adv7343_regs.h"
>
> @@ -503,6 +505,7 @@
>   	return 0;
>   }
>
> +#if LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 26)
>   static const struct i2c_device_id adv7343_id[] = {
>   	{"adv7343", 0},
>   	{},
> @@ -510,25 +513,12 @@
>
>   MODULE_DEVICE_TABLE(i2c, adv7343_id);
>
> -static struct i2c_driver adv7343_driver = {
> -	.driver = {
> -		.owner	= THIS_MODULE,
> -		.name	= "adv7343",
> -	},
> +#endif
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name		= "adv7343",
>   	.probe		= adv7343_probe,
>   	.remove		= adv7343_remove,
> +#if LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 26)
>   	.id_table	= adv7343_id,
> +#endif
>   };
> -
> -static __init int init_adv7343(void)
> -{
> -	return i2c_add_driver(&adv7343_driver);
> -}
> -
> -static __exit void exit_adv7343(void)
> -{
> -	i2c_del_driver(&adv7343_driver);
> -}
> -
> -module_init(init_adv7343);
> -module_exit(exit_adv7343)
