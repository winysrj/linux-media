Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56044 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751474AbdGZMhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 08:37:31 -0400
Subject: Re: [PATCH v4] uvcvideo: add a metadata device node
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1707071536440.9200@axis700.grange>
 <3406101.2MuKeu43r1@avalon> <Pine.LNX.4.64.1707240958280.4948@axis700.grange>
 <Pine.LNX.4.64.1707261316010.6259@axis700.grange>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <61413236-ac5c-474d-5dd4-5fd34f8ffcf8@xs4all.nl>
Date: Wed, 26 Jul 2017 14:37:22 +0200
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1707261316010.6259@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/17 14:29, Guennadi Liakhovetski wrote:
> On Tue, 25 Jul 2017, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>>> +struct uvc_meta_buf {
>>>> +	struct timespec ts;
>>>
>>> timespec has a different size on 32-bit and 64-bit architectures, so there
>>> could be issues on 32-bit userspace running on a 64-bit kernel.
>>>
>>> Additionally, on 32-bit platforms, timespec is not year 2038-safe. I thought
>>> that timespec64 was exposed to userspace nowadays, but it doesn't seem to be
>>> the case. I'm not sure how to handle this.
>>
>> Oh, that isn't good :-/ I'll have to think more about this. If you get any 
>> more ideas, I'd be glad to hear them too.
> 
> Shall we just use nanoseconds here too then, as returned by 
> timespec_to_ns(), just like in frame timestamps?

That's what I use and what Arnd recommended for use in public APIs. It's a u64, so easy
to work with.

Don't use timespec/timeval in any new public APIs, that will only cause a mess later.

Regards,

	Hans
