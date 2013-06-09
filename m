Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44224 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3FIR42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 13:56:28 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so2979848bkc.35
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 10:56:27 -0700 (PDT)
Message-ID: <51B4C1C7.7050002@gmail.com>
Date: Sun, 09 Jun 2013 19:56:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC] Motion Detection API
References: <201304121736.16542.hverkuil@xs4all.nl> <201305061541.41204.hverkuil@xs4all.nl> <2428502.07isB1rKTR@avalon> <201305071435.30062.hverkuil@xs4all.nl> <518909DA.8000407@samsung.com> <20130508162648.GG1075@valkosipuli.retiisi.org.uk> <518ACDDA.3080908@gmail.com> <20130521173037.GD2041@valkosipuli.retiisi.org.uk> <519D3B9E.4090800@gmail.com> <20130603012559.GA2075@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130603012559.GA2075@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/03/2013 03:25 AM, Sakari Ailus wrote:
> On Wed, May 22, 2013 at 11:41:50PM +0200, Sylwester Nawrocki wrote:
>> [...]
>>>>> I'm in favour of using a separate video buffer queue for passing
>>>>> low-level
>>>>> metadata to user space.
>>>>
>>>> Sure. I certainly see a need for such an interface. I wouldn't like to
>>>> see it
>>>> as the only option, however. One of the main reasons of introducing
>>>> MPLANE
>>>> API was to allow capture of meta-data. We are going to finally prepare
>>>> some
>>>> RFC regarding usage of a separate plane for meta-data capture. I'm not
>>>> sure
>>>> yet how it would look exactly in detail, we've just discussed this topic
>>>> roughly with Andrzej.
>>>
>>> I'm fine that being not the only option; however it's unbeatable when it
>>> comes to latencies. So perhaps we should allow using multi-plane buffers
>>> for the same purpose as well.
>>>
>>> But how to choose between the two?
>>
>> I think we need some example implementation for metadata capture over
>> multi-plane interface and with a separate video node. Without such
>> implementation/API draft it is a bit difficult to discuss this further.
>
> Yes, that'd be quite nice.

I still haven't found time to look into that, got stuck with debugging some
hardware related issues which took much longer than expected..

> There are actually a number of things that I think would be needed to
> support what's discussed above. Extended frame descriptors (I'm preparing
> RFC v2 --- yes, really!) are one.

Sounds great, I'm really looking forward to improving this part and 
having it
used in more drivers.

> Also creating video nodes based on how many different content streams there
> are doesn't make much sense to me. A quick and dirty solution would be to
> create a low level metadata queue type to avoid having to create more video
> nodes. I think I'd prefer a more generic solution though.

Hmm, does it mean having multiple buffer queues on a video device node,
similarly to, e.g. the M2M interface ? Not sure if it would have been a bad
idea at all. The number of video/subdev nodes can get ridiculously high in
case of more complex devices. For example in case of the Samsung Exynos
SoC imaging subsystem the total number of various device nodes is getting
near *30*, and it is going to be at least that many for sure once all
functionality is covered.

So one video node per a DMA engine is probably fair rule, but there might
be reasons to avoid adding more device nodes for covering "logical" streams.


Regards,
Sylwester
