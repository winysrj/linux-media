Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34558 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbeDJQ2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 12:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <20180409073614.GV20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-3-git-send-email-akinobu.mita@gmail.com> <20180409073614.GV20945@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 11 Apr 2018 01:28:32 +0900
Message-ID: <CAC5umyhDRPK8Y1CLDZpQpij-AfL+k3WmX+Wm02GbBCih1k8PQQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] media: ov772x: add checks for register read errors
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-09 16:36 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>
> On Sun, Apr 08, 2018 at 12:48:06AM +0900, Akinobu Mita wrote:
>> This change adds checks for register read errors and returns correct
>> error code.
>>
>
> I feel like error conditions are anyway captured by the switch()
> default case, but I understand there may be merits in returning the
> actual error code.
>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  drivers/media/i2c/ov772x.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 283ae2c..c56f910 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -1169,8 +1169,15 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>>               return ret;
>>
>>       /* Check and show product ID and manufacturer ID. */
>> -     pid = ov772x_read(client, PID);
>> -     ver = ov772x_read(client, VER);
>> +     ret = ov772x_read(client, PID);
>> +     if (ret < 0)
>> +             return ret;
>> +     pid = ret;
>> +
>> +     ret = ov772x_read(client, VER);
>> +     if (ret < 0)
>> +             return ret;
>> +     ver = ret;
>
> You can assign the ov772x_read() return value to pid and ver directly
> and save two assignments.

OK. This needs to change the data types of pid and ver from 'u8' to 'int'.

>>
>>       switch (VERSION(pid, ver)) {
>>       case OV7720:
>
> If we want to check for return values here, which is always a good
> thing, could you do the same for MIDH and MIDL below?

Sounds good.

> Nit: You can also fix the dev_info() parameters alignment to span to
> the whole line length while at there. Ie.
>
>         dev_info(&client->dev,
>                  "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
>                  devname, pid, ver, ov772x_read(client, MIDH),
>                  ov772x_read(client, MIDL));
>
> Thanks
>    j
>
>
>> --
>> 2.7.4
>>
