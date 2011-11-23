Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37161 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1KWKzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 05:55:14 -0500
Received: by bke11 with SMTP id 11so1437055bke.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 02:55:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111122210632.GS27267@pengutronix.de>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
	<1321963316-9058-2-git-send-email-javier.martin@vista-silicon.com>
	<20111122210632.GS27267@pengutronix.de>
Date: Wed, 23 Nov 2011 11:55:12 +0100
Message-ID: <CACKLOr1Fi+wx1wDeOCR3rw3OdYYDB9Jq8S_XtDf7Mf7TtQxwgQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MX2: Add platform definitions for eMMa-PrP device.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On 22 November 2011 22:06, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Nov 22, 2011 at 01:01:55PM +0100, Javier Martin wrote:
>> eMMa-PrP device included in Freescale i.MX2 chips can also
>> be used separately to process memory buffers.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  arch/arm/mach-imx/devices-imx27.h               |    2 +
>>  arch/arm/plat-mxc/devices/platform-mx2-camera.c |   33 +++++++++++++++++++++++
>>  arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
>>  3 files changed, 37 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
>> index 2f727d7..519aa36 100644
>> --- a/arch/arm/mach-imx/devices-imx27.h
>> +++ b/arch/arm/mach-imx/devices-imx27.h
>> @@ -50,6 +50,8 @@ extern const struct imx_imx_uart_1irq_data imx27_imx_uart_data[];
>>  extern const struct imx_mx2_camera_data imx27_mx2_camera_data;
>>  #define imx27_add_mx2_camera(pdata)  \
>>       imx_add_mx2_camera(&imx27_mx2_camera_data, pdata)
>> +#define imx27_alloc_mx2_emmaprp(pdata)       \
>> +     imx_alloc_mx2_emmaprp(&imx27_mx2_camera_data)
>>
>>  extern const struct imx_mxc_ehci_data imx27_mxc_ehci_otg_data;
>>  #define imx27_add_mxc_ehci_otg(pdata)        \
>> diff --git a/arch/arm/plat-mxc/devices/platform-mx2-camera.c b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
>> index b3f4828..4a8bd73 100644
>> --- a/arch/arm/plat-mxc/devices/platform-mx2-camera.c
>> +++ b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
>> @@ -6,6 +6,7 @@
>>   * the terms of the GNU General Public License version 2 as published by the
>>   * Free Software Foundation.
>>   */
>> +#include <linux/dma-mapping.h>
>>  #include <mach/hardware.h>
>>  #include <mach/devices-common.h>
>>
>> @@ -62,3 +63,35 @@ struct platform_device *__init imx_add_mx2_camera(
>>                       res, data->iobaseemmaprp ? 4 : 2,
>>                       pdata, sizeof(*pdata), DMA_BIT_MASK(32));
>>  }
>> +
>> +struct platform_device *__init imx_alloc_mx2_emmaprp(
>> +             const struct imx_mx2_camera_data *data)
>
> Why only alloc and not register?

You are right. That would make things more compact at board level as
it is done with other devices such as SSI, etc...
I will send a v3 version of this patch soon addressing this.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
