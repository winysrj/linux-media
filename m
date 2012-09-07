Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40902 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2IGElz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 00:41:55 -0400
Received: by obbuo13 with SMTP id uo13so3989059obb.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 21:41:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5048AE38.6080108@redhat.com>
References: <502AC079.50902@gmail.com> <1345038500-28734-1-git-send-email-mchehab@redhat.com>
 <1345038500-28734-11-git-send-email-mchehab@redhat.com> <503811EC.8030808@gmail.com>
 <5048AE38.6080108@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 7 Sep 2012 10:03:30 +0530
Message-ID: <CA+V-a8uV6Hx2iSagUtzcM6Oj-Ko2FsdScWp7KXohR3_nLmiWvA@mail.gmail.com>
Subject: Re: [PATCH 10/12] [media] move i2c files into drivers/media/i2c
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Thu, Sep 6, 2012 at 7:37 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 24-08-2012 20:44, Sylwester Nawrocki escreveu:
>> From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> Date: Sat, 25 Aug 2012 01:23:14 +0200
>> Subject: [PATCH] [media] Fix link order of the V4L2 bridge and I2C modules
>>
>> All I2C modules must be linked first to ensure proper module
>> initialization order. With platform devices linked before I2C
>> modules I2C subdev registration fails as the subdev drivers
>> are not yet initialized during bridge driver's probing.
>>
>> This fixes regression introduced with commmit cb7a01ac324bf2ee2,
>> "[media] move i2c files into drivers/media/i2c".
>>
>> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> ---
>>  drivers/media/Makefile |    7 ++++---
>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
>> index b0b0193..92a8bcf 100644
>> --- a/drivers/media/Makefile
>> +++ b/drivers/media/Makefile
>> @@ -8,8 +8,9 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>>    obj-$(CONFIG_MEDIA_SUPPORT) += media.o
>>  endif
>>
>> -obj-y += tuners/ common/ rc/ platform/
>> -obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/
>> +obj-$(CONFIG_VIDEO_DEV) += v4l2-core/
>> +obj-y += common/ rc/ i2c/
>> +obj-y += tuners/ platform/ pci/ usb/ mmc/ firewire/ parport/
>>
>> -obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
>> +obj-$(CONFIG_VIDEO_DEV) += radio/
>>  obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
>> -- 1.7.4.1
>
> Hmm... This change seems incomplete on my eyes: tuners and dvb-frontends
> are also I2C drivers. So, while this fixes the issue for platform drivers,
> other drivers will still suffer this issue, at least on drivers that doesn't
> depend on drivers located outside the media subsystem[1]
>
> [1] thankfully, staging compiles after media, so the drivers there
> shouldn't be affected. Also, drivers that use alsa won't be affected, as
> alsa core (with is compiled after media) uses subsys_initcall().
>
> IMO, the correct fix is the one below. Could you please test it?
>
> Regards,
> Mauro
>
> -
>
> [media] Fix init order for I2C drivers
>
> Based on a patch from Sylvester Nawrocki
>
> This fixes regression introduced with commmit cb7a01ac324bf2ee2,
> "[media] move i2c files into drivers/media/i2c".
>
> The linked order affect what drivers will be initialized first, when
> they're built-in at Kernel. While there are macros that allow changing
> the init order, like subsys_initcall(), late_initcall() & friends,
> when all drivers  linked belong to the same subsystem, it is easier
> to change the order at the Makefile.
>
> All I2C modules must be linked before any drivers that actually use it,
> in order to ensure proper module initialization order.
>
> Also, the core drivers should be initialized before the drivers that use
> them.
>
> This patch reorders the drivers init, in order to fulfill the above
> requirements.
>
> Reported-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>


Thanks and Regards,
--Prabhakar Lad

> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index b0b0193..620f275 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -4,12 +4,30 @@
>
>  media-objs     := media-device.o media-devnode.o media-entity.o
>
> +#
> +# I2C drivers should come before other drivers, otherwise they'll fail
> +# when compiled as builtin drivers
> +#
> +obj-y += i2c/ tuners/
> +obj-$(CONFIG_DVB_CORE)  += dvb-frontends/
> +
> +#
> +# Now, let's link-in the media core
> +#
>  ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>    obj-$(CONFIG_MEDIA_SUPPORT) += media.o
>  endif
>
> -obj-y += tuners/ common/ rc/ platform/
> -obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/
> +obj-$(CONFIG_VIDEO_DEV) += v4l2-core/
> +obj-$(CONFIG_DVB_CORE)  += dvb-core/
> +
> +# There are both core and drivers at RC subtree - merge before drivers
> +obj-y += rc/
> +
> +#
> +# Finally, merge the drivers that require the core
> +#
> +
> +obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ parport/
> +obj-$(CONFIG_VIDEO_DEV) += radio/
>
> -obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
> -obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
>
>
