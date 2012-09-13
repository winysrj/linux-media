Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab2IMXXt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 19:23:49 -0400
Message-ID: <50526AFE.20003@redhat.com>
Date: Thu, 13 Sep 2012 20:23:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208161649.43284.hverkuil@xs4all.nl> <CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com> <201208162049.35773.hverkuil@xs4all.nl> <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com> <20120913201958.266fee52@infradead.org>
In-Reply-To: <20120913201958.266fee52@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-09-2012 20:19, Mauro Carvalho Chehab escreveu:
> Em Sat, 18 Aug 2012 11:48:52 -0400
> Steven Toth <stoth@kernellabs.com> escreveu:
> 
>> Mauro, please read below, a new set of patches I'm submitting for merge.
>>
>> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On Thu August 16 2012 19:39:51 Steven Toth wrote:
>>>>>> So, I've ran v4l2-compliance and it pointed out a few things that I've
>>>>>> fixed, but it also does a few things that (for some reason) I can't
>>>>>> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
>>>>>> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
>>>>>> it actually receives 0x0. This feels more like a bug in the test.
>>>>>> Either way, I have some if (std & ATSC) return -EINVAL, but it still
>>>>>> appears to fail the test.
>>>>
>>>> Oddly enough. If I set tvnorms to something valid, then compliance
>>>> passes but gstreamer
>>>> fails to run, looks like some kind of confusion about either the
>>>> current established
>>>> norm, or a failure to establish a norm.
>>>>
>>>> For the time being I've set tvnorms to 0 (with a comment) and removed
>>>> current_norm.
>>>
>>> Well, this needs to be sorted, because something is clearly amiss.
>>
>> Agreed. I just can't see what's wrong. I may need your advise /
>> eyeballs on this. I'd be willing to provide logs that show gstreamer
>> accessing the driver and exiting. It needs fixed, I've tried, I just
>> can't see why gstreamer fails.
>>
>> On the main topic of merge.... As promised, I spent quite a bit of
>> time this week reworking the code based on the feedback. I also
>> flattened all of these patches into a single patchset and upgraded to
>> the latest re-org tree.
>>
>> The source notes describe in a little more detail the major changes:
>> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
>>
>> Mauro, so, I hereby submit for your review/merge again, the updated
>> patchset. *** Please comment. ***
> 
> I'll comment patch by patch. Let's hope the ML will get this email. Not sure,
> as it tends to discard big emails like that.
> 
> This is the comment of patch 1/4.
> 

Patch 2 is trivial. It is obviously OK.

Patch 3 also looked OK on my eyes.

Regards,
Mauro

