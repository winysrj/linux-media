Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39572 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2CZM4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 08:56:20 -0400
Received: by iagz16 with SMTP id z16so8226449iag.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 05:56:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120326121023.GD18420@sapphire.tkos.co.il>
References: <1332760804-22743-1-git-send-email-javier.martin@vista-silicon.com>
	<1332760804-22743-4-git-send-email-javier.martin@vista-silicon.com>
	<20120326121023.GD18420@sapphire.tkos.co.il>
Date: Mon, 26 Mar 2012 14:56:19 +0200
Message-ID: <CACKLOr0abquyZ2bZMnq8pXTL8BXqzN_izK92hdA=gPJ6dBsTdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16.
From: javier Martin <javier.martin@vista-silicon.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org, linux@arm.linux.org.uk,
	mchehab@infradead.org, kernel@pengutronix.de,
	u.kleine-koenig@pengutronix.de,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 March 2012 14:10, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi Javier,
>
> On Mon, Mar 26, 2012 at 01:20:04PM +0200, Javier Martin wrote:
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  arch/arm/mach-imx/mach-imx27_visstrim_m10.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
>> index 3128cfe..4db00c6 100644
>> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
>> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
>> @@ -164,7 +164,7 @@ static struct platform_device visstrim_tvp5150 = {
>>
>>
>>  static struct mx2_camera_platform_data visstrim_camera = {
>> -     .flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_SWAP16 | MX2_CAMERA_PCLK_SAMPLE_RISING,
>> +     .flags = MX2_CAMERA_CCIR | MX2_CAMERA_CCIR_INTERLACE | MX2_CAMERA_PCLK_SAMPLE_RISING,
>>       .clk = 100000,
>>  };
>
> The order of the last two patches in this series should be switched to
> preserve bisectability.
>
> baruch

You are right.
Thanks.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
