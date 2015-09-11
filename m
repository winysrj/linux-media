Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35575 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbbIKHbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 03:31:45 -0400
Subject: Re: [PATCH 2/2] [media] media-device: split media initialization and
 registration
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-kernel@vger.kernel.org
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
 <1441890195-11650-3-git-send-email-javier@osg.samsung.com>
 <55F1BA5C.50508@linux.intel.com> <55F1CC72.6000204@osg.samsung.com>
 <55F26BDF.8050600@linux.intel.com>
Cc: Luis de Bethencourt <luis@debethencourt.com>,
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
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <55F28358.1070007@osg.samsung.com>
Date: Fri, 11 Sep 2015 09:31:36 +0200
MIME-Version: 1.0
In-Reply-To: <55F26BDF.8050600@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 09/11/2015 07:51 AM, Sakari Ailus wrote:
> Hi Javier,
> 
> Javier Martinez Canillas wrote:
>> Hello Sakari,
>>
>> On 09/10/2015 07:14 PM, Sakari Ailus wrote:
>>> Hi Javier,
>>>
>>> Thanks for the set! A few comments below.
>>>
>>
>> Thanks to you for your feedback.
>>
>>> Javier Martinez Canillas wrote:
>>>> The media device node is registered and so made visible to user-space
>>>> before entities are registered and links created which means that the
>>>> media graph obtained by user-space could be only partially enumerated
>>>> if that happens too early before all the graph has been created.
>>>>
>>>> To avoid this race condition, split the media init and registration
>>>> in separate functions and only register the media device node when
>>>> all the pending subdevices have been registered, either explicitly
>>>> by the driver or asynchronously using v4l2_async_register_subdev().
>>>>
>>>> Also, add a media_entity_cleanup() function that will destroy the
>>>> graph_mutex that is initialized in media_entity_init().
>>>>
>>>> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>
>>>> ---
>>>>
>>>>   drivers/media/common/siano/smsdvb-main.c      |  1 +
>>>>   drivers/media/media-device.c                  | 38 +++++++++++++++++++++++----
>>>>   drivers/media/platform/exynos4-is/media-dev.c | 12 ++++++---
>>>>   drivers/media/platform/omap3isp/isp.c         | 11 +++++---
>>>>   drivers/media/platform/s3c-camif/camif-core.c | 13 ++++++---
>>>>   drivers/media/platform/vsp1/vsp1_drv.c        | 19 ++++++++++----
>>>>   drivers/media/platform/xilinx/xilinx-vipp.c   | 11 +++++---
>>>>   drivers/media/usb/au0828/au0828-core.c        | 26 +++++++++++++-----
>>>>   drivers/media/usb/cx231xx/cx231xx-cards.c     | 22 +++++++++++-----
>>>>   drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 11 +++++---
>>>>   drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 13 ++++++---
>>>>   drivers/media/usb/siano/smsusb.c              | 14 ++++++++--
>>>>   drivers/media/usb/uvc/uvc_driver.c            |  9 +++++--
>>>>   include/media/media-device.h                  |  2 ++
>>>>   14 files changed, 156 insertions(+), 46 deletions(-)
>>>>
>>>> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
>>>> index ab345490a43a..8a1ea2192439 100644
>>>> --- a/drivers/media/common/siano/smsdvb-main.c
>>>> +++ b/drivers/media/common/siano/smsdvb-main.c
>>>> @@ -617,6 +617,7 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
>>>>       if (!coredev->media_dev)
>>>>           return;
>>>>       media_device_unregister(coredev->media_dev);
>>>> +    media_device_cleanup(coredev->media_dev);
>>>>       kfree(coredev->media_dev);
>>>>       coredev->media_dev = NULL;
>>>>   #endif
>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>> index 745defb34b33..a8beb0b445a6 100644
>>>> --- a/drivers/media/media-device.c
>>>> +++ b/drivers/media/media-device.c
>>>> @@ -526,7 +526,7 @@ static void media_device_release(struct media_devnode *mdev)
>>>>   }
>>>>
>>>>   /**
>>>> - * media_device_register - register a media device
>>>> + * media_device_init() - initialize a media device
>>>>    * @mdev:    The media device
>>>>    *
>>>>    * The caller is responsible for initializing the media device before
>>>> @@ -534,12 +534,11 @@ static void media_device_release(struct media_devnode *mdev)
>>>>    *
>>>>    * - dev must point to the parent device
>>>>    * - model must be filled with the device model name
>>>> + *
>>>> + * returns zero on success or a negative error code.
>>>>    */
>>>> -int __must_check __media_device_register(struct media_device *mdev,
>>>> -                     struct module *owner)
>>>> +int __must_check media_device_init(struct media_device *mdev)
>>>
>>> I think I suggested making media_device_init() return void as the only
>>> remaining source of errors would be driver bugs.
>>>
>>
>> Yes you did and I think I explained why I preferred to leave it as
>> is and I thought we agreed :)
> 
> I thought we agreed, too. But my understanding was that the agreement was different. ;-)
>

