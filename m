Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1GBSd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 14:33:26 -0400
Message-ID: <4E0F6473.3030309@redhat.com>
Date: Sat, 02 Jul 2011 15:33:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <4E0E6C6E.7050408@redhat.com> <201107021136.31542.hverkuil@xs4all.nl>
In-Reply-To: <201107021136.31542.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-07-2011 06:36, Hans Verkuil escreveu:
> On Saturday, July 02, 2011 02:55:10 Mauro Carvalho Chehab wrote:
>> Em 01-07-2011 12:06, Hans de Goede escreveu:
>>> Hi Hans (et all),
>>>
>>> I've been working on doing a much needed cleanup to the pwc driver,
>>> converting it to videobuf2 and using the new ctrl framework.
>>>
>>> I hope to be able to send a pull request for this, this weekend.
>>>
>>> I saw your pull request and I'm looking forward to be able to
>>> play with ctrl events. I do have some comments on your autofoo
>>> cluster patches and related changes though.
>>>
>>
>> Hi Hans & Hans,
>>
>> I've applied Hans V. patches at the tree, to allow them to be better
>> tested. I'm not 100% comfortable with the patches, and, from my understanding
>> the poll() changes are needed, in order to fix vivi behavior and add the
>> event patches for ivtv. I didn't have much time to test the patches (is qv4l2
>> already ready to test them?)
> 
> I have a version that I use for testing in this repo:
> 
> http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/core
> 
> It's pretty ugly, though. Now that the patches are merged I'll work on cleaning
> it up. I do have patches for v4l2-ctl as well to easily test control events.
> That's good code and I'll commit that today.
> 
> Regarding qv4l2: as long as the poll() situation is not resolved I can't commit
> it to v4l-utils anyway. It is just doesn't work in that specific situation.
> 
>> Due to that, it is probably safer to hold those patches to be merged upstream 
>> at 3.2, after playing with them for a while at the development tree and at -next.
> 
> Note that the only time these patches become problematic is when you want to
> wait on events, and just events. None of these patches will break existing
> applications. It is also not a new problem, we had this issue ever since we
> introduced DQEVENT. It's just that this new control event is more likely to
> be used in situations where this issue is triggered (e.g. qv4l2-like apps).
> 
> Since this control event is also going to be used in embedded applications
> (flash API and the HDMI API we are working on) I am not in favor of delaying
> this an extra kernel cycle. Delaying the qv4l2 changes is another matter of
> course. Those will have to wait. Hmm, I could only enable the control events
> in qv4l2 for drivers that do *not* support the read/write API. That would
> work, I guess. I'll have to think about that a bit.

DQEVENT is used only be one driver, currently (I never count vivi, as it is not really
a driver).

The new control event will not be used by any driver until we solve the poll issue,
so, there's no much sense to hurry and merge it before solving the polling issue, as
we might need to change something, depending on the feedback we'll got from fs people.

Cheers,
Mauro.
