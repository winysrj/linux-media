Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57883 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936185AbeEYP0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:26:40 -0400
Subject: Re: RFC: Request API and memory-to-memory devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
 <20180525141655.ugmd7xki4nsqz2pg@kekkonen.localdomain>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f5db7cca-02b7-4ff7-ce4d-a1c5dcf8bf20@xs4all.nl>
Date: Fri, 25 May 2018 17:26:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180525141655.ugmd7xki4nsqz2pg@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/05/18 16:16, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, May 24, 2018 at 10:44:13AM +0200, Hans Verkuil wrote:
>> Memory-to-memory devices have one video node, one internal control handler
>> but two vb2_queues (DMA engines). While often there is one buffer produced
>> for every buffer consumed, but this is by no means standard. E.g. deinterlacers
>> will produce on buffer for every two buffers consumed. Codecs that receive
>> a bit stream and can parse it to discover the framing may have no relation
>> between the number of buffers consumed and the number of buffers produced.
> 
> Do you have examples of such devices? I presume they're not supported in
> the current m2m API either, are they?
> 
>>
>> This poses a few problems for the Request API. Requiring that a request
>> contains the buffers for both output and capture queue will be difficult
>> to implement, especially in the latter case where there is no relationship
>> between the number of consumed and produced buffers.
>>
>> In addition, userspace can make two requests: one for the capture queue,
>> one for the output queue, each with associated controls. But since the
>> controls are shared between capture and output there is an issue of
>> what to do when the same control is set in both requests.
> 
> As I commented on v13, the two requests need to be handled separately in
> this case. Mem-to-mem devices are rather special in this respect; there's
> an established practice of matching buffers in the order they arrive from
> the queues, but that's not how the request API is intended to work: the
> buffers are associated to the request, and a request is processed
> independently of other requests.
> 
> While that approach might work for mem-to-mem devices at least in some use
> cases, it is not a feasible approach for other devices. As a consequence,
> will have different API semantics between mem2mem devices and the rest. I'd
> like to avoid that if possible: this will be similarly visible in the user
> applications as well.
> 
>>
>> I propose to restrict the usage of requests for m2m drivers to the output
>> queue only. This keeps things simple for both kernel and userspace and
>> avoids complex solutions.
> 
> If there's a convincing reason to use different API semantics, such as the
> relationship between different buffers being unknown to the user, then
> there very likely is a need to associate non-request data with
> request-bound data in the driver. But it'd be better to limit it to where
> it's really needed.
> 
>>
>> Requests only make sense if there is actually configuration you can apply
>> for each buffer, and while that's true for the output queue, on the capture
>> queue you just capture the result of whatever the device delivers. I don't
>> believe there is much if anything you can or want to control per-buffer.
> 
> May there be controls associated with the capture queue buffers?
> 

In theory that could happen for m2m devices, but those controls would be different
from controls associated with the output queue.

The core problem is that if there is no clear relationship between capture
and output buffers, then you cannot add a capture and an output buffer to
the same request. That simply wouldn't work.

How to signal this to the user? For m2m devices we could just specify that
in the spec and check this in the core. As Tomasz said, m2m devices are
already sufficiently special that I don't think this is a problem. But in
the more generic case (complex pipelines) I cannot off-hand think of something
elegant.

I guess I would have to sleep on this a bit.

Regards,

	Hans
