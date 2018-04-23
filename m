Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:49237 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755762AbeDWPLB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:11:01 -0400
Subject: Re: [RFCv11 PATCH 00/29] Request API
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
 <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
 <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
 <d9fa6ca0e79672dc523e1c56ba19ec07c5d5259d.camel@bootlin.com>
 <CAPBb6MW9f6MPxMj9W8TMfqdhEMYZPX85w3y159sL5kQq5jjsBA@mail.gmail.com>
 <ffde372d4e8ec711743459314de35437efd218a0.camel@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e477bdcc-2388-0c4a-8af1-33a80a684cc0@xs4all.nl>
Date: Mon, 23 Apr 2018 17:10:57 +0200
MIME-Version: 1.0
In-Reply-To: <ffde372d4e8ec711743459314de35437efd218a0.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

On 04/19/2018 09:48 AM, Paul Kocialkowski wrote:
> Hi,
> 
> On Wed, 2018-04-18 at 02:06 +0000, Alexandre Courbot wrote:
>> On Tue, Apr 17, 2018 at 8:41 PM Paul Kocialkowski <
>> paul.kocialkowski@bootlin.com> wrote:
>> On Tue, 2018-04-17 at 06:17 +0000, Alexandre Courbot wrote:
>>>> On Tue, Apr 17, 2018 at 3:12 PM Hans Verkuil <hverkuil@xs4all.nl>
>>>> wrote:
>>>>
>>>>> On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
>>>>>> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.
>>>>>> nl>
>>>>>> wrote:
>>>>>>
>>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>> Hi all,
>>>>>>> This is a cleaned up version of the v10 series (never posted
>>>>>>> to
>>>>>>> the list since it was messy).
>>>>>>
>>>>>> Hi Hans,
>>>>>>
>>>>>> It took me a while to test and review this, but finally have
>>>>>> been
>>>>>> able
>>>>
>>>> to
>>>>>> do it.
>>>>>>
>>>>>> First the result of the test: I have tried porting my dummy
>>>>>> vim2m
>>>>>> test
>>>>>> program
>>>>>> (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a
>>>>>> 42
>>>>>> for
>>>>>> reference),
>>>>>> and am getting a hang when trying to queue the second OUTPUT
>>>>>> buffer
>>>>
>>>> (right
>>>>>> after
>>>>>> queuing the first request). If I move the calls the
>>>>>> VIDIOC_STREAMON
>>>>
>>>> after
>>>>>> the
>>>>>> requests are queued, the hang seems to happen at that moment.
>>>>>> Probably a
>>>>>> deadlock, haven't looked in detail yet.
>>>>>>
>>>>>> I have a few other comments, will follow up per-patch.
>>>>>>
>>>>>
>>>>> I had a similar/same (?) report about this from Paul:
>>>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg1291
>>>>> 77.h
>>>>> tml
>>>>
>>>> I saw this and tried to move the call to STREAMON to after the
>>>> requests are queued in my example program, but it then hanged
>>>> there.
>>>> So there is probably something more intricate taking place.
>>> I figured out the issue (but forgot to report back to the list):
>>> Hans'
>>> version of the request API doesn't set the POLLIN bit but POLLPRI
>>> instead, so you need to select for expect_fds instead of read_fds in
>>> the
>>> select call. That's pretty much all there is to it.
>>
>> I am not using select() but poll() in my test program (see the gist
>> link
>> above) and have set POLLPRI as the event to poll for. I may be missing
>> something but this looks correct to me?
> 
> You're right, I overlooked your email and assumed you were hitting the
> same issue that I had at first.
> 
> Anyway, I also had a similar issue when calling the STREAMON ioctl
> *before* enqueuing the request. What happens here is that
> v4l2_m2m_streamon (called from the ioctl) will also try to schedule a
> device run (v4l2_m2m_try_schedule). When the ioctl is called and the
> request was not queued yet, the lack of buffers will delay the streamon
> call. Then, when the request is later submitted, vb2_streamon is called
> with the queue directly, and there is no m2m-specific provision there,
> so no device run is scheduled and nothing happens. If the STREAMON ioctl
> happens after queuing the request, then things should be fine (but
> that's definitely not what we want userspace to be doing) since
> the vb2_streamon call from the ioctl handler will take effect
> and v4l2_m2m_try_schedule will be called.
> 
> The way that I have solved this with the Sunxi-Cedrus driver is to add a
> req_complete callback function pointer (holding a call
> to v4l2_m2m_try_schedule) in media_device_ops and call it (if available)
> from media_request_ioctl_queue. I initially put this in req_queue
> directly, but since it is wrapped by the request queue mutex lock and
> provided that device_run needs to access the request queue, we need an
> extra op called out of this lock, before completing the ioctl handler.
> 
> I will be sending v2 of my driver with preliminary patches to fix this
> (perhaps I should also fix vim2m that way along the way).

Can you verify that this indeed solves your problem? Or is there still
something else going on?

Regards,

	Hans
