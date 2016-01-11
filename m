Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:36314 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599AbcAKSqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 13:46:02 -0500
MIME-Version: 1.0
In-Reply-To: <5693F5E5.3060109@cogentembedded.com>
References: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
	<1452535211-4869-4-git-send-email-ykaneko0929@gmail.com>
	<5693F5E5.3060109@cogentembedded.com>
Date: Tue, 12 Jan 2016 03:46:01 +0900
Message-ID: <CAH1o70KEW5LkfsA=uAf6LeixmtPS2--EsWiFejPDFZpx_UK4JQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: soc_camera: rcar_vin: Add ARGB8888 caputre
 format support
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

Hi Sergei,

2016-01-12 3:35 GMT+09:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> Hello.
>
> On 01/11/2016 09:00 PM, Yoshihiro Kaneko wrote:
>
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>
>> This patch adds ARGB8888 capture format support for R-Car Gen3.
>>
>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>> ---
>>   drivers/media/platform/soc_camera/rcar_vin.c | 21 +++++++++++++++++++--
>>   1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>> b/drivers/media/platform/soc_camera/rcar_vin.c
>> index cccd859..afe27bb 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>
> [...]
>>
>> @@ -654,6 +654,14 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>>                         dmr = VNDMR_EXRGB;
>>                         break;
>>                 }
>> +       case V4L2_PIX_FMT_ARGB32:
>> +               if (priv->chip == RCAR_GEN3)
>> +                       dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
>> +               else {
>
>
>    Kernel coding style dictates using {} in all *if* branches if at least
> one branch has them.

Got it.
Thanks!

>
>> +                       dev_err(icd->parent, "Not support format\n");
>> +                       return -EINVAL;
>> +               }
>> +               break;
>>         default:
>>                 dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
>>                          icd->current_fmt->host_fmt->fourcc);
>
> [...]
>
> MBR, Sergei
>

Thanks,
kaneko
