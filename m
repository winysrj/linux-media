Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37298 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbeHOQ4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:56:15 -0400
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8d86aadf-98ee-cde3-766a-5fc8bee11def@xs4all.nl>
Date: Wed, 15 Aug 2018 16:03:54 +0200
MIME-Version: 1.0
In-Reply-To: <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/18 10:16, Paul Kocialkowski wrote:
> Hi Hans and all,
> 
> On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
>> Hi all,
>>
>> While the Request API patch series addresses all the core API issues, there
>> are some high-level considerations as well:
>>
>> 1) How can the application tell that the Request API is supported and for
>>    which buffer types (capture/output) and pixel formats?
>>
>> 2) How can the application tell if the Request API is required as opposed to being
>>    optional?
>>
>> 3) Some controls may be required in each request, how to let userspace know this?
>>    Is it even necessary to inform userspace?
>>
>> 4) (For bonus points): How to let the application know which streaming I/O modes
>>    are available? That's never been possible before, but it would be very nice
>>    indeed if that's made explicit.
> 
> Thanks for bringing up these considerations and questions, which perhaps
> cover the last missing bits for streamlined use of the request API by
> userspace. I would suggest another item, related to 3):
> 
> 5) How can applications tell whether the driver supports a specific
> codec profile/level, not only for encoding but also for decoding? It's
> common for low-end embedded hardware to not support the most advanced
> profiles (e.g. H264 high profile).

Just to point out that this is unrelated to the Request API. I see this as
a separate topic that is probably worth an RFC by itself.

Regards,

	Hans
