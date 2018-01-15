Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55492 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754656AbeAOInU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 03:43:20 -0500
Subject: Re: [RFC PATCH 0/9] media: base request API support
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20171215075625.27028-1-acourbot@chromium.org>
 <8fde3248-97b6-f87a-7d8a-8f9c478697a5@xs4all.nl>
 <CAPBb6MXgMPU+9hQK2uyMLiOvywrPX=L7xiP5TwKzZLNkvbtNyQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b93cf61c-b5fb-1b70-f73c-a84290c4e09c@xs4all.nl>
Date: Mon, 15 Jan 2018 09:43:09 +0100
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXgMPU+9hQK2uyMLiOvywrPX=L7xiP5TwKzZLNkvbtNyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2018 09:24 AM, Alexandre Courbot wrote:
> Hi Hans,
> 
> On Fri, Jan 12, 2018 at 8:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Alexandre,
>>
>> On 12/15/17 08:56, Alexandre Courbot wrote:
>>> Here is a new attempt at the request API, following the UAPI we agreed on in
>>> Prague. Hopefully this can be used as the basis to move forward.
>>>
>>> This series only introduces the very basics of how requests work: allocate a
>>> request, queue buffers to it, queue the request itself, wait for it to complete,
>>> reuse it. It does *not* yet use Hans' work with controls setting. I have
>>> preferred to submit it this way for now as it allows us to concentrate on the
>>> basic request/buffer flow, which was harder to get properly than I initially
>>> thought. I still have a gut feeling that it can be improved, with less back-and-
>>> forth into drivers.
>>>
>>> Plugging in controls support should not be too hard a task (basically just apply
>>> the saved controls when the request starts), and I am looking at it now.
>>>
>>> The resulting vim2m driver can be successfully used with requests, and my tests
>>> so far have been successful.
>>>
>>> There are still some rougher edges:
>>>
>>> * locking is currently quite coarse-grained
>>> * too many #ifdef CONFIG_MEDIA_CONTROLLER in the code, as the request API
>>>   depends on it - I plan to craft the headers so that it becomes unnecessary.
>>>   As it is, some of the code will probably not even compile if
>>>   CONFIG_MEDIA_CONTROLLER is not set
>>>
>>> But all in all I think the request flow should be clear and easy to review, and
>>> the possibility of custom queue and entity support implementations should give
>>> us the flexibility we need to support more specific use-cases (I expect the
>>> generic implementations to be sufficient most of the time though).
>>>
>>> A very simple test program exercising this API is available here (don't forget
>>> to adapt the /dev/media0 hardcoding):
>>> https://gist.github.com/Gnurou/dbc3776ed97ea7d4ce6041ea15eb0438
>>>
>>> Looking forward to your feedback and comments!
>>
>> I think this will become more interesting when the control code is in.
> 
> Definitely.
> 
>> The main thing I've noticed with this patch series is that it is very codec
>> oriented. Which in some ways is OK (after all, that's the first type of HW
>> that we want to support), but the vb2 code in particular should be more
>> generic.
> 
> I don't want to expand too much into use-cases I do not master ; doing
> so would be speculating about how the API will be used. But feel free
> to point out where you think my focus on the codec use-case is not
> future-proof.

The vb2 framework is a core component and it should function properly with
the request API for all drivers using it.

Easiest would be to test this using vivid and vimc. The vb2 code is relatively
simple: all it has to do is keep track of requests and buffers and queue them
up to the driver at the right time. It doesn't really need to know if the driver
is a codec or something else, it's all the same to the framework.

Regards,

	Hans

>> I would also recommend that you start preparing documentation patches: we
>> can review that and make sure all the corner-cases are correctly documented.
>>
>> The public API changes are (I think) fairly limited, but the devil is in
>> the details, so getting that reviewed early on will help you later.
> 
> Yeah, I now regret to have submitted this series without
> documentation. Won't do that mistake again.
> 
>> It's a bit unfortunate that the fence patch series is also making vb2 changes,
>> but I hope that will be merged fairly soon so you can develop on top of that
>> series.
> 
> The fence series may actually make things easier. The vb2 code of this
> series is a bit confusing, and fences add a few extra constraints that
> should make things more predictable. So I am looking forward to being
> able to work on top of it.
> 
