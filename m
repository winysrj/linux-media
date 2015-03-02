Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38569 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbbCBOFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 09:05:52 -0500
Message-ID: <54F46E2D.80500@xs4all.nl>
Date: Mon, 02 Mar 2015 15:05:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb: fix compilation errors/warnings ifndef CONFIG_MEDIA_CONTROLLER_DVB
References: <54F02B77.3050408@xs4all.nl> <20150302110155.17c11cc7@recife.lan>
In-Reply-To: <20150302110155.17c11cc7@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 03/02/2015 03:01 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 27 Feb 2015 09:31:51 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> This patches fixes the following compilation warnings and errors if
>> CONFIG_MEDIA_CONTROLLER_DVB is not defined:
>>
>> drivers/media/common/siano/smsdvb-main.c: In function ‘smsdvb_media_device_unregister’:
>> drivers/media/common/siano/smsdvb-main.c:614:27: warning: unused variable ‘coredev’ [-Wunused-variable]
>>   struct smscore_device_t *coredev = client->coredev;
>>                            ^
>> drivers/media/common/siano/smsdvb-main.c: In function ‘smsdvb_hotplug’:
>> drivers/media/common/siano/smsdvb-main.c:1188:32: error: ‘struct smscore_device_t’ has no member named ‘media_dev’
>>   dvb_create_media_graph(coredev->media_dev);
>>                                 ^
>> drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_adapter_frontend_init’:
>> drivers/media/usb/dvb-usb/dvb-usb-dvb.c:323:39: error: ‘struct dvb_adapter’ has no member named ‘mdev’
>>   dvb_create_media_graph(adap->dvb_adap.mdev);
>>                                        ^
>> drivers/media/usb/dvb-usb/dvb-usb-dvb.c: At top level:
>> drivers/media/usb/dvb-usb/dvb-usb-dvb.c:97:13: warning: ‘dvb_usb_media_device_register’ defined but not used [-Wunused-function]
>>  static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
>>              ^
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_adapter_dvb_exit’:
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:531:25: warning: unused variable ‘d’ [-Wunused-variable]
>>   struct dvb_usb_device *d = adap_to_d(adap);
>>                          ^
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_adapter_frontend_init’:
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:705:39: error: ‘struct dvb_adapter’ has no member named ‘mdev’
>>   dvb_create_media_graph(adap->dvb_adap.mdev);
>>                                        ^
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: At top level:
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:403:13: warning: ‘dvb_usbv2_media_device_register’ defined but not used [-Wunused-function]
>>  static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
>>              ^
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
>> index dd3c151..28f764d 100644
>> --- a/drivers/media/common/siano/smsdvb-main.c
>> +++ b/drivers/media/common/siano/smsdvb-main.c
>> @@ -611,9 +611,9 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
>>  
>>  static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
>>  {
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  	struct smscore_device_t *coredev = client->coredev;
>>  
>> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  	if (!coredev->media_dev)
>>  		return;
>>  	media_device_unregister(coredev->media_dev);
>> @@ -1185,7 +1185,9 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
>>  	if (smsdvb_debugfs_create(client) < 0)
>>  		pr_info("failed to create debugfs node\n");
>>  
>> +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
>>  	dvb_create_media_graph(coredev->media_dev);
>> +#endif
> 
> Nah, adding more ifs here is not a good idea. I'll create a stub for 
> dvb_create_media_graph() if media controller is not found. I'll need to
> change the arguments, but this is likely needed anyway, in order to
> better support multi-adapter boards.

No problem. This was a quick 'n dirty patch to get things to compile :-)

Regards,

	Hans

> 
>>  
>>  	pr_info("DVB interface registered.\n");
>>  	return 0;
>> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
>> index 0666c8f..caf7fd9 100644
>> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
>> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
>> @@ -400,9 +400,9 @@ skip_feed_stop:
>>  	return ret;
>>  }
>>  
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
>>  {
>> -#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  	struct media_device *mdev;
>>  	struct dvb_usb_device *d = adap_to_d(adap);
>>  	struct usb_device *udev = d->udev;
>> @@ -433,8 +433,8 @@ static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
>>  
>>  	dev_info(&d->udev->dev, "media controller created\n");
>>  
>> -#endif
>>  }
>> +#endif
> 
> Nah, the best is to remove the "if" before calling 
> dvb_usbv2_media_device_register().
> 
> I have already two patches fixing the errors/warnings when compiling
> without the media controller.
> 
> I'll submit them in a few.
> 
> Thanks,
> Mauro
> 
>>  
>>  static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
>>  {
>> @@ -528,8 +528,6 @@ err_dvb_register_adapter:
>>  
>>  static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
>>  {
>> -	struct dvb_usb_device *d = adap_to_d(adap);
>> -
>>  	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
>>  			adap->id);
>>  
>> @@ -702,7 +700,9 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>>  		}
>>  	}
>>  
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  	dvb_create_media_graph(adap->dvb_adap.mdev);
>> +#endif
>>  
>>  	return 0;
>>  
>> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
>> index a7bc453..6020f46 100644
>> --- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
>> +++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
>> @@ -320,7 +320,9 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
>>  		adap->num_frontends_initialized++;
>>  	}
>>  
>> +#ifdef CONFIG_MEDIA_CONTROLLER_DVB
>>  	dvb_create_media_graph(adap->dvb_adap.mdev);
>> +#endif
>>  
>>  	return 0;
>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
