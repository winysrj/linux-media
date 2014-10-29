Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35832 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaJ2Lbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 07:31:45 -0400
Received: by mail-la0-f42.google.com with SMTP id gq15so2344417lab.29
        for <linux-media@vger.kernel.org>; Wed, 29 Oct 2014 04:31:43 -0700 (PDT)
Message-ID: <5450D01D.9060701@cogentembedded.com>
Date: Wed, 29 Oct 2014 14:31:41 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>,
	Yoshihiro Kaneko <ykaneko0929@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
 input support
References: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com> <544633D3.5010805@cogentembedded.com> <CAH1o70Jk=dCf3VWqdAJmGzd6TSQFeN=x+FCKExDzaf0BZF0L1A@mail.gmail.com> <20141029041103.GB29787@verge.net.au>
In-Reply-To: <20141029041103.GB29787@verge.net.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/29/2014 7:11 AM, Simon Horman wrote:

>>>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

>>>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>>>> ---

>>>> This patch is against master branch of linuxtv.org/media_tree.git.

>>>> v2 [Yoshihiro Kaneko]
>>>> * remove unused/useless definition as suggested by Sergei Shtylyov

>>>     I didn't say it's useless, I just suspected that you missed the necessary
>>> test somewhere...

>> Sorry for my inaccurate description.

>>>>    drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
>>>>    1 file changed, 9 insertions(+)

>>>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>>>> b/drivers/media/platform/soc_camera/rcar_vin.c
>>>> index 20defcb..cb5e682 100644
>>>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>>>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>>>> @@ -74,6 +74,7 @@
>>>>    #define VNMC_INF_YUV10_BT656  (2 << 16)
>>>>    #define VNMC_INF_YUV10_BT601  (3 << 16)
>>>>    #define VNMC_INF_YUV16                (5 << 16)
>>>> +#define VNMC_INF_RGB888                (6 << 16)
>>>>    #define VNMC_VUP              (1 << 10)
>>>>    #define VNMC_IM_ODD           (0 << 3)
>>>>    #define VNMC_IM_ODD_EVEN      (1 << 3)

>>> [...]

>>>> @@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>>>>          if (output_is_yuv)
>>>>                  vnmc |= VNMC_BPS;
>>>>
>>>> +       if (vnmc & VNMC_INF_RGB888)
>>>> +               vnmc ^= VNMC_BPS;
>>>> +

>>>     Hm, this also changes the behavior for VNMC_INF_YUV16 and
>>> VNMC_INF_YUV10_BT{601|656}. Is this actually intended?

>> Probably this code is incorrect.
>> Thank you for your review.

> Thanks, I have confirmed with Matsuoka-san that there is a problem here.

> He has provided the following fix. Could you see about squashing it into
> the above patch and reposting?

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> [PATCH] media: soc_camera: rcar_vin: Fix bit field check

> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 013d75c..da62d94 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -94,7 +94,7 @@
>   #define VNMC_INF_YUV8_BT601	(1 << 16)
>   #define VNMC_INF_YUV16		(5 << 16)
>   #define VNMC_INF_RGB888		(6 << 16)
> -#define VNMC_INF_RGB_MASK	(6 << 16)
> +#define VNMC_INF_MASK		(7 << 16)

    #define it above VNMC_INF_YUV8_BT656 please.

>   #define VNMC_VUP		(1 << 10)
>   #define VNMC_IM_ODD		(0 << 3)
>   #define VNMC_IM_ODD_EVEN	(1 << 3)
> @@ -675,7 +675,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>   	if (output_is_yuv)
>   		vnmc |= VNMC_BPS;
>
> -	if (vnmc & VNMC_INF_RGB_MASK)
> +	if ((vnmc & VNMC_INF_MASK) == VNMC_INF_RGB888)

    Is he sure it shouldn't be (vnmc & VNMC_INF_RGB888) == VNMC_INF_RGB888 to 
also cover 16-bit RGB666 and 12-bit RGB88?

WBR, Sergei

