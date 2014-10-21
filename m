Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36076 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaJUDa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 23:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <544280E4.20101@cogentembedded.com>
References: <1413267956-8342-1-git-send-email-ykaneko0929@gmail.com>
	<544280E4.20101@cogentembedded.com>
Date: Tue, 21 Oct 2014 12:30:29 +0900
Message-ID: <CAH1o70JoiJhec6thnQZnQ_99DLjhMrYhypFubkDYNnTcP_02ZQ@mail.gmail.com>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Enable VSYNC field toggle mode
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

Hello Sergei,

Thank you for your comments.

2014-10-19 0:01 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> Hello.
>
> On 10/14/2014 10:25 AM, Yoshihiro Kaneko wrote:
>
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>
>
>> By applying this patch, it sets to VSYNC field toggle mode not only
>> at the time of progressive mode but at the time of an interlace mode.
>
>
>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>> ---
>
>
>> This patch is against master branch of linuxtv.org/media_tree.git.
>
>
>>   drivers/media/platform/soc_camera/rcar_vin.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>
>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>> b/drivers/media/platform/soc_camera/rcar_vin.c
>> index 5196c81..bf97ed6 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -108,6 +108,7 @@
>>   #define VNDMR2_VPS            (1 << 30)
>>   #define VNDMR2_HPS            (1 << 29)
>>   #define VNDMR2_FTEV           (1 << 17)
>> +#define VNDMR2_VLV_1           (1 << 12)
>
>
>    Please instead do:
>
> #define VNDMR2_VLV(n)   ((n & 0xf) << 12)

It's unclear to me why the style of the new #define should differ
from those of the existing ones.

Thanks,
Kaneko

>
> WBR, Sergei
>
