Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35633 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeDIIuP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 04:50:15 -0400
Received: by mail-qt0-f194.google.com with SMTP id s2so8297478qti.2
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 01:50:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180407101455.214bf849@vento.lan>
References: <cover.1522949748.git.mchehab@s-opensource.com>
 <2233233.yQEdpcOfql@avalon> <20180405164444.441033be@vento.lan>
 <4086814.xXeFl5mgbc@avalon> <20180407101455.214bf849@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 9 Apr 2018 10:50:13 +0200
Message-ID: <CAK8P3a0_AQaYFyUog0sV9hjq6yOzohnCbD9=AK-HGxWt-P_hEA@mail.gmail.com>
Subject: Re: [PATCH 02/16] media: omap3isp: allow it to build with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 7, 2018 at 3:14 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sat, 07 Apr 2018 14:56:59 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
>> On Thursday, 5 April 2018 22:44:44 EEST Mauro Carvalho Chehab wrote:
>> > Em Thu, 05 Apr 2018 21:30:27 +0300 Laurent Pinchart escreveu:

>> > > If you want to make drivers compile for all architectures, the APIs they
>> > > use must be defined in linux/, not in asm/. They can be stubbed there
>> > > when not implemented in a particular architecture, but not in the driver.
>> >
>> > In this specific case, the same approach taken here is already needed
>> > by the Renesas VMSA-compatible IPMMU driver, with, btw, is inside
>> > drivers/iommu:
>> >
>> >     drivers/iommu/ipmmu-vmsa.c
>>
>> The reason there is different, the driver is shared by ARM32 and ARM64
>> platforms. Furthermore, there's an effort (or at least there was) to move away
>> from those APIs in the driver, but I think it has stalled.
>
> Anyway, the approach sticks at the driver. As this was accepted even
> inside drivers/iommu, I fail to see why not doing the same on media,
> specially since it really helps us to find bugs at omap3isp driver.
>
> Even without pushing upstream (where Coverity would analyze it),
> we got lots of problems by simply letting omap3isp to use the
> usual tools we use for all other drivers.
>
>> > Also, this API is used only by 3 drivers [1]:
>> >
>> >     drivers/iommu/ipmmu-vmsa.c
>> >     drivers/iommu/mtk_iommu_v1.c
>> >     drivers/media/platform/omap3isp/isp.c
>> >
>> > [1] as blamed by
>> >     git grep -l arm_iommu_create_mapping
>>
>> The exynos driver also uses it.
>>
>> > That hardly seems to be an arch-specific iommu solution, but, instead, some
>> > hack used by only three drivers or some legacy iommu binding.
>>
>> It's more complex than that. There are multiple IOMMU-related APIs on ARM, so
>> more recent than others, with different feature sets. While I agree that
>> drivers should move away from arm_iommu_create_mapping(), doing so requires
>> coordination between the IOMMU driver and the bus master driver (for instance
>> the omap3isp driver). It's not a trivial matter, but I'd love if someone
>> submitted patches :-)
>
> If someone steps up to do that, it would be really helpful, but we
> should not trust that this will happen. OMAP3 is an old hardware,
> and not many developers are working on improving its support.

Considering its age, I still see a lot of changes on the arch/arm side of
it, so I wouldn't give up the hope yet.

>> > The omap3isp is, btw, the only driver outside drivers/iommu that needs it.
>> >
>> > So, it sounds that other driver uses some other approach, but hardly
>> > it would be worth to change this driver to use something else.
>> >
>> > So, better to stick with the same solution the Renesas driver used.
>>
>> I'm not responsible for that solution and I didn't think it was a good one at
>> the time it was introduced, but in any case it is not meant at all to support
>> COMPILE_TEST. I still don't think the omap3isp driver should declare stubs for
>> these functions for the purpose of supporting compile-testing on x86.
>
> Well, there is another alternative. We could do add this to its Makefile:
>
> ifndef CONFIG_ARCH_ARM
> ccflags-y += -I./arch/arm/include/
> endif
>
> And add those stubs to arch/arm/include/asm/dma-iommu.h,
> in order to be used when CONFIG_IOMMU_DMA isn't defined:
>
> #define arm_iommu_create_mapping(...)   NULL
> #define arm_iommu_attach_device(...)    -ENODEV
> #define arm_iommu_release_mapping(...)  do {} while (0)
> #define arm_iommu_detach_device(...)    do {} while (0)
>
> If done right, such solution could also be used to remove
> the #ifdef inside drivers/iommu/ipmmu-vmsa.c.
>
> Yet, I think that the approach I proposed before is better,
> but maybe arm maintainers may have a different opinion.
>
> Arnd,
>
> What do you think?

I think including a foreign architecture header is worse than your
earlier patch, I'd rather see a local hack in the driver.

I haven't tried it, but how about something simpler like what
I have below.

      Arnd

(in case it works and you want to pick it up with a proper
changelog):

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/platform/omap3isp/isp.c
b/drivers/media/platform/omap3isp/isp.c
index 8eb000e3d8fd..625f2e407929 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1945,12 +1945,15 @@ static int isp_initialize_modules(struct
isp_device *isp)

 static void isp_detach_iommu(struct isp_device *isp)
 {
+#ifdef CONFIG_ARM
        arm_iommu_release_mapping(isp->mapping);
        isp->mapping = NULL;
+#endif
 }

 static int isp_attach_iommu(struct isp_device *isp)
 {
+#ifdef CONFIG_ARM
        struct dma_iommu_mapping *mapping;
        int ret;

@@ -1979,6 +1982,9 @@ static int isp_attach_iommu(struct isp_device *isp)
 error:
        isp_detach_iommu(isp);
        return ret;
+#else
+       return -ENODEV;
+#endif
 }

 /*
