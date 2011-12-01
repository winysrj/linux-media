Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:55854 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749Ab1LANRs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 08:17:48 -0500
MIME-Version: 1.0
In-Reply-To: <79CD15C6BA57404B839C016229A409A8046FCD@DBDE01.ent.ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-5-git-send-email-saaguirre@ti.com> <79CD15C6BA57404B839C016229A409A8046FCD@DBDE01.ent.ti.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 1 Dec 2011 07:17:25 -0600
Message-ID: <CAKnK67TrzD1hoKOOaodRK=-Ct5bNYAtXab3hY4UdxJTNdD0Tuw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] OMAP4: hwmod: Include CSI2A and CSIPHY1 memory sections
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

Thanks for the comments.

On Thu, Dec 1, 2011 at 12:34 AM, Hiremath, Vaibhav <hvaibhav@ti.com> wrote:
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Aguirre, Sergio
>> Sent: Thursday, December 01, 2011 5:45 AM
>> To: linux-media@vger.kernel.org
>> Cc: linux-omap@vger.kernel.org; laurent.pinchart@ideasonboard.com;
>> sakari.ailus@iki.fi; Aguirre, Sergio
>> Subject: [PATCH v2 04/11] OMAP4: hwmod: Include CSI2A and CSIPHY1 memory
>> sections
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   16 +++++++++++++---
>>  1 files changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-
>> omap2/omap_hwmod_44xx_data.c
>> index 7695e5d..1b59e2f 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> @@ -2623,8 +2623,18 @@ static struct omap_hwmod_ocp_if
>> *omap44xx_iss_masters[] = {
>>
>>  static struct omap_hwmod_addr_space omap44xx_iss_addrs[] = {
>>       {
>> -             .pa_start       = 0x52000000,
>> -             .pa_end         = 0x520000ff,
>> +             .pa_start       = OMAP44XX_ISS_TOP_BASE,
>> +             .pa_end         = OMAP44XX_ISS_TOP_END,
>> +             .flags          = ADDR_TYPE_RT
>> +     },
>> +     {
>> +             .pa_start       = OMAP44XX_ISS_CSI2_A_REGS1_BASE,
>> +             .pa_end         = OMAP44XX_ISS_CSI2_A_REGS1_END,
>> +             .flags          = ADDR_TYPE_RT
>> +     },
>> +     {
>> +             .pa_start       = OMAP44XX_ISS_CAMERARX_CORE1_BASE,
>> +             .pa_end         = OMAP44XX_ISS_CAMERARX_CORE1_END,
>>               .flags          = ADDR_TYPE_RT
>>       },
> This patch will result in build failure, because, the above base addresses
> are getting defined in the next patch
>
> [PATCH v2 05/11] OMAP4: Add base addresses for ISS

Agreed. Will revisit "git-bisectability" of the patch series. Will fix.

Regards,
Sergio

>
> Thanks,
> Vaibhav
>
>>       { }
>> @@ -5350,7 +5360,7 @@ static __initdata struct omap_hwmod
>> *omap44xx_hwmods[] = {
>>       &omap44xx_ipu_c1_hwmod,
>>
>>       /* iss class */
>> -/*   &omap44xx_iss_hwmod, */
>> +     &omap44xx_iss_hwmod,
>>
>>       /* iva class */
>>       &omap44xx_iva_hwmod,
>> --
>> 1.7.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
