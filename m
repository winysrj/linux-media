Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35255 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754874AbdDRKNR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 06:13:17 -0400
Received: by mail-qk0-f172.google.com with SMTP id f133so125570051qke.2
        for <linux-media@vger.kernel.org>; Tue, 18 Apr 2017 03:13:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170418084601.1590-2-hverkuil@xs4all.nl>
References: <20170418084601.1590-1-hverkuil@xs4all.nl> <20170418084601.1590-2-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 18 Apr 2017 12:13:15 +0200
Message-ID: <CA+M3ks5gXEDDLsKAHPD4EcHJSH+YNPFLr+V6HzNTPoDh6ZPW0Q@mail.gmail.com>
Subject: Re: [PATCH for v4.12 1/3] cec: Kconfig cleanup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-04-18 10:45 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The Kconfig options for the CEC subsystem were a bit messy. In
> addition there were two cec sources (cec-edid.c and cec-notifier.c)
> that were outside of the media/cec directory, which was weird.
>
> Move those sources to media/cec as well.
>
> The cec-edid and cec-notifier functionality is now part of the cec
> module and these are no longer separate modules.
>
> Also remove the MEDIA_CEC_EDID config option and include it with the
> main CEC config option (which defined CEC_EDID anyway).
>
> Added static inlines to cec-edid.h for dummy functions when CEC_CORE
> isn't defined.
>
> CEC drivers should now depend on CEC_CORE.
>
> CEC drivers that need the cec-notifier functionality must explicitly
> select CEC_NOTIFIER.
>
> The s5p-cec and stih-cec drivers depended on VIDEO_DEV instead of
> CEC_CORE, fix that as well.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for this clean up.

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

