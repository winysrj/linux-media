Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36445 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1HWDr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 23:47:27 -0400
Received: by gwaa12 with SMTP id a12so3487712gwa.19
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2011 20:47:27 -0700 (PDT)
Message-ID: <4E5322C8.6040809@gmail.com>
Date: Tue, 23 Aug 2011 15:47:20 +1200
From: CJ <cjpostor@gmail.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	javier Martin <javier.martin@vista-silicon.com>,
	Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mch_kot@yahoo.com.cn
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron)
 mt9p031 sensor.
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <201108191212.49729.laurent.pinchart@ideasonboard.com> <4E51D739.7010000@gmail.com> <201108221141.40818.laurent.pinchart@ideasonboard.com> <4E522C56.3090605@matrix-vision.de>
In-Reply-To: <4E522C56.3090605@matrix-vision.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Michael,

On 22/08/11 22:15, Michael Jones wrote:
>>>>> I am trying to get the mt9p031 working from nand with a ubifs file
>>>>> system and I am having a few problems.
>>>>>
>>>>> /dev/media0 is not present unless I run:
>>>>> #mknod /dev/media0 c 251 0
>>>>> #chown root:video /dev/media0
>>>>>
>>>>> #media-ctl -p
>>>>> Enumerating entities
>>>>> media_open: Unable to enumerate entities for device /dev/media0
>>>>> (Inappropriate ioctl for device)
>>>>>
>>>>> With the same rig/files it works fine running from EXT4 on an SD card.
>>>>> Any idea why this does not work on nand with ubifs?
>>>> Is the OMAP3 ISP driver loaded ? Has it probed the device successfully ?
>>>> Check the kernel log for OMAP3 ISP-related messages.
>>> Here is the version running from SD card:
>>> # dmesg | grep isp
>>> [    0.265502] omap-iommu omap-iommu.0: isp registered
>>> [    2.986541] omap3isp omap3isp: Revision 2.0 found
>>> [    2.991577] omap-iommu omap-iommu.0: isp: version 1.1
>>> [    2.997406] omap3isp omap3isp: hist: DMA channel = 0
>>> [    3.006256] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
>>> 21600000 Hz
>>> [    3.011932] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
>>>
>>>   From NAND using UBIFS:
>>> # dmesg | grep isp
>>> [    3.457061] omap3isp omap3isp: Revision 2.0 found
>>> [    3.462036] omap-iommu omap-iommu.0: isp: version 1.1
>>> [    3.467620] omap3isp omap3isp: hist: DMA channel = 0
>>> [    3.472564] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
>>> 21600000 Hz
>>> [    3.478027] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
>>>
>>> Seems to be missing:
>>> omap-iommu omap-iommu.0: isp registered
>>>
>>> Is that the issue? Why would this not work when running from NAND?
> I'm not sure, either, but I had a similar problem before using Laurent's
> patch below. IIRC, usually udev would create /dev/media0 from a cached
> list of /dev/*. Later modutils would come along and load the modules in
> the proper order (iommu, then omap3-isp) and everybody was happy.
> Occasionally, udev would fail to use the cached version of /dev/, and
> look through /sys/devices to re-create the devices in /dev/. When media0
> was found, omap3-isp.ko would be loaded, but iommu had not yet been,
> presumably because it doesn't have an entry in /sys/devices/. So maybe
> udev is behaving differently for you on NAND than it did on the card?
> Either way, as I said, using Laurent's patch below did the job for me.
>
> -Michael
>
>> I'm not sure why it doesn't work from NAND, but the iommu2 module needs to be
>> loaded before the omap3-isp module. Alternatively you can compile the iommu2
>> module in the kernel with
>>
>> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
>> index 49a4c75..3c87644 100644
>> --- a/arch/arm/plat-omap/Kconfig
>> +++ b/arch/arm/plat-omap/Kconfig
>> @@ -132,7 +132,7 @@ config OMAP_MBOX_KFIFO_SIZE
>>   	  module parameter).
>>
>>   config OMAP_IOMMU
>> -       tristate
>> +       bool
>>
>>   config OMAP_IOMMU_DEBUG
>>          tristate "Export OMAP IOMMU internals in DebugFS"

Thanks for the help!

For some reason dmesg does not read early kernel stuff when in UBIFS 
from NAND.
So when I went back and had a look the line I thought was not there is 
actually included.

[    0.276977] omap-iommu omap-iommu.0: isp registered

So I guess everything is loading fine.

I tried the patch and it didn't make a difference.

Regarding what Michael said /dev/media0 is not created by udev when boot 
from NAND.
I tried creating it manually with:
#mknod /dev/media0 c 251 0
#chown root:video /dev/media0

But this does not work - outputs:

# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP 
CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP 
resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
media_open: Unable to enumerate entities for device /dev/media0 
(Inappropriate ioctl for device)

So is there a problem with udev?

Cheers,
Chris
