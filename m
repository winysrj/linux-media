Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:59125 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab1LBXFl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 18:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <87wraelhil.fsf@ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-6-git-send-email-saaguirre@ti.com> <87wraelhil.fsf@ti.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Fri, 2 Dec 2011 17:01:09 -0600
Message-ID: <CAKnK67Qn551zH3cxES0cNkR3x+fnxZBvSpO3BmvqW59srWGnCA@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] OMAP4: Add base addresses for ISS
To: Kevin Hilman <khilman@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

Thanks for the review.

On Fri, Dec 2, 2011 at 4:45 PM, Kevin Hilman <khilman@ti.com> wrote:
> Sergio Aguirre <saaguirre@ti.com> writes:
>
>> NOTE: This isn't the whole list of features that the
>> ISS supports, but the only ones supported at the moment.
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>
> [...]
>
>> diff --git a/arch/arm/plat-omap/include/plat/omap44xx.h b/arch/arm/plat-omap/include/plat/omap44xx.h
>> index ea2b8a6..31432aa 100644
>> --- a/arch/arm/plat-omap/include/plat/omap44xx.h
>> +++ b/arch/arm/plat-omap/include/plat/omap44xx.h
>> @@ -49,6 +49,15 @@
>>  #define OMAP44XX_MAILBOX_BASE                (L4_44XX_BASE + 0xF4000)
>>  #define OMAP44XX_HSUSB_OTG_BASE              (L4_44XX_BASE + 0xAB000)
>>
>> +#define OMAP44XX_ISS_BASE                    0x52000000
>> +#define OMAP44XX_ISS_TOP_BASE                        (OMAP44XX_ISS_BASE + 0x0)
>> +#define OMAP44XX_ISS_CSI2_A_REGS1_BASE               (OMAP44XX_ISS_BASE + 0x1000)
>> +#define OMAP44XX_ISS_CAMERARX_CORE1_BASE     (OMAP44XX_ISS_BASE + 0x1170)
>> +
>> +#define OMAP44XX_ISS_TOP_END                 (OMAP44XX_ISS_TOP_BASE + 256 - 1)
>> +#define OMAP44XX_ISS_CSI2_A_REGS1_END                (OMAP44XX_ISS_CSI2_A_REGS1_BASE + 368 - 1)
>> +#define OMAP44XX_ISS_CAMERARX_CORE1_END              (OMAP44XX_ISS_CAMERARX_CORE1_BASE + 32 - 1)
>> +
>>  #define OMAP4_MMU1_BASE                      0x55082000
>>  #define OMAP4_MMU2_BASE                      0x4A066000
>
> Who are the users of thes address ranges?
>
> IMO, we shouldn't ned to add anymore based address definitions.  These
> should be done in the hwmod data, and drivers get base addresses using
> the standard ways of getting resources (DT or platform_get_resource())

I see... I get your point now.

Will remove them from this patch series then.

Regards,
Sergio

>
> Kevin
