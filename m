Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48025 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdC0P3d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:29:33 -0400
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
 <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
Cc: linux-media@vger.kernel.org, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Helen Koike <helen.koike@collabora.co.uk>
Message-ID: <ef7c1d62-0553-2c5b-004f-527d82e380b3@collabora.co.uk>
Date: Mon, 27 Mar 2017 12:19:51 -0300
MIME-Version: 1.0
In-Reply-To: <f8466f7a-0f33-a610-10fc-2515d5f6b499@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-03-26 10:31 AM, Sakari Ailus wrote:
> Hi Helen,
>
> ...
>> +static int vimc_cap_enum_input(struct file *file, void *priv,
>> +			       struct v4l2_input *i)
>> +{
>> +	/* We only have one input */
>> +	if (i->index > 0)
>> +		return -EINVAL;
>> +
>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
>> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));
>> +
>> +	return 0;
>> +}
>> +
>> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
>> +{
>> +	/* We only have one input */
>> +	*i = 0;
>> +	return 0;
>> +}
>> +
>> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
>> +{
>> +	/* We only have one input */
>> +	return i ? -EINVAL : 0;
>> +}
>
> You can drop the input IOCTLs altogether here. If you had e.g. a TV
> tuner, it'd be the TV tuner driver's responsibility to implement them.
>

input IOCTLs seems to be mandatory from v4l2-compliance when capability 
V4L2_CAP_VIDEO_CAPTURE is set (which is the case):

https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-input-output.cpp#n418

https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-compliance.cpp#n989

Helen
