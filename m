Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7672 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbbIKJ2r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 05:28:47 -0400
Subject: Re: [PATCH 2/2] [media] media-device: split media initialization and
 registration
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
 <1441890195-11650-3-git-send-email-javier@osg.samsung.com>
 <55F1BA5C.50508@linux.intel.com> <55F1CC72.6000204@osg.samsung.com>
 <55F26BDF.8050600@linux.intel.com> <55F28358.1070007@osg.samsung.com>
 <20150911060728.0d8c061d@recife.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F29EC5.6050806@linux.intel.com>
Date: Fri, 11 Sep 2015 12:28:37 +0300
MIME-Version: 1.0
In-Reply-To: <20150911060728.0d8c061d@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2015 09:31:36 +0200
> Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> 
>> Hello Sakari,
>>
>> On 09/11/2015 07:51 AM, Sakari Ailus wrote:
>>> Hi Javier,
>>>
>>> Javier Martinez Canillas wrote:
>>>> Hello Sakari,
>>>>
>>>> On 09/10/2015 07:14 PM, Sakari Ailus wrote:
>>>>> Hi Javier,
>>>>>
>>>>> Thanks for the set! A few comments below.
>>>>>
>>>>
>>>> Thanks to you for your feedback.
>>>>
>>>>> Javier Martinez Canillas wrote:
>>>>>> The media device node is registered and so made visible to user-space
>>>>>> before entities are registered and links created which means that the
>>>>>> media graph obtained by user-space could be only partially enumerated
>>>>>> if that happens too early before all the graph has been created.
>>>>>>
>>>>>> To avoid this race condition, split the media init and registration
>>>>>> in separate functions and only register the media device node when
>>>>>> all the pending subdevices have been registered, either explicitly
>>>>>> by the driver or asynchronously using v4l2_async_register_subdev().
>>>>>>
>>>>>> Also, add a media_entity_cleanup() function that will destroy the
>>>>>> graph_mutex that is initialized in media_entity_init().
>>>>>>
>>>>>> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>>   drivers/media/common/siano/smsdvb-main.c      |  1 +
>>>>>>   drivers/media/media-device.c                  | 38 +++++++++++++++++++++++----
>>>>>>   drivers/media/platform/exynos4-is/media-dev.c | 12 ++++++---
>>>>>>   drivers/media/platform/omap3isp/isp.c         | 11 +++++---
>>>>>>   drivers/media/platform/s3c-camif/camif-core.c | 13 ++++++---
>>>>>>   drivers/media/platform/vsp1/vsp1_drv.c        | 19 ++++++++++----
>>>>>>   drivers/media/platform/xilinx/xilinx-vipp.c   | 11 +++++---
>>>>>>   drivers/media/usb/au0828/au0828-core.c        | 26 +++++++++++++-----
>>>>>>   drivers/media/usb/cx231xx/cx231xx-cards.c     | 22 +++++++++++-----
>>>>>>   drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 11 +++++---
>>>>>>   drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 13 ++++++---
>>>>>>   drivers/media/usb/siano/smsusb.c              | 14 ++++++++--
>>>>>>   drivers/media/usb/uvc/uvc_driver.c            |  9 +++++--
>>>>>>   include/media/media-device.h                  |  2 ++
>>>>>>   14 files changed, 156 insertions(+), 46 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
>>>>>> index ab345490a43a..8a1ea2192439 100644
>>>>>> --- a/drivers/media/common/siano/smsdvb-main.c
>>>>>> +++ b/drivers/media/common/siano/smsdvb-main.c
>>>>>> @@ -617,6 +617,7 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
>>>>>>       if (!coredev->media_dev)
>>>>>>           return;
>>>>>>       media_device_unregister(coredev->media_dev);
>>>>>> +    media_device_cleanup(coredev->media_dev);
>>>>>>       kfree(coredev->media_dev);
>>>>>>       coredev->media_dev = NULL;
>>>>>>   #endif
>>>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>>>> index 745defb34b33..a8beb0b445a6 100644
>>>>>> --- a/drivers/media/media-device.c
>>>>>> +++ b/drivers/media/media-device.c
>>>>>> @@ -526,7 +526,7 @@ static void media_device_release(struct media_devnode *mdev)
>>>>>>   }
>>>>>>
>>>>>>   /**
>>>>>> - * media_device_register - register a media device
>>>>>> + * media_device_init() - initialize a media device
>>>>>>    * @mdev:    The media device
>>>>>>    *
>>>>>>    * The caller is responsible for initializing the media device before
>>>>>> @@ -534,12 +534,11 @@ static void media_device_release(struct media_devnode *mdev)
>>>>>>    *
>>>>>>    * - dev must point to the parent device
>>>>>>    * - model must be filled with the device model name
>>>>>> + *
>>>>>> + * returns zero on success or a negative error code.
>>>>>>    */
>>>>>> -int __must_check __media_device_register(struct media_device *mdev,
>>>>>> -                     struct module *owner)
>>>>>> +int __must_check media_device_init(struct media_device *mdev)
>>>>>
>>>>> I think I suggested making media_device_init() return void as the only
>>>>> remaining source of errors would be driver bugs.
>>>>>
>>>>
>>>> Yes you did and I think I explained why I preferred to leave it as
>>>> is and I thought we agreed :)
>>>
>>> I thought we agreed, too. But my understanding was that the agreement was different. ;-)
>>>
>>
>> Fair enough :)
>>  
>>>>
>>>> Currently media_device_register() is failing gracefully if a buggy
>>>> driver is not setting mdev->dev. So changing media_device_init() to
>>>> return void instead, would be a semantic change and if drivers are
>>>> not checking that anymore, can lead to NULL pointer dereference bugs.
>>>
>>> Do we have such drivers? Would they ever have worked in the first place, as media device registration would have failed?
> 
> Actually we do. The media controller is an optional feature at the DVB
> only drivers (dvb-usb, dvb-usb-v2, siano), as it is used only to show
> the interfaces associated to them, and no functionality will be lost
> if it fails to register the MC (except for the enumeration).

We're talking here about the arguments passed to the media_device_init()
function, and the WARN_ON() check in the current media_device_register().

I can see that dvb-usb-dvb.c does not ensure the model is not an empty
string. I wonder if it'd be better to drop that check entirely. The
model field has no special meaning as far as I can tell.

> 
> I don't see any reason why making it mandatory at those PC customer
> DVB drivers. If it fails... well, G_TOPOLOGY won't work, but all
> the rest will.

I'm not for making it mandatory, but instead relying on drivers to use
the API correctly in probe() (or face BUG_ON()).

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
