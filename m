Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34711 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbLTJwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 04:52:32 -0500
MIME-Version: 1.0
In-Reply-To: <566DAE57.6030000@cogentembedded.com>
References: <1450020436-809-1-git-send-email-ykaneko0929@gmail.com>
	<566DAE57.6030000@cogentembedded.com>
Date: Sun, 20 Dec 2015 18:52:31 +0900
Message-ID: <CAH1o70+V1yExrxHUvOPnZci0YNif2a2SMRwCZzAfRggGNRFQFQ@mail.gmail.com>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add R-Car Gen3 support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2015-12-14 2:43 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> On 12/13/2015 06:27 PM, Yoshihiro Kaneko wrote:
>
>> From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
>>
>> Add chip identification for R-Car Gen3.
>>
>> Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>
> [...]
>>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>> b/drivers/media/platform/soc_camera/rcar_vin.c
>> index 5d90f39..29e7ca4 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -143,6 +143,7 @@
>>   #define RCAR_VIN_BT656                        (1 << 3)
>>
>>   enum chip_id {
>> +       RCAR_GEN3,
>>         RCAR_GEN2,
>>         RCAR_H1,
>>         RCAR_M1,
>> @@ -1846,6 +1847,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops
>> = {
>>
>>   #ifdef CONFIG_OF
>>   static const struct of_device_id rcar_vin_of_table[] = {
>> +       { .compatible = "renesas,vin-r8a7795", .data = (void *)RCAR_GEN3
>> },
>
>
>    I don't see where this is checked in the driver. Shouldn't we just use
> gen2?

I'd like to withdraw this patch now.
I intend to post the series patch including this patch at another day.

>
> MBR, Sergei
>

Thanks,
kaneko
