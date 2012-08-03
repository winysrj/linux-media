Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49232 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HCFhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 01:37:14 -0400
Received: by yenl2 with SMTP id l2so397145yen.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 22:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208011111.12597.hverkuil@xs4all.nl>
References: <20120713173708.GB17109@thunk.org>
	<5005A14D.8000809@redhat.com>
	<50181CBF.102@redhat.com>
	<201208011111.12597.hverkuil@xs4all.nl>
Date: Fri, 3 Aug 2012 13:37:13 +0800
Message-ID: <CAGA24MJuUdX=d8aEtExNF=Tn86czLh=Vaqyts7V7g6g6YDRyUg@mail.gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
From: Jun Nie <niej0001@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: workshop-2011@linuxtv.org, Rob Clark <rob.clark@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/8/1 Hans Verkuil <hverkuil@xs4all.nl>:
> On Tue 31 July 2012 19:58:23 Mauro Carvalho Chehab wrote:
>> In order to sum-up the discussions around the media summit,
>> this is what we've got so far:
>>
>> Proposals                                                                             proposed by
>> =====================================================================================|=========================================================================================
>> Common device tree bindings for media devices                                         Sylvester Nawrocki / Guennadi Liakhovetski
>> ALSA and V4L/Media Controller                                                         Steven Toth / Laurent Pinchart
>> ARM and needed features for V4L/DVB                                                   Steven Toth
>> Intel media SDK                                                                               Steven Toth
>> V4L compiance tool                                                                    Hans Verkuil
>> V4L2 API ambiguities                                                                  Hans Verkuil
>> Media Controller library                                                              Laurent Pincart / Sakari Ailus
>> SoC Vendors feedback – how to help them to go upstream – Android's V4L2 cam library   Laurent Pincart / Guennadi Liakhovetski / Palash Bandyopadhyay / Naveen Krishnamurthy
>> Synchronization, shared resource and optimizations                                    Pawel Osciak
>> V4L2/DVB issues from userspace perspective                                            Rémi Denis-Courmont
>>
>> As we'll have only one day for the summit, we may need to remove some
>> themes, or maybe to get an extra time during LPC for the remaining
>> discussions.
>>
>> Possible attendents:
>> ===================
>>
>> Guennadi Liakhovetski
>> Laurent Pinchart
>> Mauro Carvalho Chehab
>> Michael Krufky
>> Naveen Krishnamurthy
>> +1 seat from ST (waiting Naveen to define who will be the other seat)
>> Palash Bandyopadhyay
>> Pawel Osciak
>> Rémi Denis-Courmont
>> Sakari Ailus
>> Steven Toth
>> Sylvester Nawrocki
>>
>> Am I missing something?
>>
>> Are there other proposals or people intending to participate?
>
> Yes: I would like to discuss how to add support for HDMI CEC to the kernel.
> In particularly I need some feedback from the GPU driver developers on what
> their ideas are, since CEC is something that touches both V4L2 and GPU.
>
I am not familiar with CEC implementation in GPU. But CEC should be
independent in functionality with audio/video though it is A/V
related. I prefer to support only CEC frame TX/RX in kernel. CEC
include different category features that need parsing and may need
application interaction. Venders may also configure some features as
not supported.  If kernel support more than TX/RX, policy may be
separated to user space part and kernel space part. The kernel
interface also becomes complex, maybe ambiguous too. An user space
library is more suitable for this task to interact with OS/media
player/audio control/etc.

> I'm not sure what the best place is to do this, it's a fairly specialized
> topic. It might be better suited to just get a few interested devs together
> in the evening or during some other suitable time and just see if we can
> hammer out some scheme. I'll have a presentation on the topic ready.
>
> Rob, what are your ideas on this?
>
> Who else might be interested in this?
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
