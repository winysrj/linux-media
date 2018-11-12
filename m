Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36403 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728651AbeKLRy2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 12:54:28 -0500
Subject: Re: [RFC PATCH 0/5] vb2/cedrus: add cookie support
To: Alexandre Courbot <acourbot@chromium.org>
Cc: linux-media@vger.kernel.org, maxime.ripard@bootlin.com,
        paul.kocialkowski@bootlin.com, tfiga@chromium.org
References: <20181109095613.28272-1-hverkuil@xs4all.nl>
 <CAPBb6MUXo4UCOSGCkjs7c9LW5BSWCBXM4LSDLN9vvZ_KVqHecg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b9ef5f45-e329-aba0-2a08-830e68a12a68@xs4all.nl>
Date: Mon, 12 Nov 2018 09:02:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUXo4UCOSGCkjs7c9LW5BSWCBXM4LSDLN9vvZ_KVqHecg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2018 08:07 AM, Alexandre Courbot wrote:
> Hi Hans,
> 
> On Fri, Nov 9, 2018 at 6:56 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> As was discussed here (among other places):
>>
>> https://lkml.org/lkml/2018/10/19/440
>>
>> using capture queue buffer indices to refer to reference frames is
>> not a good idea. A better idea is to use 'cookies' (a better name is
>> welcome!)
> 
> Maybe "tag" is more common for that kind of usage, but "cookie" is
> fine as well IMHO.

'tag' is MUCH better than cookie. I'll rename and thank you for this
excellent suggestion. That's really what we do: tagging buffers.

Regards,

	Hans

> 
> I can only comment on patches 1-4, but so far it seems to me that this
> would work. I will use this to base the next stateless codec API RFC.
> 
> Thanks!
> Alex.
> 
