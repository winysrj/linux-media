Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130CDC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE76C2086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kee4b4cA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE76C2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbeLJM3v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:29:51 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45502 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbeLJM3v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:29:51 -0500
Received: by mail-lf1-f68.google.com with SMTP id b20so7801656lfa.12
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 04:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L5gkqJFNDNUQ0TUQozMC4ROtnBNUmfSKaae1ENTCH0M=;
        b=kee4b4cAydUJxfInA7vy/MIqCrjZS3ixIA057UoUqPlwGdNBWubVQZg4zk+TooVpPH
         3zGUjTfMtIMW+iepbU5kmmqUzduC4tYPz1dUOgjgk/kJ+8ISAdzsthn7I2shyexI8fZP
         iKgJTWt7R/8YPZDPxC189EfmPeCbySpCjhXPmTXQv3VGvEIFc6h4+GkAHFwdg9EhnQ8g
         X69mI3eDQvHhCc6UKRV5dTSWcN/vLpH/jVgDgwaIbjGGubpgMjBcRJA5OmIhhMUJwKOA
         hWzc877HG9/NkCLJy0IZpZP28TXokdt9g32sRu4kppXNWCvfSdeNWiFjCfHP5hQR+dsH
         FWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5gkqJFNDNUQ0TUQozMC4ROtnBNUmfSKaae1ENTCH0M=;
        b=B+6MCjBOGzoM/yH1PEs5EWcF44CJ/fFuupPdxeotaJj6/QrvE8oUykHH4h8yEJwFOg
         pouM/RdtKXhsq353//oaW73bjvECtAUqXLuscKuVIoGmP7Y4N+zmwtkVHds1GzGQYxCV
         hUqP+0isrolAbqibbqTBvk7v4bYQZs2e1rIsMY2wURRqE5X4Pl6TJ58C7k5KvGPt7ilg
         S13hkbgaq8HmVVXQFR5ALJXXUnLHXtN+j8N3sBzBBxDyUoWgiZFZtXnEG3IZU+jJ4GVN
         kPsNXlUvigDjmbtUpsAv119Km97XV8LrPmNEI248W+SQ9v1rfjRlLCU2kTTzE7vnlcQh
         sZyA==
X-Gm-Message-State: AA+aEWZuAFBW2F1Fbjy6ax1F5LpAN+qgkSVRl53pcvVYUhVQnDcr9yll
        jX7jyDvLnQRXrGPuHNiEpuw=
X-Google-Smtp-Source: AFSGD/VWZrbzaqaYGAP4ZioMcPrIeXjLTVQx7M5/mykEOszDLPW9IHc3oJE66LWrplJ+kqc3dI6Oaw==
X-Received: by 2002:a19:d145:: with SMTP id i66mr7069947lfg.97.1544444988227;
        Mon, 10 Dec 2018 04:29:48 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-cdb6-2150-7b94-b0ad.ip6.tmcz.cz. [2001:1ae9:ff1:f191:cdb6:2150:7b94:b0ad])
        by smtp.gmail.com with ESMTPSA id p77-v6sm2343379lja.0.2018.12.10.04.29.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 04:29:47 -0800 (PST)
Subject: Re: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of
 soc_camera
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
 <20180914125910.4ju2utqdlk3klmoz@valkosipuli.retiisi.org.uk>
 <e12dab78-5a85-a94f-e892-0723592cd2dd@gmail.com>
 <20181209220408.mkm244qqcii7s3r3@valkosipuli.retiisi.org.uk>
From:   Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <0196462b-7e8d-4d2d-7a00-72263e78dee3@gmail.com>
Date:   Mon, 10 Dec 2018 13:30:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181209220408.mkm244qqcii7s3r3@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: cs
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne 09. 12. 18 v 23:04 Sakari Ailus napsal(a):
> Hi Petr,
> 
> What's the status of this set? It would seem that addressing the issues
> is fairly trivial. Please also see a few comments below.
> 

Hi,

Gonna work on it this week. I've had to work on higher priority stuff
last two months some of which blocked me from playing with my phone
(with ov9640 camera).

best regards,
Petr


