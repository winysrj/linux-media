Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47583 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751329AbeBBIAm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 03:00:42 -0500
Subject: Re: [RFC PATCH 1/9] media: add request API core and UAPI
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20171215075625.27028-1-acourbot@chromium.org>
 <20171215075625.27028-2-acourbot@chromium.org>
 <20180126083936.5qxacbdprm6j7pcc@valkosipuli.retiisi.org.uk>
 <CAPBb6MVAaGPh-sxD0ZTMbo2Ejtp8Rpqb8+OaKxhAC=BaT360eQ@mail.gmail.com>
 <20180202073316.ovee5fbe45npksnt@paasikivi.fi.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6292179f-4b3d-573b-09c9-7a1efc101d44@xs4all.nl>
Date: Fri, 2 Feb 2018 09:00:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180202073316.ovee5fbe45npksnt@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2018 08:33 AM, Sakari Ailus wrote:

<snip>

>>>> +struct media_request_entity_data *
>>>> +media_request_get_entity_data(struct media_request *req,
>>>> +                           struct media_entity *entity, void *fh)
>>>
>>> This makes the assumption that request data is bound to entities. How does
>>> this work with links?
>>>
>>> I wonder if it should rather be bound to graph objects, or certain graph
>>> objects. Having a standard way to bind request specific information e.g. to
>>> entities is definitely worth having, though.
>>>
>>> V4L2 framework specific information would be needed across the media graph
>>> and it'd be good to store it in a non-driver specific way. What I think
>>> you'd need is an interface that allows storing information based on two
>>> keys --- the request and e.g. a pointer provided by the caller. The V4L2
>>> framework would have one key, e.g. a pointer to an empty struct defined
>>> somewhere in the V4L2 framework could be used for the purpose.
>>>
>>> Going forward, the entire media graph state will be subject to changing
>>> through requests. This includes link state, media bus and pixel formats,
>>> cropping and scaling configurations, everything. Let's not try to go there
>>> yet in this patchset, but what I'm asking is to keep the goal in mind when
>>> implementating the request API.
>>
>> Yeah, I think a similar idea is brought up in the cover letter of the
>> next revision (although for different reasons). Entities are probably
>> not a one-fit for all use-cases.
>>
>> For the case of links though, I believe that the "entity" that would
>> control them would be the media controller itself, since it is the one
>> that takes the MEDIA_IOC_SETUP_LINK ioctl. But even for this case, we
>> cannot use an entity to look up the media_device, so something more
>> generic like an opaque key would probably be needed.
> 
> Perhaps in the near future we still need a little less than that. Changing
> something that has a state in V4L2 will be troublesome and will require
> managing state of what is now stream centric.
> 
> I still think that the framework would need to do the job of managing the
> video buffers related to a request as well as controls without necessarily
> trying to generalise that right now. But how to store these in a meaningful
> way? Putting them to the request itself would be one option: you'll need to
> dig the request up anyway when things are associated to it, and the driver
> needs it when it is queued.
> 
> I wonder what Hans and Laurent think.

I think this is something for the future. I want to avoid delaying the Request
API for endless internal design discussions. The public API should be solid,
but the internal framework will undoubtedly need to change in the future.

That's OK. The reality is that there is a lot of demand for the Request API for
stateless codecs, and that is what we should concentrate on.

Should the framework manage the buffers? I don't even know what is meant with
that exactly, let alone that I can give an answer.

Let's stay focused: 1) solid uAPI, 2) stateless codec support. The internal
framework shouldn't of course make it harder than it needs to to later extend
the support to camera pipelines, but neither should we spend much time on it
or we will never get this in.

Regards,

	Hans
