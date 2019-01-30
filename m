Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F93EC282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383D320869
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfA3Hr0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:47:26 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56450 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbfA3Hr0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:47:26 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id okaegyz0mBDyIokahgtqPz; Wed, 30 Jan 2019 08:47:24 +0100
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core
 driver
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
 <20190118133716.29288-3-m.tretter@pengutronix.de>
 <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
 <9e29f43951bf25708060bc25f4d1e94756970ee2.camel@ndufresne.ca>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f983efdb-4ac1-d2e2-4be3-421d337f94ef@xs4all.nl>
Date:   Wed, 30 Jan 2019 08:47:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9e29f43951bf25708060bc25f4d1e94756970ee2.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfO58rVx2RgIrHqppHRkLYXxUPoN07pNPP+cAQUIOaXPWJuDvxkC2zfWuZgvBeO76F7DUmlcKxmRO7Vj9DuzlIZ0uTUA1fLi8TqxQemtCU/TMihH/W+G1
 O0M/9TIlYyLXnpG3wBYFEwhyEjGOTJCtdZg3qKwVP8JTCLDksnA6lAMPsI7U6dgVd7/iwYIudxT9qgjcA5uobIHwqPmR7KcRmaaN3jnBrgCTqvl5cQBspM8E
 Jv6ArXjA+b69dL1RLEG5M9U7DctLah9MvD60nc7j2Pln0FtxUVnEuRem3qeUnjqMjoWDDqoQi7GkSmwdQbjS0zr1ePffxKPsQaM2I7iz2HfLBBQ8awaNsuQf
 wIGp5xs7F4TOb4jP0YBDfvDoCKC6c9ERVGIYNNcSQREguluF1C6qWvIEkNYdwetscrJwH91+
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/30/19 4:41 AM, Nicolas Dufresne wrote:
> Hi Hans,
> 
> Le mercredi 23 janvier 2019 à 11:44 +0100, Hans Verkuil a écrit :
>>> +     if (*nplanes != 0) {
>>> +             if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>>> +                     if (*nplanes != 1 ||
>>> +                         sizes[0] < channel->sizeimage_encoded)
>>> +                             return -EINVAL;
>>
>> Question relating to calculating sizeimage_encoded: is that guaranteed to be
>> the largest buffer size that is needed to compress a frame? What if it is
>> not large enough after all? Does the encoder protect against that?
>>
>> I have a patch pending that allows an encoder to spread the compressed
>> output over multiple buffers:
>>
>> https://patchwork.linuxtv.org/patch/53536/
>>
>> I wonder if this encoder would be able to use it.
> 
> Userspace around most existing codecs expect well framed capture buffer
> from the encoder. Spreading out the buffer will just break this
> expectation.
> 
> This is specially needed for VP8/VP9 as these format are not meant to
> be streamed that way.

Good to know, thank you.

> I believe a proper solution to that would be to hang the decoding
> process and send an event (similar to resolution changes) to tell user
> space that capture buffers need to be re-allocated.

That's indeed an alternative. I wait for further feedback from Tomasz
on this.

I do want to add that allowing it to be spread over multiple buffers
also means more optimal use of memory. I.e. the buffers for the compressed
data no longer need to be sized for the worst-case size.

Regards,

	Hans
