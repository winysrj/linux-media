Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34708 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbeAIKgk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 05:36:40 -0500
MIME-Version: 1.0
In-Reply-To: <20180109101330.wjj4hpjvbdiufi5f@paasikivi.fi.intel.com>
References: <20180108125322.3993808-1-arnd@arndb.de> <20180109101330.wjj4hpjvbdiufi5f@paasikivi.fi.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 9 Jan 2018 11:36:38 +0100
Message-ID: <CAK8P3a3Ab+9A5YK=SHntW2g5-3TPXk-beYTe2V-8uuCvCdw7UA@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: ov7740: add media-controller dependency
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 11:13 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Arnd,
>
> On Mon, Jan 08, 2018 at 01:52:28PM +0100, Arnd Bergmann wrote:
>> Without CONFIG_MEDIA_CONTROLLER, the new driver fails to build:
>>
>> drivers/perf/arm_dsu_pmu.c: In function 'dsu_pmu_probe_pmu':
>> drivers/perf/arm_dsu_pmu.c:661:2: error: implicit declaration of functio=
n 'bitmap_from_u32array'; did you mean 'bitmap_from_arr32'? [-Werror=3Dimpl=
icit-function-declaration]
>
> There seems to be a build error with this driver if Media controller is
> disabled, but this is not the error message

Oops, bad copy-paste, sorry.

> nor adding a dependency to
> Media controller is a sound fix for it.

> drivers/media/i2c/ov7740.c: In function =E2=80=98ov7740_probe=E2=80=99:
> drivers/media/i2c/ov7740.c:1139:38: error: =E2=80=98struct v4l2_subdev=E2=
=80=99 has no member named =E2=80=98entity=E2=80=99
>   media_entity_cleanup(&ov7740->subdev.entity);
>
> I think it'd be worth adding nop variants for functions that are commonly
> used by drivers that can be built with or without the Media controller.
>
> I'll send a patch.

Fair enough.

In this case, the problem is not the lack of the wrapper, as we already
have a

static inline void media_entity_cleanup(struct media_entity *entity) {};

helper, but the fact that struct v4l2_subdev contains a struct media_entity
as an optional member that is disabled here.  Since the argument
to media_entity_cleanup is generally this member, we could have
a wrapper around it that takes a v4l2_subdev pointer, like

static inline void media_subdev_entity_cleanup(struct v4l2_subdev* sd)
{
#ifdef CONFIG_MEDIA_CONTROLLER
      media_entity_cleanup(sd->entity);
#endif
}

which seems nicer than making the relatively large media_entity structure
visible unconditionally, or hiding its members instead.

You may also want to revisit the other drivers that have dependencies
on MEDIA_CONTROLLER then:

drivers/media/Kconfig:  depends on MEDIA_CONTROLLER && DVB_CORE
drivers/media/Kconfig:  depends on VIDEO_DEV && MEDIA_CONTROLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/i2c/Kconfig:      depends on MEDIA_CONTROLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/i2c/Kconfig:      depends on I2C && VIDEO_V4L2 && MEDIA_CONTR=
OLLER
drivers/media/pci/intel/ipu3/Kconfig:   depends on MEDIA_CONTROLLER
drivers/media/platform/Kconfig: depends on VIDEO_V4L2 && OF &&
VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
drivers/media/platform/rcar-vin/Kconfig:        depends on VIDEO_V4L2
&& VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
drivers/staging/media/atomisp/Kconfig:  depends on X86 && EFI &&
MEDIA_CONTROLLER && PCI && ACPI
drivers/staging/media/imx/Kconfig:      depends on MEDIA_CONTROLLER &&
VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE

When you come up with a patch, I can throw it in my randconfig build
test machine
to see if that causes any unexpected build failures.

Thanks,

       Arnd
