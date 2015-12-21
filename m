Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59725 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbbLULVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 06:21:32 -0500
Subject: Re: [PATCH v5 0/3] [media] Fix race between graph enumeration and
 entities registration
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1449874629-8973-1-git-send-email-javier@osg.samsung.com>
 <20151212115025.06e54516@recife.lan>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5677E0B5.1080007@osg.samsung.com>
Date: Mon, 21 Dec 2015 08:21:25 -0300
MIME-Version: 1.0
In-Reply-To: <20151212115025.06e54516@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/12/2015 10:50 AM, Mauro Carvalho Chehab wrote:
> Em Fri, 11 Dec 2015 19:57:06 -0300
> Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> 
>> Hello,
>>
>> This series fixes the issue of media device nodes being registered before
>> all the media entities and pads links are created so if user-space tries
>> to enumerate the graph too early, it may get a partial graph enumeration
>> since everything may not been registered yet.
>>
>> The solution (suggested by Sakari Ailus) is to separate the media device
>> registration from the initialization so drivers can first initialize the
>> media device, create the graph and then finally register the media device
>> node once is finished.
>>
>> This is the fifth version of the series and is a rebase on top of latest
>> MC next gen and the only important change is the addition of patch 3/3.
>>
>> Patch #1 adds a check to the media_device_unregister() function to know if
>> the media device has been registed yet so calling it will be safe and the
>> cleanup functions of the drivers won't need to be changed in case register
>> failed.
>>
>> Patch #2 does the init and registration split, changing all the drivers to
>> make the change atomic and also adds a cleanup function for media devices.
>>
>> Patch #3 sets a topology version 0 at media device registration to allow
>> user-space to know that the graph is "static" (i.e: no graph updates after
>> the media device was registered).
> 
> Got some troubles when compiling those patches:
> 
> drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_media_device_init’:
> drivers/media/usb/dvb-usb/dvb-usb-dvb.c:104:6: warning: unused variable ‘ret’ [-Wunused-variable]
>   int ret;
>       ^
> drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_media_device_register’:
> drivers/media/usb/dvb-usb/dvb-usb-dvb.c:129:2: warning: ignoring return value of ‘__media_device_register’, declared with attribute warn_unused_result [-Wunused-result]
>   media_device_register(adap->dvb_adap.mdev);
>   ^
> 
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_media_device_init’:
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:409:6: warning: unused variable ‘ret’ [-Wunused-variable]
>   int ret;
>       ^
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_adapter_frontend_init’:
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:706:34: warning: passing argument 1 of ‘dvb_usbv2_media_device_register’ from incompatible pointer type [-Wincompatible-pointer-types]
>   dvb_usbv2_media_device_register(&adap->dvb_adap);
>                                   ^
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:432:13: note: expected ‘struct dvb_usb_adapter *’ but argument is of type ‘struct dvb_adapter *’
>  static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
>              ^
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_media_device_register’:
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:435:2: warning: ignoring return value of ‘__media_device_register’, declared with attribute warn_unused_result [-Wunused-result]
>   media_device_register(adap->dvb_adap.mdev);
> 
>

Sorry for missing these, the patches needed a rebase but neither
omap2plus_defconfig nor exynos_defconfing (the platforms I used
for testing) enabled DVB_USB and I forgot to do a more extensive
build test.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
