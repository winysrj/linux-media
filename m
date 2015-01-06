Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47525 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbbAFNBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 08:01:49 -0500
Message-ID: <54ABDCB6.7070807@xs4all.nl>
Date: Tue, 06 Jan 2015 14:01:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>
CC: linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl> <54943680.3020007@butterbrot.org> <549437DA.6090601@xs4all.nl> <54943CC2.6040803@butterbrot.org> <549443C9.6090900@xs4all.nl> <alpine.DEB.2.02.1501061018580.3223@butterbrot> <54ABAC8C.6020401@xs4all.nl> <54ABB641.7050002@butterbrot.org> <54ABB79D.7010700@xs4all.nl> <54ABD08C.7010107@butterbrot.org>
In-Reply-To: <54ABD08C.7010107@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2015 01:09 PM, Florian Echtler wrote:
> On 06.01.2015 11:23, Hans Verkuil wrote:
>> On 01/06/2015 11:17 AM, Florian Echtler wrote:
>>>> You're not filling in the 'field' field of struct v4l2_buffer when returning a
>>>> frame. It should most likely be FIELD_NONE in your case.
>>>>>  		fail: v4l2-test-buffers.cpp(611): buf.check(q, last_seq)
>>>>>  		fail: v4l2-test-buffers.cpp(884): captureBufs(node, q, m2m_q, frame_count, false)
>>> OK, easy to fix. This will also influence the other two warnings, I assume?
>> Most likely, yes.
> Done. I would say that it's nearly ready for submission now (all tests
> from v4l2-compliance -s pass), I still have to sort out all the warnings
> from scripts/checkpatch.pl.
> 
>>>>> On a different note, I'm getting occasional warnings in syslog when I run 
>>>>> a regular video streaming application (e.g. cheese):
>>> Is there another possible explanation?
>> No :-)
>> You are still missing a buffer somewhere. I'd have to see your latest source code
>> to see what's wrong.
> Weirdly enough, the syslog warning/error doesn't seem to occur anymore
> since I've fixed the v4l2_buffer field. Perhaps some oddity within cheese?
> 
> I'm attaching the current source again for you to maybe have another
> look; I will submit a proper patch in the next days.

Just a few quick remarks:

- run scripts/checkpatch.pl over your source, I'm fairly certain it will complain
  about several constructs.
- use videobuf2-vmalloc instead of dma-contig. There is no DMA involved, so there
  is no reason to use dma-contig.
- Don't set V4L2_CAP_EXT_PIX_FORMAT in querycap: it will be set automatically by
  the v4l2 core.

Regards,

	Hans
