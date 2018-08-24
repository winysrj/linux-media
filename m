Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44656 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbeHXLDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:03:20 -0400
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl>
 <f4d1e18a6552446b092cffaa3028e0dfe5432b9a.camel@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <26ae963d-3326-2506-b116-0a5f64b34c3d@xs4all.nl>
Date: Fri, 24 Aug 2018 09:29:53 +0200
MIME-Version: 1.0
In-Reply-To: <f4d1e18a6552446b092cffaa3028e0dfe5432b9a.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2018 07:37 PM, Nicolas Dufresne wrote:
> Le jeudi 23 août 2018 à 16:31 +0200, Hans Verkuil a écrit :
>>> I propose adding these capabilities:
>>>
>>> #define V4L2_BUF_CAP_HAS_REQUESTS     0x00000001
>>> #define V4L2_BUF_CAP_REQUIRES_REQUESTS        0x00000002
>>> #define V4L2_BUF_CAP_HAS_MMAP         0x00000100
>>> #define V4L2_BUF_CAP_HAS_USERPTR      0x00000200
>>> #define V4L2_BUF_CAP_HAS_DMABUF               0x00000400
>>
>> I substituted SUPPORTS for HAS and dropped the REQUIRES_REQUESTS capability.
>> As Tomasz mentioned, technically (at least for stateless codecs) you could
>> handle just one frame at a time without using requests. It's very inefficient,
>> but it would work.
> 
> I thought the request was providing a data structure to refer back to
> the frames, so each codec don't have to implement one. Do you mean that
> the framework will implicitly request requests in that mode ? or simply
> that there is no such helper ?

Yes, that's done through controls as well.

The idea would be that you set the necessary controls, queue a buffer to
the output queue, dequeue a buffer from the output queue, read back any
new state information and repeat the process.

That said, I'm not sure if the cedrus driver for example can handle this
at the moment. It is also inefficient and it won't work if codecs require
more than one buffer in the queue for whatever reason.

Tomasz, Paul, please correct me if I am wrong.

In any case, I think we can do without this proposed capability since it is
simply a requirement when implementing the pixelformat for the stateless
codec that the Request API will be available and it should be documented
as such in the spec.

Regards,

	Hans
