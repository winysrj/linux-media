Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:61540 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbeFDQsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 12:48:06 -0400
Subject: Re: [PATCH v2 01/10] media: imx-csi: Pass sink pad field to
 ipu_csi_init_interface
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Steve Longerbeam <slongerbeam@gmail.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-2-git-send-email-steve_longerbeam@mentor.com>
 <1527859350.5913.4.camel@pengutronix.de>
 <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com> <m3o9grnmwy.fsf@t19.piap.pl>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <74a76dfd-3059-2fc1-5e8a-885ae1b0edb5@mentor.com>
Date: Mon, 4 Jun 2018 09:47:59 -0700
MIME-Version: 1.0
In-Reply-To: <m3o9grnmwy.fsf@t19.piap.pl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/03/2018 10:25 PM, Krzysztof Hałasa wrote:
> Steve Longerbeam <slongerbeam@gmail.com> writes:
>
>> I think we should return to enforcing field order to userspace that
>> matches field order from the source, which is what I had implemented
>> previously. I agree with you that we should put off allowing inverting
>> field order.
> There is no any particular field order at the source, most of the time.
> The odd field is followed by the even field, and so on, sure. But there
> is no "first" and "second" field, any field can be the "first".

I think you misunderstood me. Of course there is a first and second
field. By first I am referring to the first field transmitted, which could
be top or bottom.

> The exception to this is a camera with a progressive sensor - both
> "fields" are taken at the same time and transmitted one after the other,
> so in this case the order is defined (by the camera, e.g. B-T on DV even
> with PAL version). But this isn't exactly PAL/NTSC.

Progressive sensors have no fields, the entire image is captured at
once as you said.

Steve
