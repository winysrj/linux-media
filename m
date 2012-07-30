Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33064 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2G3Xw7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 19:52:59 -0400
Message-ID: <50171E4D.9080306@iki.fi>
Date: Tue, 31 Jul 2012 02:52:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] DVB USB v2
References: <4FF19D3C.6070506@iki.fi> <4FF36865.1090808@iki.fi> <4FF7651A.7020907@redhat.com> <4FFB27D1.9070204@iki.fi> <5016F2AA.9000602@redhat.com>
In-Reply-To: <5016F2AA.9000602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/30/2012 11:46 PM, Mauro Carvalho Chehab wrote:
> Em 09-07-2012 15:49, Antti Palosaari escreveu:
>> On 07/07/2012 01:22 AM, Mauro Carvalho Chehab wrote:
>>> Em 03-07-2012 18:47, Antti Palosaari escreveu:
>>>> On 07/02/2012 04:08 PM, Antti Palosaari wrote:
>>>>> Here it is finally - quite totally rewritten DVB-USB-framework. I
>>>>> haven't got almost any feedback so far...
>>>>
>>>> I rebased it in order to fix compilation issues coming from Kconfig.
>>>>
>>>>
>>>>> regards
>>>>> Antti
>>>>>
>>>>>
>>>>> The following changes since commit
>>>>> 6887a4131da3adaab011613776d865f4bcfb5678:
>>>>>
>>>>>      Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>      git://linuxtv.org/anttip/media_tree.git dvb_usb_pull
>>>>>
>>>>> for you to fetch changes up to 747abaa1e0ee4415e67026c119cb73e6277f4898:
>>>>>
>>>>>      dvb_usb_v2: remove usb_clear_halt() from stream (2012-07-02 15:54:29
>>>>> +0300)
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Antti Palosaari (103):
>>>>>          dvb_usb_v2: copy current dvb_usb as a starting point
>>>
>>> Naming the DVB USB v2 as dvb_usb, instead of dvb-usb is very very ugly.
>>> It took me some time to discover what happened.
>>>
>>> You should have named it as dvb-usb-v2 instead, or to store it into
>>> a separate directory.
>>>
>>> This is even worse as it seems that this series doesn't change all
>>> drivers to use dvb usb v2. So, it will be harder to discover what
>>> drivers are at V1 and what are at V2.
>>>
>>> I won't merge it as-is at staging/for_v3.6. I may eventually create
>>> a separate topic branch and add them there, while the namespace mess
>>> is not corrected, if I still have some time today. Otherwise, I'll only
>>> handle that after returning from vacations.
>>
>> I moved it to the dvb-usb-v2 directory. Same location only added patch top of that.
>>
>> Surely I can convert all drivers and use old directory, but IMHO it is simply too risky. We have already too much problems coming from that kind of big changes.
>>
>> And what goes to file naming hyphen (-) vs. underscore (_), underscore seems to be much more common inside Kernel. Anyhow, I keep directory name as dvb-usb-v2 to follow old naming.
>>
>> $ find ./ -type f -printf "%f\n" | grep "_" | wc -l
>> 21465
>> $ find ./ -type f -printf "%f\n" | grep "-" | wc -l
>> 13927
>
> The above works for me, but unfortunately, the tree can't be applied.
>
> The fact is that there are lots of duplicated symbols between dvb-usb and dvb-usb-v2.
> They'll fail if someone would compile everything bultin (make allyesconfig).
>
> I tried to remove the Kconfig/Makefile changes from the initial patch, moving it to
> happen just before the first driver using dvb-usb-v2. See:
>
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/dvb-usb-v2
>
>
> The patch that adds it to the build system is enclosed. It is basically what's there at
> the initial patch, plus the changes done at the intermediate patches at the Makefile.
>
> The result is shown below:
>
> # make ARCH=i386 allyesconfig
> ...
> $ make ARCH=i386 CONFIG_DEBUG_SECTION_MISMATCH=y M=drivers/media
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `_GLOBAL__sub_I_65535_0_dvb_usb_download_firmware':
> /home/v4l/v4l/patchwork/include/linux/usb.h:197: multiple definition of `dvb_usb_disable_rc_polling'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/include/linux/usb.h:1570: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `usb_urb_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb_urb.c:310: multiple definition of `usb_urb_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb-urb.c:213: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_frontend_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:332: multiple definition of `dvb_usb_adapter_frontend_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c:221: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_dvb_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:260: multiple definition of `dvb_usb_adapter_dvb_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c:164: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_dvb_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:191: multiple definition of `dvb_usb_adapter_dvb_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c:98: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_device_power_ctrl':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_init.c:254: multiple definition of `dvb_usb_device_power_ctrl'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-init.c:216: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_remote_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_remote.c:42: multiple definition of `dvb_usb_remote_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-remote.c:308: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `usb_urb_kill':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb_urb.c:76: multiple definition of `usb_urb_kill'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb-urb.c:66: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_frontend_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:401: multiple definition of `dvb_usb_adapter_frontend_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c:276: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_i2c_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_init.c:72: multiple definition of `dvb_usb_i2c_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c:11: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_stream_init':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:36: multiple definition of `dvb_usb_adapter_stream_init'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:92: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `usb_urb_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb_urb.c:351: multiple definition of `usb_urb_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb-urb.c:238: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_download_firmware':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_init.c:28: multiple definition of `dvb_usb_download_firmware'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c:79: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_remote_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_remote.c:108: multiple definition of `dvb_usb_remote_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-remote.c:341: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_adapter_stream_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_dvb.c:60: multiple definition of `dvb_usb_adapter_stream_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-urb.c:116: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `usb_urb_submit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb_urb.c:89: multiple definition of `usb_urb_submit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/usb-urb.c:79: first defined here
> drivers/media/dvb/dvb-usb/dvb_usbv2.o: In function `dvb_usb_i2c_exit':
> /home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb_usb_init.c:95: multiple definition of `dvb_usb_i2c_exit'
> drivers/media/dvb/dvb-usb/dvb-usb.o:/home/v4l/v4l/patchwork/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c:38: first defined here
> make[3]: *** [drivers/media/dvb/dvb-usb/built-in.o] Error 1
> make[2]: *** [drivers/media/dvb/dvb-usb] Error 2
> make[1]: *** [drivers/media/dvb] Error 2
>
>
> Please fix it, in order to allow me to merge the changes. Please base your patches
> on my experimental tree, as this will save me the time to review the patches that
> are already there (and that are ok, on my eyes).