Fair enough :)
 
>>
>> Currently media_device_register() is failing gracefully if a buggy
>> driver is not setting mdev->dev. So changing media_device_init() to
>> return void instead, would be a semantic change and if drivers are
>> not checking that anymore, can lead to NULL pointer dereference bugs.
> 
> Do we have such drivers? Would they ever have worked in the first place, as media device registration would have failed?
>

Most likely we don't but since I'm changing all the drivers anyways, I'll
take a look and change to void and propose a fix if I find something but
it seems is just that the function is checking a condition that would not
happen with the in-tree media drivers.

I'll change to void and remove the return value check in drivers for v2.
 
>>
>>> I'd simply replace the WARN_ON() below with BUG().
>>>
>>
>> Sorry but I disagree, I think that BUG() should only be used for
>> exceptional cases in which execution can't really continue without
>> causing data corruption or something like that, so bringing down
>> the machine is the safest and least bad option.
> 
> I think it's also fine to use that for basic sanity checks on code paths that will be run early and every time.
>

I still think that causing a panic when it could had be avoided is
pretty harsh. And is not only me, even Linus thinks the same:

https://lkml.org/lkml/2015/6/24/662
 
> To support what I'm saying, just do this:
> 
>     $ grep BUG_ON drivers/media/v4l2-core/*
> 
> Even though most of that is in videobuf, V4L2 core does that, too, and there's a case of especially delicious usage in v4l2_subdev_init(). :-)
>

Yes, but I do wonder how many of those are really necessary and if
most need to be converted to WARN_ON() and return an error instead...

>>
>> But that's not the case here, if there is a buggy driver then the
>> worst thing that would happen is that a driver probe function is
>> going to fail. It is true that drivers may not be cheking this but
>> that's why is annotated with __must_check.
> 
> I still maintain it makes no sense to build error handling in drivers if the only source of error would be bad parameters specified by a driver to a function.
>
> The driver could also pass a dangling pointer to the function as well, and you couldn't find out.

You convinced me, then I think we should remove the check altogether
(not keeping it and changing it to BUG_ON) do you agree with that?

> 
>>
>>>>   {
>>>> -    int ret;
>>>> -
>>>>       if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
>>>>           return -EINVAL;
>>>>
>>
>> We can later audit all drivers and change this function to return
>> void instead and get rid of this check but I would prefer to do it
>> as a followup patch.
> 
> As this patch essentially moves media_device_register() elsewhere and puts media_device_init() in its place, the driver error handling is mostly unaffected in that very location.
> 
> I'm fine with the approach, although I don't think we'll need much auditing; such drivers would never have functioned in the first place.
>

Yes, but the difference is that by checking and returning an error, such drivers
that were not working (probably there even isn't such a driver) would had
failed to probe but by removing the check, it could now cause a NULL pointer
dereference. That's why we need to audit to be sure that there isn't a buggy one.
 
>>
>>>> @@ -550,6 +549,35 @@ int __must_check __media_device_register(struct media_device *mdev,
>>>>       spin_lock_init(&mdev->lock);
>>>>       mutex_init(&mdev->graph_mutex);
>>>>
>>>> +    dev_dbg(mdev->dev, "Media device initialized\n");
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(media_device_init);
>>>> +
>>>> +/**
>>>> + * media_device_cleanup() - Cleanup a media device
>>>> + * @mdev:    The media device
>>>> + *
>>>> + */
>>>> +void media_device_cleanup(struct media_device *mdev)
>>>> +{
>>>> +    mutex_destroy(&mdev->graph_mutex);
>>>
>>> Very nice!
>>>
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(media_device_cleanup);
>>>> +
>>>> +/**
>>>> + * __media_device_register() - register a media device
>>>> + * @mdev:    The media device
>>>> + * @owner:    The module owner
>>>> + *
>>>> + * returns zero on success or a negative error code.
>>>> + */
>>>> +int __must_check __media_device_register(struct media_device *mdev,
>>>> +                     struct module *owner)
>>>> +{
>>>> +    int ret;
>>>> +
>>>>       /* Register the device node. */
>>>>       mdev->devnode.fops = &media_device_fops;
>>>>       mdev->devnode.parent = mdev->dev;
>>>> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
>>>> index 4a25df9dd869..158738bd23fc 100644
>>>> --- a/drivers/media/platform/exynos4-is/media-dev.c
>>>> +++ b/drivers/media/platform/exynos4-is/media-dev.c
>>>> @@ -1313,7 +1313,10 @@ static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
>>>>       ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
>>>>   unlock:
>>>>       mutex_unlock(&fmd->media_dev.graph_mutex);
>>>> -    return ret;
>>>> +    if (ret < 0)
>>>> +        return ret;
>>>> +
>>>> +    return media_device_register(&fmd->media_dev);
>>>
>>> Uh-oh.
>>>
>>> I guess it's fair to simply fail here. probe() is already over so I
>>> wonder if there's anything we could really do except await someone
>>> unloading and loading the module again? Or, replugging the hardware.
>>>
>>
>> Yes, in fact I noticed the same. The problem is that drivers that
>> register a notifier with v4l2_async_notifier_register(), don't know if
>> a complete callback (or bound callback FWIW) failed. Only the subdev
>> driver knows that something failed when it tried to register a subdev
>> asynchronously with v4l2_async_register_subdev().
>>
>>> I don't like the idea but I guess this could be solved later on.
>>>
>>
>> Yes me neither but since v4l2_device_register_subdev_nodes() can also
>> fail and the return value was returned to v4l2_async_test_notify(), I
>> decided to do the same when adding the call to media_device_register().
>>
>> But I agree that this should be fixed somehow, either making all drivers
>> do cleanup if either the bound or complete notifier callbacks fail or
>> the v4l2-async core should call a cleanup function that is registered by
>> the drivers.
>>
>> But as you said I also think this could be solved later on since it's a
>> separate issue IMHO.
> 
> Agreed.
> 
>>>>   }
>>>>
>>>>   static int fimc_md_probe(struct platform_device *pdev)
>>>> @@ -1350,9 +1353,9 @@ static int fimc_md_probe(struct platform_device *pdev)
>>>>           return ret;
>>>>       }
>>>>
>>>> -    ret = media_device_register(&fmd->media_dev);
>>>> +    ret = media_device_init(&fmd->media_dev);
>>>>       if (ret < 0) {
>>>> -        v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
>>>> +        v4l2_err(v4l2_dev, "Failed to init media device: %d\n", ret);
>>>>           goto err_v4l2_dev;
>>>>       }
>>>>
>>>> @@ -1424,7 +1427,7 @@ err_clk:
>>>>   err_m_ent:
>>>>       fimc_md_unregister_entities(fmd);
>>>>   err_md:
>>>> -    media_device_unregister(&fmd->media_dev);
>>>> +    media_device_cleanup(&fmd->media_dev);
>>>>   err_v4l2_dev:
>>>>       v4l2_device_unregister(&fmd->v4l2_dev);
>>>>       return ret;
>>>> @@ -1445,6 +1448,7 @@ static int fimc_md_remove(struct platform_device *pdev)
>>>>       fimc_md_unregister_entities(fmd);
>>>>       fimc_md_pipelines_free(fmd);
>>>>       media_device_unregister(&fmd->media_dev);
>>>> +    media_device_cleanup(&fmd->media_dev);
>>>>       fimc_md_put_clocks(fmd);
>>>>
>>>>       return 0;
>>>> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
>>>> index cb8ac90086c1..b7eda3043c31 100644
>>>> --- a/drivers/media/platform/omap3isp/isp.c
>>>> +++ b/drivers/media/platform/omap3isp/isp.c
>>>> @@ -1793,6 +1793,7 @@ static void isp_unregister_entities(struct isp_device *isp)
>>>>
>>>>       v4l2_device_unregister(&isp->v4l2_dev);
>>>>       media_device_unregister(&isp->media_dev);
>>>> +    media_device_cleanup(&isp->media_dev);
>>>>   }
>>>>
>>>>   static int isp_link_entity(
>>>> @@ -1875,9 +1876,9 @@ static int isp_register_entities(struct isp_device *isp)
>>>>           sizeof(isp->media_dev.model));
>>>>       isp->media_dev.hw_revision = isp->revision;
>>>>       isp->media_dev.link_notify = isp_pipeline_link_notify;
>>>> -    ret = media_device_register(&isp->media_dev);
>>>> +    ret = media_device_init(&isp->media_dev);
>>>>       if (ret < 0) {
>>>> -        dev_err(isp->dev, "%s: Media device registration failed (%d)\n",
>>>> +        dev_err(isp->dev, "%s: Media device init failed (%d)\n",
>>>>               __func__, ret);
>>>>           return ret;
>>>>       }
>>>> @@ -2347,7 +2348,11 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>>>>           }
>>>>       }
>>>>
>>>> -    return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
>>>> +    ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
>>>> +    if (ret < 0)
>>>> +        return ret;
>>>> +
>>>> +    return media_device_register(&isp->media_dev);
>>>>   }
>>>>
>>>>   /*
>>>> diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
>>>> index 3e33c60be004..1428db2f804d 100644
>>>> --- a/drivers/media/platform/s3c-camif/camif-core.c
>>>> +++ b/drivers/media/platform/s3c-camif/camif-core.c
>>>> @@ -305,7 +305,7 @@ static void camif_unregister_media_entities(struct camif_dev *camif)
>>>>   /*
>>>>    * Media device
>>>>    */
>>>> -static int camif_media_dev_register(struct camif_dev *camif)
>>>> +static int camif_media_dev_init(struct camif_dev *camif)
>>>>   {
>>>>       struct media_device *md = &camif->media_dev;
>>>>       struct v4l2_device *v4l2_dev = &camif->v4l2_dev;
>>>> @@ -328,7 +328,7 @@ static int camif_media_dev_register(struct camif_dev *camif)
>>>>       if (ret < 0)
>>>>           return ret;
>>>>
>>>> -    ret = media_device_register(md);
>>>> +    ret = media_device_init(md);
>>>>       if (ret < 0)
>>>>           v4l2_device_unregister(v4l2_dev);
>>>>
>>>> @@ -483,7 +483,7 @@ static int s3c_camif_probe(struct platform_device *pdev)
>>>>           goto err_alloc;
>>>>       }
>>>>
>>>> -    ret = camif_media_dev_register(camif);
>>>> +    ret = camif_media_dev_init(camif);
>>>>       if (ret < 0)
>>>>           goto err_mdev;
>>>>
>>>> @@ -510,6 +510,11 @@ static int s3c_camif_probe(struct platform_device *pdev)
>>>>           goto err_unlock;
>>>>
>>>>       mutex_unlock(&camif->media_dev.graph_mutex);
>>>> +
>>>> +    ret = media_device_register(&camif->media_dev);
>>>> +    if (ret < 0)
>>>> +        goto err_sens;
>>>> +
>>>>       pm_runtime_put(dev);
>>>>       return 0;
>>>>
>>>> @@ -518,6 +523,7 @@ err_unlock:
>>>>   err_sens:
>>>>       v4l2_device_unregister(&camif->v4l2_dev);
>>>>       media_device_unregister(&camif->media_dev);
>>>> +    media_device_cleanup(&camif->media_dev);
>>>>       camif_unregister_media_entities(camif);
>>>>   err_mdev:
>>>>       vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
>>>> @@ -539,6 +545,7 @@ static int s3c_camif_remove(struct platform_device *pdev)
>>>>       struct s3c_camif_plat_data *pdata = &camif->pdata;
>>>>
>>>>       media_device_unregister(&camif->media_dev);
>>>> +    media_device_cleanup(&camif->media_dev);
>>>>       camif_unregister_media_entities(camif);
>>>>       v4l2_device_unregister(&camif->v4l2_dev);
>>>>
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
>>>> index 8f995d267646..bcbc24e55bf5 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>>>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>>>> @@ -127,6 +127,7 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
>>>>
>>>>       v4l2_device_unregister(&vsp1->v4l2_dev);
>>>>       media_device_unregister(&vsp1->media_dev);
>>>> +    media_device_cleanup(&vsp1->media_dev);
>>>>   }
>>>>
>>>>   static int vsp1_create_entities(struct vsp1_device *vsp1)
>>>> @@ -141,9 +142,9 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>>>>       strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
>>>>       snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
>>>>            dev_name(mdev->dev));
>>>> -    ret = media_device_register(mdev);
>>>> +    ret = media_device_init(mdev);
>>>>       if (ret < 0) {
>>>> -        dev_err(vsp1->dev, "media device registration failed (%d)\n",
>>>> +        dev_err(vsp1->dev, "media device init failed (%d)\n",
>>>>               ret);
>>>>           return ret;
>>>>       }
>>>> @@ -288,11 +289,19 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>>>>       }
>>>>
>>>>       ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
>>>> -
>>>> -done:
>>>>       if (ret < 0)
>>>> -        vsp1_destroy_entities(vsp1);
>>>> +        goto done;
>>>>
>>>> +    ret = media_device_register(mdev);
>>>
>>> Are there cases where media_device_register() won't complain aloud
>>> already? I wouldn't print an error message in a driver anymore.
>>>
>>
>> Good question, there are already error messages printed if the media dev
>> node fails to be registered or sysfs attribute file fails to be created.
>>
>> What I did is to follow the convention used on each driver and added an
>> error message for both media_device_init() and media_device_register()
>> if the driver already had one for the old media_device_register() and
>> didn't if the driver was not doing it.
>>
>>>> +    if (ret < 0) {
>>>> +        dev_err(vsp1->dev, "media device init failed (%d)\n", ret);
>>>> +        goto done;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +
>>>> +done:
>>>> +    vsp1_destroy_entities(vsp1);
>>>>       return ret;
>>>>   }
>>>>
>>>> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
>>>> index 79d4be7ce9a5..5bb18aee0707 100644
>>>> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
>>>> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
>>>> @@ -311,6 +311,10 @@ static int xvip_graph_notify_complete(struct v4l2_async_notifier *notifier)
>>>>       if (ret < 0)
>>>>           dev_err(xdev->dev, "failed to register subdev nodes\n");
>>>>
>>>> +    ret = media_device_register(&xdev->media_dev);
>>>
>>> Same here (and elsewhere).
>>>
>>
>> I don't have a strong opinion, if you think that is better to remove
>> the error messages, I can do it when re-spining the patches.
> 
> I'd be in favour of removing them. If the framework already complains about it, there's no reason to do the same in drivers.
> 

Ok, I'll remove the error messages from the drivers then on v2.

Thanks a lot for your feedback!

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
