Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:46699 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936172AbeEYORB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 10:17:01 -0400
Date: Fri, 25 May 2018 17:16:57 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: Re: RFC: Request API and memory-to-memory devices
Message-ID: <20180525141655.ugmd7xki4nsqz2pg@kekkonen.localdomain>
References: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, May 24, 2018 at 10:44:13AM +0200, Hans Verkuil wrote:
> Memory-to-memory devices have one video node, one internal control handler
> but two vb2_queues (DMA engines). While often there is one buffer produced
> for every buffer consumed, but this is by no means standard. E.g. deinterlacers
> will produce on buffer for every two buffers consumed. Codecs that receive
> a bit stream and can parse it to discover the framing may have no relation
> between the number of buffers consumed and the number of buffers produced.

Do you have examples of such devices? I presume they're not supported in
the current m2m API either, are they?

> 
> This poses a few problems for the Request API. Requiring that a request
> contains the buffers for both output and capture queue will be difficult
> to implement, especially in the latter case where there is no relationship
> between the number of consumed and produced buffers.
> 
> In addition, userspace can make two requests: one for the capture queue,
> one for the output queue, each with associated controls. But since the
> controls are shared between capture and output there is an issue of
> what to do when the same control is set in both requests.

As I commented on v13, the two requests need to be handled separately in
this case. Mem-to-mem devices are rather special in this respect; there's
an established practice of matching buffers in the order they arrive from
the queues, but that's not how the request API is intended to work: the
buffers are associated to the request, and a request is processed
independently of other requests.

While that approach might work for mem-to-mem devices at least in some use
cases, it is not a feasible approach for other devices. As a consequence,
will have different API semantics between mem2mem devices and the rest. I'd
like to avoid that if possible: this will be similarly visible in the user
applications as well.

> 
> I propose to restrict the usage of requests for m2m drivers to the output
> queue only. This keeps things simple for both kernel and userspace and
> avoids complex solutions.

If there's a convincing reason to use different API semantics, such as the
relationship between different buffers being unknown to the user, then
there very likely is a need to associate non-request data with
request-bound data in the driver. But it'd be better to limit it to where
it's really needed.

> 
> Requests only make sense if there is actually configuration you can apply
> for each buffer, and while that's true for the output queue, on the capture
> queue you just capture the result of whatever the device delivers. I don't
> believe there is much if anything you can or want to control per-buffer.

May there be controls associated with the capture queue buffers?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
