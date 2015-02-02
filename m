Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36102 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbBBHSq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 02:18:46 -0500
Received: by mail-wg0-f44.google.com with SMTP id z12so37010652wgg.3
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2015 23:18:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1502011527510.14164@axis700.grange>
References: <1422345327-27843-1-git-send-email-kassey1216@gmail.com>
	<Pine.LNX.4.64.1502011527510.14164@axis700.grange>
Date: Mon, 2 Feb 2015 15:18:44 +0800
Message-ID: <CAKwPUoxEZEsmbUK2D6=LVAnhZzOWHS0Oi=uBhw7Lc3+-ppyzyQ@mail.gmail.com>
Subject: Re: [PATCH V1] [media] V4L: soc-camera: add SPI device support
From: Kassey <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Li <kasseyl@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-02-01 23:27 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi Kassey,
>
> Thanks for the patch. Do I understand it right, that this patch only
> supports SPI subdevices, supplied in platform data, no support for
> asynchronous SPI clients / DT? Does your platform not support DT?
>
   yes, we support DT, add DT in patch V2 later for your to review.
> I'm not an expert in SPI, so, not really sure how correct is the use of
> the SPI API here.
>
   I have a sony sensor which is spi interface, verified on kernel-3.10

> On Tue, 27 Jan 2015, Kassey Li wrote:
>
>> From: Kassey Li <kasseyl@nvidia.com>
>>
>> This adds support for spi interface sub device for
>> soc_camera.
>>
>> Signed-off-by: Kassey Li <kasseyl@nvidia.com>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c |   51 ++++++++++++++++++++++++
>>  include/media/soc_camera.h                     |   10 +++++
>>  2 files changed, 61 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index b3db51c..6db2d89 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -1599,6 +1599,49 @@ static void scan_async_host(struct soc_camera_host *ici)
>>  #define soc_camera_i2c_free(icd)     do {} while (0)
>>  #define scan_async_host(ici)         do {} while (0)
>>  #endif
>> +static int soc_camera_init_spi(struct soc_camera_device *icd,
>> +             struct soc_camera_desc *sdesc)
>
> The rest of the file _mostly_ uses a different line-breaking style, but...
> This isn't completely incompatible with the rest, so, I wouldn't insist on
> changing this, probably. Just to explain, normally in this file alignment
> is performed in theform
>
>         ret = func(a, b, c,
>                    d, e);
>
> i.e. first TABs are used and then spaces to align, say, under the first
> argument in this case. If, however, this alignment style would make the
> second line too long, then yes, additional spaces and, possibly, one or
> more TABs are removed. So, at least this kinf of alignment
>
>         ret = func(a, b, c,
>                         d, e);
>
> is never used... But, as I said, up to you, would be nice to have a
> somewhat better style compliance.
>
>> +{
>> +     struct spi_device   *spi;
>
> Please, just one space.
>
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +     struct soc_camera_host_desc *shd = &sdesc->host_desc;
>> +     struct spi_master *spi_master =
>> +                     spi_busnum_to_master(shd->spi_bus_id);
>
> You certainly need an additional header for this and other SPI macros,
> functions and types.
>
>> +     struct v4l2_subdev *subdev;
>> +
>> +     if (!spi_master) {
>> +             dev_err(icd->pdev, "Cannot get spi master #%d. No driver?\n",
>> +                             shd->spi_bus_id);
>
> This is the kind of alignment, that this file otherwise doesn't use. Just
> removing one TAB above would already make it look more consistent:)
>
>> +             goto espind;
>
> You can just return here.
>
>> +     }
>> +
>> +     shd->board_info_spi->platform_data = &sdesc->subdev_desc;
>> +
>> +     subdev = v4l2_spi_new_subdev(&ici->v4l2_dev, spi_master,
>> +                     shd->board_info_spi);
>> +     if (!subdev)
>> +             goto espind;
>
> Comparing to the I2C subdevice initialisation, this version is lacking
> regulator and clock support... Is it not needed?
>
>> +
>> +     spi = v4l2_get_subdevdata(subdev);
>> +
>> +     /* Use to_i2c_client(dev) to recover the i2c client */
>> +     icd->control = &spi->dev;
>> +
>> +     return 0;
>> +espind:
>> +     return -ENODEV;
>> +}
>> +
>> +static void soc_camera_free_spi(struct soc_camera_device *icd)
>> +{
>> +     struct spi_device   *spi;
>> +     struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +
>> +     spi = v4l2_get_subdevdata(sd);
>> +     icd->control = NULL;
>> +     v4l2_device_unregister_subdev(sd);
>> +     spi_unregister_device(spi);
>> +}
>>
>>  #ifdef CONFIG_OF
>>
>> @@ -1762,6 +1805,10 @@ static int soc_camera_probe(struct soc_camera_host *ici,
>>               ret = soc_camera_i2c_init(icd, sdesc);
>>               if (ret < 0 && ret != -EPROBE_DEFER)
>>                       goto eadd;
>> +     } else if (shd->board_info_spi) {
>> +               ret = soc_camera_init_spi(icd, sdesc);
>> +               if (ret < 0)
>> +                       goto eadd;
>>       } else if (!shd->add_device || !shd->del_device) {
>>               ret = -EINVAL;
>>               goto eadd;
>> @@ -1803,6 +1850,8 @@ static int soc_camera_probe(struct soc_camera_host *ici,
>>  efinish:
>>       if (shd->board_info) {
>>               soc_camera_i2c_free(icd);
>> +     } else if (shd->board_info_spi) {
>> +             soc_camera_free_spi(icd);
>>       } else {
>>               shd->del_device(icd);
>>               module_put(control->driver->owner);
>> @@ -1843,6 +1892,8 @@ static int soc_camera_remove(struct soc_camera_device *icd)
>>
>>       if (sdesc->host_desc.board_info) {
>>               soc_camera_i2c_free(icd);
>> +     } else if (sdesc->host_desc.board_info_spi) {
>> +             soc_camera_free_spi(icd);
>>       } else {
>>               struct device *dev = to_soc_camera_control(icd);
>>               struct device_driver *drv = dev ? dev->driver : NULL;
>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>> index 2f6261f..7530893 100644
>> --- a/include/media/soc_camera.h
>> +++ b/include/media/soc_camera.h
>> @@ -178,6 +178,11 @@ struct soc_camera_host_desc {
>>       int i2c_adapter_id;
>>       struct i2c_board_info *board_info;
>>       const char *module_name;
>> +     /*
>> +      * Add SPI device support.
>> +      */
>
> This comment documents an action of "adding" SPI support, which isn't
> interesting in the long run. It doesn't provide any additional information
> about the code. Please, remove.
>
>> +     struct spi_board_info *board_info_spi;
>> +     int spi_bus_id;
>>
>>       /*
>>        * For non-I2C devices platform has to provide methods to add a device
>> @@ -243,6 +248,11 @@ struct soc_camera_link {
>>       int i2c_adapter_id;
>>       struct i2c_board_info *board_info;
>>       const char *module_name;
>> +     /*
>> +      * Add SPI device support.
>> +      */
>
> Ditto, just remove it.
>
>> +     struct spi_board_info *board_info_spi;
>> +     int spi_bus_id;
>
> [OT] This reminds me... This struct has to be removed...
>
>>
>>       /*
>>        * For non-I2C devices platform has to provide methods to add a device
>> --
>> 1.7.9.5
>>
>
> Thanks
> Guennadi



-- 
Best regards
Kassey
