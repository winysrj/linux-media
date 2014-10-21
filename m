Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38981 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaJULdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <544633D3.5010805@cogentembedded.com>
References: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
	<544633D3.5010805@cogentembedded.com>
Date: Tue, 21 Oct 2014 20:33:52 +0900
Message-ID: <CAH1o70Jk=dCf3VWqdAJmGzd6TSQFeN=x+FCKExDzaf0BZF0L1A@mail.gmail.com>
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
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

2014-10-21 19:22 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> Hello.
>
> On 10/21/2014 9:08 AM, Yoshihiro Kaneko wrote:
>
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
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
>> v2 [Yoshihiro Kaneko]
>> * remove unused/useless definition as suggested by Sergei Shtylyov
>
>
>    I didn't say it's useless, I just suspected that you missed the necessary
> test somewhere...

Sorry for my inaccurate description.

>
>>   drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>
>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>> b/drivers/media/platform/soc_camera/rcar_vin.c
>> index 20defcb..cb5e682 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -74,6 +74,7 @@
>>   #define VNMC_INF_YUV10_BT656  (2 << 16)
>>   #define VNMC_INF_YUV10_BT601  (3 << 16)
>>   #define VNMC_INF_YUV16                (5 << 16)
>> +#define VNMC_INF_RGB888                (6 << 16)
>>   #define VNMC_VUP              (1 << 10)
>>   #define VNMC_IM_ODD           (0 << 3)
>>   #define VNMC_IM_ODD_EVEN      (1 << 3)
>
> [...]
>>
>> @@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>>         if (output_is_yuv)
>>                 vnmc |= VNMC_BPS;
>>
>> +       if (vnmc & VNMC_INF_RGB888)
>> +               vnmc ^= VNMC_BPS;
>> +
>
>
>    Hm, this also changes the behavior for VNMC_INF_YUV16 and
> VNMC_INF_YUV10_BT{601|656}. Is this actually intended?

Probably this code is incorrect.
Thank you for your review.

Thanks,
Kaneko

>
> [...]
>
> WBR, Sergei
>
