Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41197 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbeJRHmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 03:42:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23-v6so13261856pgc.8
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 16:44:09 -0700 (PDT)
Subject: Re: [PATCH v3 10/16] gpu: ipu-v3: image-convert: select optimal seam
 positions
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
 <20180918093421.12930-11-p.zabel@pengutronix.de>
 <d3e2a6ec-2961-2f97-7a53-d016bc6ad515@gmail.com>
 <1539774637.4729.3.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7c8c78c0-48ce-4768-c327-7797afec31ad@gmail.com>
Date: Wed, 17 Oct 2018 16:44:06 -0700
MIME-Version: 1.0
In-Reply-To: <1539774637.4729.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 10/17/18 4:10 AM, Philipp Zabel wrote:
> On Fri, 2018-10-12 at 17:33 -0700, Steve Longerbeam wrote:
>> On 09/18/2018 02:34 AM, Philipp Zabel wrote:
>>
>> <snip>
>>> +/*
>>> + * Tile left edges are required to be aligned to multiples of 8 bytes
>>> + * by the IDMAC.
>>> + */
>>> +static inline u32 tile_left_align(const struct ipu_image_pixfmt *fmt)
>>> +{
>>> +	return fmt->planar ? 8 * fmt->uv_width_dec : 64 / fmt->bpp;
>>> +}
>> <snip>
>>
>> As I indicated, shouldn't this be
>>
>> return fmt->planar ? 8 * fmt->uv_width_dec : 8;
>>
>> ?
>>
>> Just from a unit analysis perspective, "64 / fmt->bp" has
>> units of pixels / 8-bytes, it should have units of bytes.
> The tile alignment is in pixels, not in bytes.


Ah, yes of course you are right, I used to know this :) I am
loosing track of this code.


>   For 16-bit and 32-bit
> packed formats, we only need to align to 4 or 2 pixels, respectively,
> as the LCM of 8-byte alignment and 2-byte or 4-byte pixel size is
> always 8 bytes.


Yes I agree, the LCM of 8-byte alignment and bytes-per-pixel should
be the tile left edge alignment in pixels.


> But now that you pointed it out, it is quite obvious that this can't
> work for 24-bit packed formats. Here the LCM of 8-byte alignment and 3-
> byte pixels is 24 bytes, or 8 pixels.
>
> How about:
>
> 	if (fmt->planar)
> 		return fmt->uv_packed ? 8 : 8 * fmt->uv_width_dec;
> 	else
> 		return fmt->bpp == 32 ? 2 : fmt->bpp == 16 ? 4 : 8;


Yep, that looks better. I tested this and it works fine.

Steve
