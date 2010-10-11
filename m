Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:54905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab0JKPsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:48:55 -0400
Message-ID: <4CB331DD.9030806@infradead.org>
Date: Mon, 11 Oct 2010 12:48:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: David Ellingsworth <david@identd.dyndns.org>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
References: <201009261425.00146.hverkuil@xs4all.nl> <AANLkTimWCHHP5MOnXpXpoRyfxRd5jj6=0DHpj7uoVS2E@mail.gmail.com> <201010111740.14658.hverkuil@xs4all.nl>
In-Reply-To: <201010111740.14658.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-10-2010 12:40, Hans Verkuil escreveu:
> On Sunday, October 10, 2010 19:33:48 David Ellingsworth wrote:
>> Hans,
>>
>> On Sun, Sep 26, 2010 at 8:25 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> Hi Mauro,
>>>
>>> These are the locking patches. It's based on my previous test tree, but with
>>> more testing with em28xx and radio-mr800 and some small tweaks relating to
>>> disconnect handling and video_is_registered().
>>>
>>> I also removed the unused get_unmapped_area file op and I am now blocking
>>> any further (unlocked_)ioctl calls after the device node is unregistered.
>>> The only things an application can do legally after a disconnect is unmap()
>>> and close().
>>>
>>> This patch series also contains a small em28xx fix that I found while testing
>>> the em28xx BKL removal patch.
>>>
>>> Regards,
>>>
>>>        Hans
>>>
>>> The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
>>>  Hans Verkuil (1):
>>>        V4L/DVB: tvaudio: remove obsolete tda8425 initialization
>>>
>>> are available in the git repository at:
>>>
>>>  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl
>>>
>>> Hans Verkuil (10):
>>>      v4l2-dev: after a disconnect any ioctl call will be blocked.
>>>      v4l2-dev: remove get_unmapped_area
>>>      v4l2: add core serialization lock.
>>>      videobuf: prepare to make locking optional in videobuf
>>>      videobuf: add ext_lock argument to the queue init functions
>>>      videobuf: add queue argument to videobuf_waiton()
>>>      vivi: remove BKL.
>>>      em28xx: remove BKL.
>>>      em28xx: the default std was not passed on to the subdevs
>>>      radio-mr800: remove BKL
>>
>> Did you even test these patches?
> 
> Yes, I did test. And it works for me. But you are correct in that it shouldn't
> work since the struct will indeed be freed. I'll fix this and post a patch.
> 
> I'm not sure why it works fine when I test it.
> 
> There is a problem as well with unlocking before unregistering the device in
> that it leaves a race condition where another app can open the device again
> before it is registered. I have to think about that some more.
> 
>> The last one in the series clearly
>> breaks radio-mr800 and the commit message does not describe the
>> changes made. radio-mr800 has been BKL independent for quite some
>> time. Hans, you of all people should know that calling
>> video_unregister_device could result in the driver specific structure
>> being freed.
> 
> Jeez, relax. I'm human (really!).
> 
>> The mutex must therefore be unlocked _before_ calling
>> video_unregister_device. Otherwise you're passing freed memory to
>> mutex_unlock in usb_amradio_disconnect.
>>
>> If each patch had been properly posted to the list, others might have
>> caught issues like this earlier. Posting a link to a repository is no
>> substitute for this process.
>>
>> Mauro, you should be ashamed for accepting a series that obviously has issues.
> 
> Hardly obvious, and definitely not his fault.

Hans,

This is a somewhat recurring discussion at #v4l irc nowadays. Next time, please 
send your patch series first to the ML, tagged with [PATCH RFC] especially if they 
touch ondrivers that you're not the maintainer or when you weren't able to test.

Thanks,
Mauro
