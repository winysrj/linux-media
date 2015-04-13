Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:34751 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbDMMCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 08:02:09 -0400
Received: by laat2 with SMTP id t2so55221223laa.1
        for <linux-media@vger.kernel.org>; Mon, 13 Apr 2015 05:02:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150411124838.GM20756@valkosipuli.retiisi.org.uk>
References: <1428704008-29640-1-git-send-email-prabhakar.csengg@gmail.com> <20150411124838.GM20756@valkosipuli.retiisi.org.uk>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 13 Apr 2015 13:01:37 +0100
Message-ID: <CA+V-a8sFO=aWZxOZKgVN4vyFYZZruc-Uv9yOQTSzEDh1yVa4KQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: ov2659: Use v4l2_of_alloc_parse_endpoint()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Sat, Apr 11, 2015 at 1:48 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Prabhakar,
>
> On Fri, Apr 10, 2015 at 11:13:28PM +0100, Lad Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> Instead of parsing the link-frequencies property in the driver, let
>> v4l2_of_alloc_parse_endpoint() do it.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  This patch depends on https://patchwork.kernel.org/patch/6190901/
>>
>>  drivers/media/i2c/ov2659.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
>> index edebd11..c1e310b 100644
>> --- a/drivers/media/i2c/ov2659.c
>> +++ b/drivers/media/i2c/ov2659.c
>> @@ -1340,8 +1340,8 @@ static struct ov2659_platform_data *
>>  ov2659_get_pdata(struct i2c_client *client)
>>  {
>>       struct ov2659_platform_data *pdata;
>> +     struct v4l2_of_endpoint *bus_cfg;
>>       struct device_node *endpoint;
>> -     int ret;
>>
>>       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
>>               return client->dev.platform_data;
>> @@ -1350,18 +1350,27 @@ ov2659_get_pdata(struct i2c_client *client)
>>       if (!endpoint)
>>               return NULL;
>>
>> +     bus_cfg = v4l2_of_alloc_parse_endpoint(endpoint);
>> +     if (IS_ERR(bus_cfg)) {
>> +             pdata = NULL;
>> +             goto done;
>> +     }
>> +
>>       pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>>       if (!pdata)
>>               goto done;
>>
>> -     ret = of_property_read_u64(endpoint, "link-frequencies",
>> -                                &pdata->link_frequency);
>> -     if (ret) {
>> -             dev_err(&client->dev, "link-frequencies property not found\n");
>> +     if (bus_cfg->nr_of_link_frequencies != 1) {
>
> I wonder if it should be considered a problem if the array is larger than
> one item. I would not, even if the rest of the entries wouldn't be used by
> the driver at the moment. Up to you.
>
OK will drop the check for more than one entries.

> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Thanks for the Ack.

Cheers,
--Prabhakar Lad

>
>> +             dev_err(&client->dev,
>> +                     "link-frequencies property not found or too many\n");
>>               pdata = NULL;
>> +             goto done;
>>       }
>>
>> +     pdata->link_frequency = bus_cfg->link_frequencies[0];
>> +
>>  done:
>> +     v4l2_of_free_endpoint(bus_cfg);
>>       of_node_put(endpoint);
>>       return pdata;
>>  }
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
