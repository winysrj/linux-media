Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54869 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3EFO7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 10:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <201305031634.39129.arnd@arndb.de>
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com> <201305031634.39129.arnd@arndb.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 6 May 2013 20:29:22 +0530
Message-ID: <CA+V-a8vxhedos6cQbxAbMAwiXOmjrqh0TVp8Rhc_Ou4y9tSaoQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
To: Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Fri, May 3, 2013 at 8:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 03 May 2013, Prabhakar Lad wrote:
>>
[snip]
>> +}
>
> Ok, good.
>
>> @@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client *client,
>>         mt9p031->pdata = pdata;
>>         mt9p031->output_control = MT9P031_OUTPUT_CONTROL_DEF;
>>         mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
>> -       mt9p031->model = did->driver_data;
>> +
>> +       if (!client->dev.of_node) {
>> +               mt9p031->model = (enum mt9p031_model)did->driver_data;
>> +       } else {
>> +               const struct of_device_id *of_id;
>> +
>> +               of_id = of_match_device(of_match_ptr(mt9p031_of_match),
>> +                                       &client->dev);
>> +               if (of_id)
>> +                       mt9p031->model = (enum mt9p031_model)of_id->data;
>> +       }
>>         mt9p031->reset = -1;
>
> Is this actually required? I thought the i2c core just compared the
> part of the "compatible" value after the first comma to the string, so
> "mt9p031->model = (enum mt9p031_model)did->driver_data" should work
> in both cases.
>
I am OK with "mt9p031->model = (enum mt9p031_model)did->driver_data"
but I see still few drivers doing this, I am not sure for what reason.
If everyone is
OK with it I can drop the above change.

Laurent, Sascha what do you suggest ?

Regards,
--Prabhakar Lad