> ---
>  MAINTAINERS                              |  2 --
>  drivers/media/Kconfig                    | 26 ++++-----------
>  drivers/media/Makefile                   | 14 ++------
>  drivers/media/cec/Kconfig                | 13 ++++++++
>  drivers/media/cec/Makefile               |  8 +++--
>  drivers/media/{ =3D> cec}/cec-edid.c       |  4 ---
>  drivers/media/{ =3D> cec}/cec-notifier.c   |  0
>  drivers/media/i2c/Kconfig                |  9 ++---
>  drivers/media/platform/Kconfig           | 56 ++++++++++++++++----------=
------
>  drivers/media/platform/vivid/Kconfig     |  3 +-
>  drivers/media/usb/pulse8-cec/Kconfig     |  2 +-
>  drivers/media/usb/rainshadow-cec/Kconfig |  2 +-
>  include/media/cec-edid.h                 | 29 +++++++++++++++++
>  include/media/cec.h                      |  2 +-
>  14 files changed, 91 insertions(+), 79 deletions(-)
>  create mode 100644 drivers/media/cec/Kconfig
>  rename drivers/media/{ =3D> cec}/cec-edid.c (97%)
>  rename drivers/media/{ =3D> cec}/cec-notifier.c (100%)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7d3b9993e4ba..1b0049934cf9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3075,8 +3075,6 @@ S:        Supported
>  F:     Documentation/media/kapi/cec-core.rst
>  F:     Documentation/media/uapi/cec
>  F:     drivers/media/cec/
> -F:     drivers/media/cec-edid.c
> -F:     drivers/media/cec-notifier.c
>  F:     drivers/media/rc/keymaps/rc-cec.c
>  F:     include/media/cec.h
>  F:     include/media/cec-edid.h
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 9e9ded44e8a8..b72edd27f880 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -81,27 +81,15 @@ config MEDIA_RC_SUPPORT
>           Say Y when you have a TV or an IR device.
>
>  config MEDIA_CEC_SUPPORT
> -       bool "HDMI CEC support"
> -       select MEDIA_CEC_EDID
> -       ---help---
> -         Enable support for HDMI CEC (Consumer Electronics Control),
> -         which is an optional HDMI feature.
> -
> -         Say Y when you have an HDMI receiver, transmitter or a USB CEC
> -         adapter that supports HDMI CEC.
> -
> -config MEDIA_CEC_DEBUG
> -       bool "HDMI CEC debugfs interface"
> -       depends on MEDIA_CEC_SUPPORT && DEBUG_FS
> -       ---help---
> -         Turns on the DebugFS interface for CEC devices.
> +       bool "HDMI CEC support"
> +       ---help---
> +         Enable support for HDMI CEC (Consumer Electronics Control),
> +         which is an optional HDMI feature.
>
> -config MEDIA_CEC_EDID
> -       bool
> +         Say Y when you have an HDMI receiver, transmitter or a USB CEC
> +         adapter that supports HDMI CEC.
>
> -config MEDIA_CEC_NOTIFIER
> -       bool
> -       select MEDIA_CEC_EDID
> +source "drivers/media/cec/Kconfig"
>
>  #
>  # Media controller
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 8b36a571d443..523fea3648ad 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -2,20 +2,10 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>
> -ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
> -  obj-$(CONFIG_MEDIA_SUPPORT) +=3D cec-edid.o
> -endif
> -
> -ifeq ($(CONFIG_MEDIA_CEC_NOTIFIER),y)
> -  obj-$(CONFIG_MEDIA_SUPPORT) +=3D cec-notifier.o
> -endif
> -
> -ifeq ($(CONFIG_MEDIA_CEC_SUPPORT),y)
> -  obj-$(CONFIG_MEDIA_SUPPORT) +=3D cec/
> -endif
> -
>  media-objs     :=3D media-device.o media-devnode.o media-entity.o
>
> +obj-$(CONFIG_CEC_CORE) +=3D cec/
> +
>  #
>  # I2C drivers should come before other drivers, otherwise they'll fail
>  # when compiled as builtin drivers
> diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
> new file mode 100644
> index 000000000000..24b53187ee52
> --- /dev/null
> +++ b/drivers/media/cec/Kconfig
> @@ -0,0 +1,13 @@
> +config CEC_CORE
> +       tristate
> +       depends on MEDIA_CEC_SUPPORT
> +       default y
> +
> +config MEDIA_CEC_NOTIFIER
> +       bool
> +
> +config MEDIA_CEC_DEBUG
> +       bool "HDMI CEC debugfs interface"
> +       depends on MEDIA_CEC_SUPPORT && DEBUG_FS
> +       ---help---
> +         Turns on the DebugFS interface for CEC devices.
> diff --git a/drivers/media/cec/Makefile b/drivers/media/cec/Makefile
> index d6686337275f..402a6c62a3e8 100644
> --- a/drivers/media/cec/Makefile
> +++ b/drivers/media/cec/Makefile
> @@ -1,5 +1,7 @@
> -cec-objs :=3D cec-core.o cec-adap.o cec-api.o
> +cec-objs :=3D cec-core.o cec-adap.o cec-api.o cec-edid.o
>
> -ifeq ($(CONFIG_MEDIA_CEC_SUPPORT),y)
> -  obj-$(CONFIG_MEDIA_SUPPORT) +=3D cec.o
> +ifeq ($(CONFIG_MEDIA_CEC_NOTIFIER),y)
> +  cec-objs +=3D cec-notifier.o
>  endif
> +
> +obj-$(CONFIG_CEC_CORE) +=3D cec.o
> diff --git a/drivers/media/cec-edid.c b/drivers/media/cec/cec-edid.c
> similarity index 97%
> rename from drivers/media/cec-edid.c
> rename to drivers/media/cec/cec-edid.c
> index 5719b991e340..c63dc81d2a29 100644
> --- a/drivers/media/cec-edid.c
> +++ b/drivers/media/cec/cec-edid.c
> @@ -165,7 +165,3 @@ int cec_phys_addr_validate(u16 phys_addr, u16 *parent=
, u16 *port)
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(cec_phys_addr_validate);
> -
> -MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
> -MODULE_DESCRIPTION("CEC EDID helper functions");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/cec-notifier.c b/drivers/media/cec/cec-notifie=
r.c
> similarity index 100%
> rename from drivers/media/cec-notifier.c
> rename to drivers/media/cec/cec-notifier.c
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index b358d1a40688..40bb4bdc51da 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -209,7 +209,6 @@ config VIDEO_ADV7604
>         depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>         depends on GPIOLIB || COMPILE_TEST
>         select HDMI
> -       select MEDIA_CEC_EDID
>         ---help---
>           Support for the Analog Devices ADV7604 video decoder.
>
> @@ -221,7 +220,7 @@ config VIDEO_ADV7604
>
>  config VIDEO_ADV7604_CEC
>         bool "Enable Analog Devices ADV7604 CEC support"
> -       depends on VIDEO_ADV7604 && MEDIA_CEC_SUPPORT
> +       depends on VIDEO_ADV7604 && CEC_CORE
>         ---help---
>           When selected the adv7604 will support the optional
>           HDMI CEC feature.
> @@ -230,7 +229,6 @@ config VIDEO_ADV7842
>         tristate "Analog Devices ADV7842 decoder"
>         depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>         select HDMI
> -       select MEDIA_CEC_EDID
>         ---help---
>           Support for the Analog Devices ADV7842 video decoder.
>
> @@ -242,7 +240,7 @@ config VIDEO_ADV7842
>
>  config VIDEO_ADV7842_CEC
>         bool "Enable Analog Devices ADV7842 CEC support"
> -       depends on VIDEO_ADV7842 && MEDIA_CEC_SUPPORT
> +       depends on VIDEO_ADV7842 && CEC_CORE
>         ---help---
>           When selected the adv7842 will support the optional
>           HDMI CEC feature.
> @@ -470,7 +468,6 @@ config VIDEO_ADV7511
>         tristate "Analog Devices ADV7511 encoder"
>         depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>         select HDMI
> -       select MEDIA_CEC_EDID
>         ---help---
>           Support for the Analog Devices ADV7511 video encoder.
>
> @@ -481,7 +478,7 @@ config VIDEO_ADV7511
>
>  config VIDEO_ADV7511_CEC
>         bool "Enable Analog Devices ADV7511 CEC support"
> -       depends on VIDEO_ADV7511 && MEDIA_CEC_SUPPORT
> +       depends on VIDEO_ADV7511 && CEC_CORE
>         ---help---
>           When selected the adv7511 will support the optional
>           HDMI CEC feature.
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kcon=
fig
> index 73c3bc5deadf..ac026ee1ca07 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -461,34 +461,6 @@ config VIDEO_TI_SC
>  config VIDEO_TI_CSC
>         tristate
>
> -menuconfig V4L_CEC_DRIVERS
> -       bool "Platform HDMI CEC drivers"
> -       depends on MEDIA_CEC_SUPPORT
> -
> -if V4L_CEC_DRIVERS
> -
> -config VIDEO_SAMSUNG_S5P_CEC
> -       tristate "Samsung S5P CEC driver"
> -       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (PLAT_S5P || ARCH_EX=
YNOS || COMPILE_TEST)
> -       select MEDIA_CEC_NOTIFIER
> -       ---help---
> -         This is a driver for Samsung S5P HDMI CEC interface. It uses th=
e
> -         generic CEC framework interface.
> -         CEC bus is present in the HDMI connector and enables communicat=
ion
> -         between compatible devices.
> -
> -config VIDEO_STI_HDMI_CEC
> -       tristate "STMicroelectronics STiH4xx HDMI CEC driver"
> -       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (ARCH_STI || COMPILE=
_TEST)
> -       select MEDIA_CEC_NOTIFIER
> -       ---help---
> -         This is a driver for STIH4xx HDMI CEC interface. It uses the
> -         generic CEC framework interface.
> -         CEC bus is present in the HDMI connector and enables communicat=
ion
> -         between compatible devices.
> -
> -endif #V4L_CEC_DRIVERS
> -
>  menuconfig V4L_TEST_DRIVERS
>         bool "Media test drivers"
>         depends on MEDIA_CAMERA_SUPPORT
> @@ -520,3 +492,31 @@ menuconfig DVB_PLATFORM_DRIVERS
>  if DVB_PLATFORM_DRIVERS
>  source "drivers/media/platform/sti/c8sectpfe/Kconfig"
>  endif #DVB_PLATFORM_DRIVERS
> +
> +menuconfig CEC_PLATFORM_DRIVERS
> +       bool "CEC platform devices"
> +       depends on MEDIA_CEC_SUPPORT
> +
> +if CEC_PLATFORM_DRIVERS
> +
> +config VIDEO_SAMSUNG_S5P_CEC
> +       tristate "Samsung S5P CEC driver"
> +       depends on CEC_CORE && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
> +       select MEDIA_CEC_NOTIFIER
> +       ---help---
> +         This is a driver for Samsung S5P HDMI CEC interface. It uses th=
e
> +         generic CEC framework interface.
> +         CEC bus is present in the HDMI connector and enables communicat=
ion
> +         between compatible devices.
> +
> +config VIDEO_STI_HDMI_CEC
> +       tristate "STMicroelectronics STiH4xx HDMI CEC driver"
> +       depends on CEC_CORE && (ARCH_STI || COMPILE_TEST)
> +       select MEDIA_CEC_NOTIFIER
> +       ---help---
> +         This is a driver for STIH4xx HDMI CEC interface. It uses the
> +         generic CEC framework interface.
> +         CEC bus is present in the HDMI connector and enables communicat=
ion
> +         between compatible devices.
> +
> +endif #CEC_PLATFORM_DRIVERS
> diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platfor=
m/vivid/Kconfig
> index 94ab1364a792..b36ac19dc6e4 100644
> --- a/drivers/media/platform/vivid/Kconfig
> +++ b/drivers/media/platform/vivid/Kconfig
> @@ -7,7 +7,6 @@ config VIDEO_VIVID
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT
> -       select MEDIA_CEC_EDID
>         select VIDEOBUF2_VMALLOC
>         select VIDEOBUF2_DMA_CONTIG
>         select VIDEO_V4L2_TPG
> @@ -27,7 +26,7 @@ config VIDEO_VIVID
>
>  config VIDEO_VIVID_CEC
>         bool "Enable CEC emulation support"
> -       depends on VIDEO_VIVID && MEDIA_CEC_SUPPORT
> +       depends on VIDEO_VIVID && CEC_CORE
>         ---help---
>           When selected the vivid module will emulate the optional
>           HDMI CEC feature.
> diff --git a/drivers/media/usb/pulse8-cec/Kconfig b/drivers/media/usb/pul=
se8-cec/Kconfig
> index 6ffc407de62f..8937f3986a01 100644
> --- a/drivers/media/usb/pulse8-cec/Kconfig
> +++ b/drivers/media/usb/pulse8-cec/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_PULSE8_CEC
>         tristate "Pulse Eight HDMI CEC"
> -       depends on USB_ACM && MEDIA_CEC_SUPPORT
> +       depends on USB_ACM && CEC_CORE
>         select SERIO
>         select SERIO_SERPORT
>         ---help---
> diff --git a/drivers/media/usb/rainshadow-cec/Kconfig b/drivers/media/usb=
/rainshadow-cec/Kconfig
> index 447291b3cca3..3eb86607efb8 100644
> --- a/drivers/media/usb/rainshadow-cec/Kconfig
> +++ b/drivers/media/usb/rainshadow-cec/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_RAINSHADOW_CEC
>         tristate "RainShadow Tech HDMI CEC"
> -       depends on USB_ACM && MEDIA_CEC_SUPPORT
> +       depends on USB_ACM && CEC_CORE
>         select SERIO
>         select SERIO_SERPORT
>         ---help---
> diff --git a/include/media/cec-edid.h b/include/media/cec-edid.h
> index bdf731ecba1a..242781fd377f 100644
> --- a/include/media/cec-edid.h
> +++ b/include/media/cec-edid.h
> @@ -26,6 +26,8 @@
>  #define cec_phys_addr_exp(pa) \
>         ((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
>
> +#if IS_ENABLED(CONFIG_CEC_CORE)
> +
>  /**
>   * cec_get_edid_phys_addr() - find and return the physical address
>   *
> @@ -101,4 +103,31 @@ u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)=
;
>   */
>  int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
>
> +#else
> +
> +static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int si=
ze,
> +                                        unsigned int *offset)
> +{
> +       if (offset)
> +               *offset =3D 0;
> +       return CEC_PHYS_ADDR_INVALID;
> +}
> +
> +static inline void cec_set_edid_phys_addr(u8 *edid, unsigned int size,
> +                                         u16 phys_addr)
> +{
> +}
> +
> +static inline u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
> +{
> +       return CEC_PHYS_ADDR_INVALID;
> +}
> +
> +static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16=
 *port)
> +{
> +       return 0;
> +}
> +
> +#endif
> +
>  #endif /* _MEDIA_CEC_EDID_H */
> diff --git a/include/media/cec.h b/include/media/cec.h
> index b313e3ecab70..bae8d0153de7 100644
> --- a/include/media/cec.h
> +++ b/include/media/cec.h
> @@ -204,7 +204,7 @@ static inline bool cec_is_sink(const struct cec_adapt=
er *adap)
>         return adap->phys_addr =3D=3D 0;
>  }
>
> -#if IS_ENABLED(CONFIG_MEDIA_CEC_SUPPORT)
> +#if IS_ENABLED(CONFIG_CEC_CORE)
>  struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>                 void *priv, const char *name, u32 caps, u8 available_las)=
;
>  int cec_register_adapter(struct cec_adapter *adap, struct device *parent=
);
> --
> 2.11.0
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