> On Fri, Sep 14, 2018 at 10:54:51PM +0200, Petr Cvek wrote:
>> Dne 14.9.2018 v 14:59 Sakari Ailus napsal(a):
>>> Hi Petr,
>>>
>>> Thanks for the patchset, and my apologies for reviewing it so late!
>>>
>>> I'm commenting this one but feel free to add patches to address the
>>> comments.
>>>
>>
>> Hi and thanks for the review. I would like to have this patch set to be
>> as much as possible only a conversion from soc-camera, but I guess I can
>> fix the error handling in probe and the missing newlines. For the
>> enhanced functionality, I would like to have a new patch set after I'll
>> patch the controller (pxa camera) on my testing platform.
>>
>>>> +/* Start/Stop streaming from the device */
>>>> +static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
>>>> +{
>>>> +	return 0;
>>>
>>> Doesn't the sensor provide any control over the streaming state? Just
>>> wondering...
>>>
>>
>> Before the PXA camera switch from soc-camera I've found some
>> deficiencies in register settings so I'm planning to test them all. With
>> the current state of vanilla I wouldn't be able to test the change.
>> After the quick search in datasheet I wasn't able to find any (stream,
>> capture, start) flag. It may be controlled by just setting the output
>> format flags, but these registers are some of those I will be changing
>> in the future.
>>
>>>> +static int ov9640_s_power(struct v4l2_subdev *sd, int on)
>>>> +{
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>>>> +	struct ov9640_priv *priv = to_ov9640_sensor(sd);
>>>> +
>>>> +	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
>>>
>>> Runtime PM support would be nice --- but not needed in this set IMO.
>>>
>>
>> If I remember correctly a suspend to mem will freeze the whole machine,
>> so in the future :-/.
>>
>>
>>>> +}
>>>> +
>>>> +/* select nearest higher resolution for capture */
>>>> +static void ov9640_res_roundup(u32 *width, u32 *height)
>>>> +{
>>>> +	int i;
>>>
>>> unsigned int
>>>
>>> Same for other loops where no negative values or test below zero are
>>> needed (or where the value which is compared against is signed).
>>>
>> Just re-declaring: unsigned int i; ... OK
> 
> Yes.
> 
>>
>>>> +
>>>> +	cfg->try_fmt = *mf;
>>>
>>> Newline here?
>>>
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int ov9640_enum_mbus_code(struct v4l2_subdev *sd,
>>>> +		struct v4l2_subdev_pad_config *cfg,
>>>> +		struct v4l2_subdev_mbus_code_enum *code)
>>>> +{
>>>> +	if (code->pad || code->index >= ARRAY_SIZE(ov9640_codes))
>>>> +		return -EINVAL;
>>>> +
>>>> +	code->code = ov9640_codes[code->index];
>>>
>>> And here.
>>>
>>
>> np
>>
>>>> +/* Request bus settings on camera side */
>>>> +static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
>>>> +				struct v4l2_mbus_config *cfg)
>>>> +{
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>>>> +
>>>> +	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
>>>> +		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
>>>> +		V4L2_MBUS_DATA_ACTIVE_HIGH;
>>>
>>> This should come from DT instead. Could you add DT binding documentation
>>> for the sensor, please? There's already some for ov9650; I wonder how
>>> similar that one is.
>>
>> The platform doesn't support it yet, so I have no way to test any DT
>> patches.
> 
> Ack. It's fine to leave that out now.
> 
>>
>>>> +	cfg->type = V4L2_MBUS_PARALLEL;
>>>> +	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct v4l2_subdev_video_ops ov9640_video_ops = {
>>>> +	.s_stream	= ov9640_s_stream,
>>>> +	.g_mbus_config	= ov9640_g_mbus_config,
>>>> +};
>>>> +
>>>> +static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
>>>> +	.enum_mbus_code = ov9640_enum_mbus_code,
>>>> +	.get_selection	= ov9640_get_selection,
>>>> +	.set_fmt	= ov9640_set_fmt,
>>>
>>> Please add an operating to get the format as well.
>>
>> OK, but it will be tested on a preliminary hacked pxa-camera :-).
> 
> That's fine.
> 
>>
>>>
>>>> +};
>>>> +
>>>> +static const struct v4l2_subdev_ops ov9640_subdev_ops = {
>>>> +	.core	= &ov9640_core_ops,
>>>> +	.video	= &ov9640_video_ops,
>>>> +	.pad	= &ov9640_pad_ops,
>>>> +};
>>>> +
>>>> +/*
>>>> + * i2c_driver function
>>>> + */
>>>> +static int ov9640_probe(struct i2c_client *client,
>>>> +			const struct i2c_device_id *did)
>>>> +{
>>>> +	struct ov9640_priv *priv;
>>>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>>>> +	int ret;
>>>> +
>>>> +	if (!ssdd) {
>>>> +		dev_err(&client->dev, "Missing platform_data for driver\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>>>> +	if (!priv)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
>>>> +
>>>> +	v4l2_ctrl_handler_init(&priv->hdl, 2);
>>>> +	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
>>>> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
>>>> +	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
>>>> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
>>>> +	priv->subdev.ctrl_handler = &priv->hdl;
>>>> +	if (priv->hdl.error)
>>>
>>> v4l2_ctrl_handler_free() is missing here. The function would benefit from
>>> goto-based error handling.
>>>
>>
>> + rest -> np
> 
