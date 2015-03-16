Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:32770 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbCPNoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 09:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1503151544190.13027@axis700.grange>
References: <1426430373-3443-1-git-send-email-ykaneko0929@gmail.com>
	<Pine.LNX.4.64.1503151544190.13027@axis700.grange>
Date: Mon, 16 Mar 2015 22:44:04 +0900
Message-ID: <CAH1o70L+6wG-mCMYF_aEZktkNqa_1RvQdRPSw4KQgAk4g-wR+Q@mail.gmail.com>
Subject: Re: [PATCH/RFC] media: soc_camera: rcar_vin: Fix wait_for_completion
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2015-03-15 23:46 GMT+09:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi,
>
> Thanks for the patch.
>
> On Sun, 15 Mar 2015, Yoshihiro Kaneko wrote:
>
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>
>> When stopping abnormally, a driver can't return from wait_for_completion.
>> This patch resolved this problem by changing wait_for_completion_timeout
>> from wait_for_completion.
>>
>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
>> ---
>>
>> This patch is against master branch of linuxtv.org/media_tree.git.
>>
>>  drivers/media/platform/soc_camera/rcar_vin.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
>> index 279ab9f..ff0359b 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -135,6 +135,8 @@
>>  #define VIN_MAX_WIDTH                2048
>>  #define VIN_MAX_HEIGHT               2048
>>
>> +#define TIMEOUT_MS           100
>> +
>>  enum chip_id {
>>       RCAR_GEN2,
>>       RCAR_H1,
>> @@ -821,6 +823,10 @@ static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
>>                       priv->request_to_stop = true;
>>                       spin_unlock_irq(&priv->lock);
>>                       wait_for_completion(&priv->capture_stop);
>> +                     if (!wait_for_completion_timeout(
>> +                             &priv->capture_stop,
>> +                             msecs_to_jiffies(TIMEOUT_MS)))
>> +                             priv->state = STOPPED;
>
> You forgot to remove the original wait_for_completion().

Oops, my bad.

Thanks,
Kaneko

>
> Thanks
> Guennadi
>
>>                       spin_lock_irq(&priv->lock);
>>               }
>>       }
>> --
>> 1.9.1
>>
