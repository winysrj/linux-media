Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42453 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBXXNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 18:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LGkvxyPJK1YXMXc-4DV6TOM6RcpHthjmt3RLaCEnWVhg@mail.gmail.com>
References: <1392235552-28134-1-git-send-email-pengw@nvidia.com> <CAK5ve-LGkvxyPJK1YXMXc-4DV6TOM6RcpHthjmt3RLaCEnWVhg@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 24 Feb 2014 15:13:27 -0800
Message-ID: <CAK5ve-+UE1R-SYk0XDgg0kz+in8nyVseem=Rbe0VAiKc23b_aQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: soc-camera: OF cameras
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-tegra <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:40 AM, Bryan Wu <cooloney@gmail.com> wrote:
> On Wed, Feb 12, 2014 at 12:05 PM, Bryan Wu <cooloney@gmail.com> wrote:
>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>
>> With OF we aren't getting platform data any more. To minimise changes we
>> create all the missing data ourselves, including compulsory struct
>> soc_camera_link objects. Host-client linking is now done, based on the OF
>> data. Media bus numbers also have to be assigned dynamically.
>>
>> OF probing reuses the V4L2 Async API which is used by async non-OF probing.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> Hi Guennadi,
>
> Do you have chance to review my v2 patch?
>

>
>> Signed-off-by: Bryan Wu <pengw@nvidia.com>
>> ---
>> v2:
>>  - move to use V4L2 Async API
>>  - cleanup some coding style issue
>>  - allocate struct soc_camera_desc sdesc on stack
>>  - cleanup unbalanced mutex operation
>>
>>  drivers/media/platform/soc_camera/soc_camera.c | 232 ++++++++++++++++++++++++-
>>  include/media/soc_camera.h                     |   5 +
>>  2 files changed, 233 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index 4b8c024..ffe1254 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/list.h>
>>  #include <linux/module.h>
>>  #include <linux/mutex.h>
>> +#include <linux/of.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/regulator/consumer.h>
>> @@ -36,6 +37,7 @@
>>  #include <media/v4l2-common.h>
>>  #include <media/v4l2-ioctl.h>
>>  #include <media/v4l2-dev.h>
>> +#include <media/v4l2-of.h>
>>  #include <media/videobuf-core.h>
>>  #include <media/videobuf2-core.h>
>>
>> @@ -49,6 +51,7 @@
>>          vb2_is_streaming(&(icd)->vb2_vidq))
>>
>>  #define MAP_MAX_NUM 32
>> +static DECLARE_BITMAP(host_map, MAP_MAX_NUM);
>>  static DECLARE_BITMAP(device_map, MAP_MAX_NUM);
>>  static LIST_HEAD(hosts);
>>  static LIST_HEAD(devices);
>> @@ -65,6 +68,17 @@ struct soc_camera_async_client {
>>         struct list_head list;          /* needed for clean up */
>>  };
>>
>> +struct soc_camera_of_client {
>> +       struct soc_camera_desc *sdesc;
>> +       struct soc_camera_async_client sasc;
>> +       struct v4l2_of_endpoint node;
>> +       struct dev_archdata archdata;
>> +       struct device_node *link_node;
>> +       union {
>> +               struct i2c_board_info i2c_info;
>> +       };
>> +};
>> +
>>  static int soc_camera_video_start(struct soc_camera_device *icd);
>>  static int video_dev_create(struct soc_camera_device *icd);
>>
>> @@ -1336,6 +1350,10 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
>>                 return -EPROBE_DEFER;
>>         }
>>
>> +       /* OF probing skips following I2C init */
>> +       if (shd->host_wait)
>> +               return 0;
>> +
>>         ici = to_soc_camera_host(icd->parent);
>>         adap = i2c_get_adapter(shd->i2c_adapter_id);
>>         if (!adap) {
>> @@ -1573,10 +1591,180 @@ static void scan_async_host(struct soc_camera_host *ici)
>>                 asd += ici->asd_sizes[j];
>>         }
>>  }
>> +
>> +static void soc_camera_of_i2c_ifill(struct soc_camera_of_client *sofc,
>> +                                   struct i2c_client *client)
>> +{
>> +       struct i2c_board_info *info = &sofc->i2c_info;
>> +       struct soc_camera_desc *sdesc = sofc->sdesc;
>> +
>> +       /* on OF I2C devices platform_data == NULL */
>> +       info->flags = client->flags;
>> +       info->addr = client->addr;
>> +       info->irq = client->irq;
>> +       info->archdata = &sofc->archdata;
>> +
>> +       /* archdata is always empty on OF I2C devices */
>> +       strlcpy(info->type, client->name, sizeof(info->type));
>> +
>> +       sdesc->host_desc.i2c_adapter_id = client->adapter->nr;
>> +}
>> +
>> +static void soc_camera_of_i2c_info(struct device_node *node,
>> +                                  struct soc_camera_of_client *sofc)
>> +{
>> +       struct i2c_client *client;
>> +       struct soc_camera_desc *sdesc = sofc->sdesc;
>> +       struct i2c_board_info *info = &sofc->i2c_info;
>> +       struct device_node *port, *sensor, *bus;
>> +
>> +       port = v4l2_of_get_remote_port(node);
>> +       if (!port)
>> +               return;
>> +
>> +       /* Check the bus */
>> +       sensor = of_get_parent(port);
>> +       bus = of_get_parent(sensor);
>> +
>> +       if (of_node_cmp(bus->name, "i2c")) {
>> +               of_node_put(port);
>> +               of_node_put(sensor);
>> +               of_node_put(bus);
>> +               return;
>> +       }
>> +
>> +       info->of_node = sensor;
>> +       sdesc->host_desc.board_info = info;
>> +
>> +       client = of_find_i2c_device_by_node(sensor);
>> +       /*
>> +        * of_i2c_register_devices() took a reference to the OF node, it is not
>> +        * dropped, when the I2C device is removed, so, we don't need an
>> +        * additional reference.
>> +        */
>> +       of_node_put(sensor);
>> +       if (client) {
>> +               soc_camera_of_i2c_ifill(sofc, client);
>> +               sofc->link_node = sensor;
>> +               put_device(&client->dev);
>> +       }
>> +
>> +       /* client hasn't attached to I2C yet */
>> +}
>> +
>> +static struct soc_camera_of_client *soc_camera_of_alloc_client(const struct soc_camera_host *ici,
>> +                                                              struct device_node *node)
>> +{
>> +       struct soc_camera_of_client *sofc;
>> +       struct v4l2_async_subdev *sensor;
>> +       struct soc_camera_desc sdesc = { .host_desc.host_wait = true,};
>> +       int i, ret;
>> +
>> +       sofc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sofc), GFP_KERNEL);
>> +       if (!sofc)
>> +               return NULL;
>> +
>> +       /* Allocate v4l2_async_subdev by ourselves */
>> +       sensor = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sensor), GFP_KERNEL);
>> +       if (!sensor)
>> +               return NULL;
>> +       sofc->sasc.sensor = sensor;
>> +
>> +       mutex_lock(&list_lock);
>> +       i = find_first_zero_bit(device_map, MAP_MAX_NUM);
>> +       if (i < MAP_MAX_NUM)
>> +               set_bit(i, device_map);
>> +       mutex_unlock(&list_lock);
>> +       if (i >= MAP_MAX_NUM)
>> +               return NULL;
>> +       sofc->sasc.pdev = platform_device_alloc("soc-camera-pdrv", i);
>> +       if (!sofc->sasc.pdev)
>> +               return NULL;
>> +
>> +       sdesc.host_desc.node = &sofc->node;
>> +       sdesc.host_desc.bus_id = ici->nr;
>> +
>> +       ret = platform_device_add_data(sofc->sasc.pdev, &sdesc, sizeof(sdesc));
>> +       if (ret < 0)
>> +               return NULL;
>> +       sofc->sdesc = sofc->sasc.pdev->dev.platform_data;
>> +
>> +       soc_camera_of_i2c_info(node, sofc);
>> +
>> +       return sofc;
>> +}
>> +
>> +static void scan_of_host(struct soc_camera_host *ici)
>> +{
>> +       struct soc_camera_of_client *sofc;
>> +       struct soc_camera_async_client *sasc;
>> +       struct v4l2_async_subdev *asd;
>> +       struct soc_camera_device *icd;
>> +       struct device_node *node = NULL;
>> +
>> +       for (;;) {
>> +               int ret;
>> +
>> +               node = v4l2_of_get_next_endpoint(ici->v4l2_dev.dev->of_node,
>> +                                              node);
>> +               if (!node)
>> +                       break;
>> +
>> +               sofc = soc_camera_of_alloc_client(ici, node);
>> +               if (!sofc) {
>> +                       dev_err(ici->v4l2_dev.dev,
>> +                               "%s(): failed to create a client device\n",
>> +                               __func__);
>> +                       of_node_put(node);
>> +                       break;
>> +               }
>> +               v4l2_of_parse_endpoint(node, &sofc->node);
>> +
>> +               sasc = &sofc->sasc;
>> +               ret = platform_device_add(sasc->pdev);
>> +               if (ret < 0) {
>> +                       /* Useless thing, but keep trying */
>> +                       platform_device_put(sasc->pdev);
>> +                       of_node_put(node);
>> +                       continue;
>> +               }
>> +
>> +               /* soc_camera_pdrv_probe() probed successfully */
>> +               icd = platform_get_drvdata(sasc->pdev);
>> +               if (!icd) {
>> +                       /* Cannot be... */
>> +                       platform_device_put(sasc->pdev);
>> +                       of_node_put(node);
>> +                       continue;
>> +               }
>> +
>> +               asd = sasc->sensor;
>> +               asd->match_type = V4L2_ASYNC_MATCH_OF;
>> +               asd->match.of.node = sofc->link_node;
>> +
>> +               sasc->notifier.subdevs = &asd;
>> +               sasc->notifier.num_subdevs = 1;
>> +               sasc->notifier.bound = soc_camera_async_bound;
>> +               sasc->notifier.unbind = soc_camera_async_unbind;
>> +               sasc->notifier.complete = soc_camera_async_complete;
>> +
>> +               icd->parent = ici->v4l2_dev.dev;
>> +
>> +               ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
>> +               if (!ret)
>> +                       break;
>> +
>> +               /*
>> +                * We could destroy the icd in there error case here, but the
>> +                * non-OF version doesn't do that, so, we can keep it around too
>> +                */
>> +       }
>> +}
>>  #else
>>  #define soc_camera_i2c_init(icd, sdesc)        (-ENODEV)
>>  #define soc_camera_i2c_free(icd)       do {} while (0)
>>  #define scan_async_host(ici)           do {} while (0)
>> +#define scan_of_host(ici)              do {} while (0)
>>  #endif
>>
>>  /* Called during host-driver probe */
>> @@ -1689,6 +1877,7 @@ static int soc_camera_remove(struct soc_camera_device *icd)
>>  {
>>         struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
>>         struct video_device *vdev = icd->vdev;
>> +       struct v4l2_of_endpoint *node = sdesc->host_desc.node;
>>
>>         v4l2_ctrl_handler_free(&icd->ctrl_handler);
>>         if (vdev) {
>> @@ -1719,6 +1908,17 @@ static int soc_camera_remove(struct soc_camera_device *icd)
>>         if (icd->sasc)
>>                 platform_device_unregister(icd->sasc->pdev);
>>
>> +       if (node) {
>> +               struct soc_camera_of_client *sofc = container_of(node,
>> +                                       struct soc_camera_of_client, node);
>> +               /* Don't dead-lock: remove the device here under the lock */
>> +               clear_bit(sofc->sasc.pdev->id, device_map);
>> +               list_del(&icd->list);
>> +               if (sofc->link_node)
>> +                       of_node_put(sofc->link_node);
>> +               platform_device_unregister(sofc->sasc.pdev);
>> +       }
>> +
>>         return 0;
>>  }
>>
>> @@ -1813,17 +2013,34 @@ int soc_camera_host_register(struct soc_camera_host *ici)
>>                 ici->ops->enum_framesizes = default_enum_framesizes;
>>
>>         mutex_lock(&list_lock);
>> -       list_for_each_entry(ix, &hosts, list) {
>> -               if (ix->nr == ici->nr) {
>> +       if (ici->nr == (unsigned char)-1) {
>> +               /* E.g. OF host: dynamic number */
>> +               /* TODO: consider using IDR */
>> +               ici->nr = find_first_zero_bit(host_map, MAP_MAX_NUM);
>> +               if (ici->nr >= MAP_MAX_NUM) {
>>                         ret = -EBUSY;
>>                         goto edevreg;
>>                 }
>> +       } else {
>> +               if (ici->nr >= MAP_MAX_NUM) {
>> +                       ret = -EINVAL;
>> +                       goto edevreg;
>> +               }
>> +
>> +               list_for_each_entry(ix, &hosts, list) {
>> +                       if (ix->nr == ici->nr) {
>> +                               ret = -EBUSY;
>> +                               goto edevreg;
>> +                       }
>> +               }
>>         }
>>
>>         ret = v4l2_device_register(ici->v4l2_dev.dev, &ici->v4l2_dev);
>>         if (ret < 0)
>>                 goto edevreg;
>>
>> +       set_bit(ici->nr, host_map);
>> +
>>         list_add_tail(&ici->list, &hosts);
>>         mutex_unlock(&list_lock);
>>
>> @@ -1837,9 +2054,11 @@ int soc_camera_host_register(struct soc_camera_host *ici)
>>                  * dynamically!
>>                  */
>>                 scan_async_host(ici);
>> -       else
>> +       else if (!ici->v4l2_dev.dev->of_node)
>>                 /* Legacy: static platform devices from board data */
>>                 scan_add_host(ici);
>> +       else    /* Scan subdevices from OF info */
>> +               scan_of_host(ici);
>>
>>         return 0;
>>
>> @@ -1857,6 +2076,8 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
>>         LIST_HEAD(notifiers);
>>
>>         mutex_lock(&list_lock);
>> +
>> +       clear_bit(ici->nr, host_map);
>>         list_del(&ici->list);
>>         list_for_each_entry(icd, &devices, list)
>>                 if (icd->iface == ici->nr && icd->sasc) {
>> @@ -1875,7 +2096,10 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
>>         mutex_lock(&list_lock);
>>
>>         list_for_each_entry_safe(icd, tmp, &devices, list)
>> -               if (icd->iface == ici->nr)
>> +               if (icd->iface == ici->nr &&
>> +                   icd->parent == ici->v4l2_dev.dev &&
>> +                   (to_soc_camera_control(icd) ||
>> +                       icd->sdesc->host_desc.host_wait))
>>                         soc_camera_remove(icd);
>>
>>         mutex_unlock(&list_lock);
>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>> index 865246b..06b03b1 100644
>> --- a/include/media/soc_camera.h
>> +++ b/include/media/soc_camera.h
>> @@ -138,6 +138,7 @@ struct soc_camera_host_ops {
>>
>>  struct i2c_board_info;
>>  struct regulator_bulk_data;
>> +struct v4l2_of_endpoint;
>>
>>  struct soc_camera_subdev_desc {
>>         /* Per camera SOCAM_SENSOR_* bus flags */
>> @@ -177,7 +178,9 @@ struct soc_camera_host_desc {
>>         int bus_id;
>>         int i2c_adapter_id;
>>         struct i2c_board_info *board_info;
>> +       struct v4l2_of_endpoint *node;
>>         const char *module_name;
>> +       bool host_wait;
>>
>>         /*
>>          * For non-I2C devices platform has to provide methods to add a device
>> @@ -242,7 +245,9 @@ struct soc_camera_link {
>>         int bus_id;
>>         int i2c_adapter_id;
>>         struct i2c_board_info *board_info;
>> +       struct v4l2_of_endpoint *node;
>>         const char *module_name;
>> +       bool host_wait;
>>
>>         /*
>>          * For non-I2C devices platform has to provide methods to add a device
>> --
>> 1.8.3.2
>>


I have to ping it again.

-Bryan
