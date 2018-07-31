Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36067 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbeGaKcd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 06:32:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id h9-v6so15764174wro.3
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2018 01:53:15 -0700 (PDT)
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-19-m.felsch@pengutronix.de>
 <20180730151842.0fd99d01@coco.lan>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
Date: Tue, 31 Jul 2018 10:52:56 +0200
MIME-Version: 1.0
In-Reply-To: <20180730151842.0fd99d01@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 07/30/2018 08:18 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Jun 2018 18:20:50 +0200
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
>> From: Javier Martinez Canillas <javierm@redhat.com>
>>
>> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
>> added input signals support for the tvp5150, but the approach was found
>> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
>> ("[media] tvp5150: document input connectors DT bindings") was reverted.
>>
>> This left the driver with an undocumented (and wrong) DT parsing logic,
>> so lets get rid of this code as well until the input connectors support
>> is implemented properly.
>>
>> It's a partial revert due other patches added on top of mentioned commit
>> not allowing the commit to be reverted cleanly anymore. But all the code
>> related to the DT parsing logic and input entities creation are removed.
>>
>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> [m.felsch@pengutronix.de: rm TVP5150_INPUT_NUM define]
>> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>> ---
> 
> ...
> 
>> -static int tvp5150_registered(struct v4l2_subdev *sd)
>> -{
>> -#ifdef CONFIG_MEDIA_CONTROLLER
>> -	struct tvp5150 *decoder = to_tvp5150(sd);
>> -	int ret = 0;
>> -	int i;
>> -
>> -	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
>> -		struct media_entity *input = &decoder->input_ent[i];
>> -		struct media_pad *pad = &decoder->input_pad[i];
>> -
>> -		if (!input->name)
>> -			continue;
>> -
>> -		decoder->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
>> -
>> -		ret = media_entity_pads_init(input, 1, pad);
>> -		if (ret < 0)
>> -			return ret;
>> -
>> -		ret = media_device_register_entity(sd->v4l2_dev->mdev, input);
>> -		if (ret < 0)
>> -			return ret;
>> -
>> -		ret = media_create_pad_link(input, 0, &sd->entity,
>> -					    DEMOD_PAD_IF_INPUT, 0);
>> -		if (ret < 0) {
>> -			media_device_unregister_entity(input);
>> -			return ret;
>> -		}
>> -	}
>> -#endif
> 
> Hmm... I suspect that reverting this part may cause problems for drivers
> like em28xx when compiled with MC, as they rely that the supported demods
> will have 3 pads (DEMOD_NUM_PADS).
>

I don't see how this change could affect em28xx and other drivers. The function
tvp5150_registered() being removed here, only register the media entity and add
a link if input->name was set. This is set in tvp5150_parse_dt() and only if a
input connector as defined in the Device Tree file.

In other words, all the code removed by this patch is DT-only and isn't used by
any media driver that makes use of the tvp5151.

As mentioned in the commit message, this code has never been used (besides from
my testings) and should had been removed when the DT binding was reverted, but
for some reasons the first patch landed and the second didn't at the time.

> Thanks,
> Mauro
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
