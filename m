Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA57C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5399222BB
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390940AbfBMI7r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:59:47 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:43817 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727264AbfBMI7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 03:59:46 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id tqOKgPXsuI8AWtqOOguM66; Wed, 13 Feb 2019 09:59:44 +0100
Subject: Re: [PATCH v3] media: docs-rst: Document m2m stateless video decoder
 interface
To:     Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
References: <20190213055317.192029-1-acourbot@chromium.org>
 <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b24e3e67-9fb3-3602-8a90-826f8c51eadf@xs4all.nl>
Date:   Wed, 13 Feb 2019 09:59:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUDK0s665wjSjvo3ZePtmFXFrs2WqpaywOSjnRxp08Ong@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfL4Om9XspFbKWlhmGIHJMa+SyqsJXxdSNpDZhj1uzfppZgE82vLfF/BGvOrwO2Hd6IAM+CRKBA5Sjdf5bS6+AqIcBQzt+CTWHUp/KHQZrDKex9WuyFd9
 qInoenHhNRNSeWdL0pl4G4PFMKgQy6y6BosrqcPLMNz4KCJV2lg0OakP6FbR+w4CFU3KyFRsnniw+FYImPs9t3Xm6bMymDnrC0D2HaVhiI4L53aUFXeZ334R
 uW7Hh4kE4v0ICa6O2qQwrNjqltKJBqJxrcZU7zrsm17F+FcqQuwnMSGOwTkBH4dEomEW27/D1lKLhmiS5jTyOqTciptdO9NWwJkzCWe3XdtHX95RQqhYqaiT
 n1VpDPSnMhT/9YfuR5MTtDrF3qdoFyMWu7RejAXI1zyoT7YcIiTAD4QTwbXatt1casv6hI7E
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/13/19 6:58 AM, Alexandre Courbot wrote:
> On Wed, Feb 13, 2019 at 2:53 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>> [snip]
>> +Buffers used as reference frames can be queued back to the ``CAPTURE`` queue as
>> +soon as all the frames they are affecting have been queued to the ``OUTPUT``
>> +queue. The driver will refrain from using the reference buffer as a decoding
>> +target until all the frames depending on it are decoded.
> 
> Just want to highlight this part in order to make sure that this is
> indeed what we agreed on. The recent changes to vb2_find_timestamp()
> suggest this, but maybe I misunderstood the intent. It makes the
> kernel responsible for tracking referenced buffers and not using them
> until all the dependent frames are decoded, something the client could
> also do.

I don't think this is quite right. Once this patch https://patchwork.linuxtv.org/patch/54275/
is in the vb2 core will track when a buffer can no longer be used as a
reference buffer because the underlying memory might have disappeared.

The core does not check if it makes sense to use a buffer as a reference
frame, just that it is valid memory.

So the driver has to check that the timestamp refers to an existing
buffer, but userspace has to check that it queues everything in the
right order and that the reference buffer won't be overwritten
before the last output buffer using that reference buffer has been
decoded.

So I would say that the second sentence in your paragraph is wrong.

The first sentence isn't quite right either, but I am not really sure how
to phrase it. It is possible to queue a reference buffer even if
not all output buffers referring to it have been decoded, provided
that by the time the driver starts to use this buffer this actually
has happened.

But this is an optimization and theoretically it can depend on the
driver behavior. It is always safe to only queue a reference frame
when all frames depending on it have been decoded. So I am leaning
towards not complicating matters and keeping your first sentence
as-is.

Regards,

	Hans
