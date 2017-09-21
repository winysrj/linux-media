Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36204 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdIUNG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 09:06:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id r136so5178756wmf.3
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 06:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <47fa1e847d761e20c8d5c88701523abf7730f00d.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com> <47fa1e847d761e20c8d5c88701523abf7730f00d.1505933919.git.mchehab@s-opensource.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 21 Sep 2017 09:06:54 -0400
Message-ID: <CAOcJUbyoW9D8cyngc1VFpLLwOCPPqpzfhYEZ3n+nYyaLux4Hug@mail.gmail.com>
Subject: Re: [PATCH 03/25] media: dvbdev: convert DVB device types into an enum
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4sIEFyZU1hIEluYw==?=
        <knightrider@are.ma>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 20, 2017 at 3:11 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Enums can be documented via kernel-doc. So, convert the
> DVB_DEVICE_* macros to an enum.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-core/dvbdev.c | 34 +++++++++++++++++++++++----
>  drivers/media/dvb-core/dvbdev.h | 51 ++++++++++++++++++++++++++++-------------
>  2 files changed, 64 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 41aad0f99d73..7b4cdcfbb02c 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -51,8 +51,15 @@ static LIST_HEAD(dvb_adapter_list);
>  static DEFINE_MUTEX(dvbdev_register_lock);
>
>  static const char * const dnames[] = {
> -       "video", "audio", "sec", "frontend", "demux", "dvr", "ca",
> -       "net", "osd"
> +       [DVB_DEVICE_VIDEO] =            "video",
> +       [DVB_DEVICE_AUDIO] =            "audio",
> +       [DVB_DEVICE_SEC] =              "sec",
> +       [DVB_DEVICE_FRONTEND] =         "frontend",
> +       [DVB_DEVICE_DEMUX] =            "demux",
> +       [DVB_DEVICE_DVR] =              "dvr",
> +       [DVB_DEVICE_CA] =               "ca",
> +       [DVB_DEVICE_NET] =              "net",
> +       [DVB_DEVICE_OSD] =              "osd"
>  };
>
>  #ifdef CONFIG_DVB_DYNAMIC_MINORS
> @@ -60,7 +67,24 @@ static const char * const dnames[] = {
>  #define DVB_MAX_IDS            MAX_DVB_MINORS
>  #else
>  #define DVB_MAX_IDS            4
> -#define nums2minor(num, type, id)      ((num << 6) | (id << 4) | type)
> +
> +static int nums2minor(int num, enum dvb_device_type type, int id)
> +{
> +       int n = (num << 6) | (id << 4);
> +
> +       switch (type) {
> +       case DVB_DEVICE_VIDEO:          return n;
> +       case DVB_DEVICE_AUDIO:          return n | 1;
> +       case DVB_DEVICE_SEC:            return n | 2;
> +       case DVB_DEVICE_FRONTEND:       return n | 3;
> +       case DVB_DEVICE_DEMUX:          return n | 4;
> +       case DVB_DEVICE_DVR:            return n | 5;
> +       case DVB_DEVICE_CA:             return n | 6;
> +       case DVB_DEVICE_NET:            return n | 7;
> +       case DVB_DEVICE_OSD:            return n | 8;
> +       }
> +}
> +
>  #define MAX_DVB_MINORS         (DVB_MAX_ADAPTERS*64)
>  #endif
>
> @@ -426,8 +450,8 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
>  }
>
>  int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
> -                       const struct dvb_device *template, void *priv, int type,
> -                       int demux_sink_pads)
> +                       const struct dvb_device *template, void *priv,
> +                       enum dvb_device_type type, int demux_sink_pads)
>  {
>         struct dvb_device *dvbdev;
>         struct file_operations *dvbdevfops;
> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index 49189392cf3b..53058da83873 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -35,15 +35,37 @@
>
>  #define DVB_UNSET (-1)
>
> -#define DVB_DEVICE_VIDEO      0
> -#define DVB_DEVICE_AUDIO      1
> -#define DVB_DEVICE_SEC        2
> -#define DVB_DEVICE_FRONTEND   3
> -#define DVB_DEVICE_DEMUX      4
> -#define DVB_DEVICE_DVR        5
> -#define DVB_DEVICE_CA         6
> -#define DVB_DEVICE_NET        7
> -#define DVB_DEVICE_OSD        8
> +/* List of DVB device types */
> +
> +/**
> + * enum dvb_device_type - type of the Digital TV device
> + *
> + * @DVB_DEVICE_SEC:            Digital TV standalone Common Interface (CI)
> + * @DVB_DEVICE_FRONTEND:       Digital TV frontend.
> + * @DVB_DEVICE_DEMUX:          Digital TV demux.
> + * @DVB_DEVICE_DVR:            Digital TV digital video record (DVR).
> + * @DVB_DEVICE_CA:             Digital TV Conditional Access (CA).
> + * @DVB_DEVICE_NET:            Digital TV network.
> + *
> + * @DVB_DEVICE_VIDEO:          Digital TV video decoder.
> + *                             Deprecated. Used only on av7110-av.
> + * @DVB_DEVICE_AUDIO:          Digital TV audio decoder.
> + *                             Deprecated. Used only on av7110-av.
> + * @DVB_DEVICE_OSD:            Digital TV On Screen Display (OSD).
> + *                             Deprecated. Used only on av7110.
> + */
> +enum dvb_device_type {
> +       DVB_DEVICE_SEC,
> +       DVB_DEVICE_FRONTEND,
> +       DVB_DEVICE_DEMUX,
> +       DVB_DEVICE_DVR,
> +       DVB_DEVICE_CA,
> +       DVB_DEVICE_NET,
> +
> +       DVB_DEVICE_VIDEO,
> +       DVB_DEVICE_AUDIO,
> +       DVB_DEVICE_OSD,
> +};

maybe instead:
```
enum dvb_device_type {
 DVB_DEVICE_SEC      = 0,
 DVB_DEVICE_FRONTEND = 1,
 DVB_DEVICE_DEMUX    = 2,
 DVB_DEVICE_DVR      = 3,
 DVB_DEVICE_CA       = 4,
 DVB_DEVICE_NET      = 5,

 DVB_DEVICE_VIDEO    = 6,
 DVB_DEVICE_AUDIO    = 7,
 DVB_DEVICE_OSD      = 8,
};
```

...and then maybe `nums2minor()` can be optimized to take advantage of
that assignment.

>
>  #define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
>         static short adapter_nr[] = \
> @@ -104,8 +126,7 @@ struct dvb_adapter {
>   * @list_head: List head with all DVB devices
>   * @fops:      pointer to struct file_operations
>   * @adapter:   pointer to the adapter that holds this device node
> - * @type:      type of the device: DVB_DEVICE_SEC, DVB_DEVICE_FRONTEND,
> - *             DVB_DEVICE_DEMUX, DVB_DEVICE_DVR, DVB_DEVICE_CA, DVB_DEVICE_NET
> + * @type:      type of the device, as defined by &enum dvb_device_type.
>   * @minor:     devnode minor number. Major number is always DVB_MAJOR.
>   * @id:                device ID number, inside the adapter
>   * @readers:   Initialized by the caller. Each call to open() in Read Only mode
> @@ -135,7 +156,7 @@ struct dvb_device {
>         struct list_head list_head;
>         const struct file_operations *fops;
>         struct dvb_adapter *adapter;
> -       int type;
> +       enum dvb_device_type type;
>         int minor;
>         u32 id;
>
> @@ -194,9 +215,7 @@ int dvb_unregister_adapter(struct dvb_adapter *adap);
>   *             stored
>   * @template:  Template used to create &pdvbdev;
>   * @priv:      private data
> - * @type:      type of the device: %DVB_DEVICE_SEC, %DVB_DEVICE_FRONTEND,
> - *             %DVB_DEVICE_DEMUX, %DVB_DEVICE_DVR, %DVB_DEVICE_CA,
> - *             %DVB_DEVICE_NET
> + * @type:      type of the device, as defined by &enum dvb_device_type.
>   * @demux_sink_pads: Number of demux outputs, to be used to create the TS
>   *             outputs via the Media Controller.
>   */
> @@ -204,7 +223,7 @@ int dvb_register_device(struct dvb_adapter *adap,
>                         struct dvb_device **pdvbdev,
>                         const struct dvb_device *template,
>                         void *priv,
> -                       int type,
> +                       enum dvb_device_type type,
>                         int demux_sink_pads);
>
>  /**
> --
> 2.13.5
>
