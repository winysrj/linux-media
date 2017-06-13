Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42723 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752167AbdFMGhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 02:37:42 -0400
Subject: Re: [RFC PATCH v3 05/11] [media] vimc: common: Add vimc_link_validate
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-6-git-send-email-helen.koike@collabora.com>
 <1e189fc2-3574-ef52-1b2b-69f0a9e7c7ca@xs4all.nl>
 <9dc67446-6415-0639-0b48-989075f589ee@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <73152b7a-2d10-7a4d-ce09-e28ddb742f22@xs4all.nl>
Date: Tue, 13 Jun 2017 08:37:36 +0200
MIME-Version: 1.0
In-Reply-To: <9dc67446-6415-0639-0b48-989075f589ee@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/12/2017 07:20 PM, Helen Koike wrote:
> Hi Hans,
> 
> Thanks for your review, just a question below
> 
> On 2017-06-12 06:50 AM, Hans Verkuil wrote:
>> On 06/03/2017 04:58 AM, Helen Koike wrote:
>>> +    /* The width, height, code and colorspace must match. */
>>> +    if (source_fmt.format.width != sink_fmt.format.width
>>> +        || source_fmt.format.height != sink_fmt.format.height
>>> +        || source_fmt.format.code != sink_fmt.format.code
>>> +        || source_fmt.format.colorspace != sink_fmt.format.colorspace)
>>
>> Source and/or Sink may be COLORSPACE_DEFAULT. If that's the case, then
>> you should skip comparing ycbcr_enc, quantization or xfer_func. If
>> colorspace
>> is DEFAULT, then that implies that the other fields are DEFAULT as well.
>> Nothing
>> else makes sense in that case.
> 
> I thought that the colorspace couldn't be COLORSPACE_DEFAULT, in the
> documentation it is written "The default colorspace. This can be used by
> applications to let the driver fill in the colorspace.", so the
> colorspace is always set to something different from default no ?
> I thought that the COLORSPACE_DEFAULT was only used by the userspace in
> VIDIOC_{SUBDEV}_S_FMT so say "driver, use wherever colorspace you want",
> but if usespace calls VIDIOC_{SUBDEV}_G_FMT, it would return which exact
> colorspace the driver is using, no?

I don't think this rule works for the MC. For regular v4l2 devices the
bridge driver knows what colorspace it receives so it can replace the
colorspace DEFAULT with the real one.

But a e.g. scaler subdev does not actually touch on the colorspace. And
it doesn't know what colorspace it will receive or transmit.

I don't feel it makes sense to require userspace to set and propagate the
colorspace information throughout the pipeline. Allowing it to be set to
DEFAULT (i.e. 'don't care') makes sense to me.

I might change my mind later on this. The simple fact is that the spec isn't
clear what to do with MC devices. That's also where this vimc driver comes
in, so we can try this out without requiring specialized hardware.

Regards,

	Hans