I think I have to do quite big rebase :s It could take day or two as I 
should start learning how to fix that kind of issues...

regards
Antti


>
> Thanks!
> Mauro
>
>
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index c216156..a6ffdb3 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -13,6 +13,21 @@ config DVB_USB
>
>   	  Say Y if you own a USB DVB device.
>
> +config DVB_USB_V2
> +	tristate "Support for various USB DVB devices v2"
> +	depends on DVB_CORE && USB && I2C && RC_CORE
> +	help
> +	  By enabling this you will be able to choose the various supported
> +	  USB1.1 and USB2.0 DVB devices.
> +
> +	  Almost every USB device needs a firmware, please look into
> +	  <file:Documentation/dvb/README.dvb-usb>.
> +
> +	  For a complete list of supported USB devices see the LinuxTV DVB Wiki:
> +	  <http://www.linuxtv.org/wiki/index.php/DVB_USB>
> +
> +	  Say Y if you own a USB DVB device.
> +
>   config DVB_USB_DEBUG
>   	bool "Enable extended debug support for all DVB-USB devices"
>   	depends on DVB_USB
> diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
> index b667ac3..3c73e7b 100644
> --- a/drivers/media/dvb/dvb-usb/Makefile
> +++ b/drivers/media/dvb/dvb-usb/Makefile
> @@ -1,6 +1,9 @@
>   dvb-usb-objs = dvb-usb-firmware.o dvb-usb-init.o dvb-usb-urb.o dvb-usb-i2c.o dvb-usb-dvb.o dvb-usb-remote.o usb-urb.o
>   obj-$(CONFIG_DVB_USB) += dvb-usb.o
>
> +dvb_usbv2-objs = dvb_usb_init.o dvb_usb_urb.o dvb_usb_dvb.o dvb_usb_remote.o usb_urb.o
> +obj-$(CONFIG_DVB_USB_V2) += dvb_usbv2.o
> +
>   dvb-usb-vp7045-objs = vp7045.o vp7045-fe.o
>   obj-$(CONFIG_DVB_USB_VP7045) += dvb-usb-vp7045.o
>
>
>
>
>
> 	git://linuxtv.org/mchehab/experimental.git dvb-usb-v2
>
>


-- 
http://palosaari.fi/
