Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:38212 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZBUQaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 11:30:04 -0500
Date: Sat, 21 Feb 2009 10:42:17 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Jean Delvare <khali@linux-fr.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
In-Reply-To: <20090220231820.67ce2899@pedra.chehab.org>
Message-ID: <alpine.LNX.2.00.0902211008360.9653@banach.math.auburn.edu>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <20090218071041.63c09ba3@pedra.chehab.org> <20090218140105.17c86bcb@hyperion.delvare> <20090220212327.410a298b@pedra.chehab.org> <alpine.LNX.2.00.0902201853040.9018@banach.math.auburn.edu>
 <20090220231820.67ce2899@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:

> Hi Theodore,
>
> On Fri, 20 Feb 2009 19:30:16 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:
>
>> Hoping that I can offer some helpful comments on this thread, as someone
>> who came along only in the last couple of months or so:
>>
>> 1. One of the most interesting features which I found in the video for
>> Linux project is the ability to work somewhat independently of the
>> particular kernel version running on the local machine. This is valuable,
>> in the sense that it saves a lot of wasted time and effort just keeping up
>> with which kernel version to use. It was also something which is done so
>> cleverly that at first I could not believe it. Congratulations to those
>> who thought this arrangement up.
>>
>> 2. Sometimes, there is a real problem with a particular version of the
>> kernel which has nothing to do with the task at hand, but it sure can get
>> in the way. As a recent example, soon after starting to work with Adam
>> Baker on the sq905 module (and furthermore having at the time the false
>> impression that the gspca work meant I should be running the latest thing
>> out there) I upgraded from 2.6.27.7 to 2.6.28. Well, there was a rather
>> serious USB bug in 2.6.28. So then _that_ had to be straightened out.
>> Things like that do not promote smooth progress but rather interfere with
>> it.
>>
>> 3. I just bought an eeePC. It is running some 2.6.21.x kernel. My
>> reaction: I do not believe they should be doing that. I would not feel
>> like accommodating them. Comparison: someone wrote to me complaining about
>> problems with libgphoto2-2.1.3, which his distro was still releasing, when
>> libgphoto2-2.3.x was already out and his problem had been solved 24 months
>> before. I told him to upgrade and his problems would go away. He wanted me
>> to fix his old version. I explained that this has been done, and he should
>> avail himself of that by installing a new version. Somewhere there is a
>> line, and that guy crossed it.
>>
>> Trying to put all this together:
>>
>> I think that the semi-independence from the particular kernel-du-jour is a
>> good thing and would seem to me to make progress in the specific area of
>> video to be smoother. Modular or semi-modular development is something
>> nice. One can concentrate on the subject at hand and not on daily kernel
>> upgrading. Nice.
>>
>> I also would not want to bust my butt to support someone's ancient kernel.
>> After all, quite often the reason there is a new kernel version is that
>> some long-undiscovered bug suddenly got discovered. Not all change is
>> just for fun, or just to support new stuff. Some of those bugs had
>> far-reaching consequences, recall. So to support one of the affected
>> kernels involves what, exactly?
>>
>> Hoping that these comments help toward some good conclusion of this issue.
>
> Thank you for your comments.
>
> For sure allowing to compile v4l-dvb with older kernels is very interesting for
> the users. It is not perfect, since a bug upstream will keep affecting the
> backported driver, but, in general, this works well, however, at the cost of
> spending developers time backporting things. Since the size of the tree is
> increasing a lot, we'll likely need to use another solution.

This is not exactly what I was trying to say. I'll try again.

1. Anyone who would call himself a developer will run quite recent kernels 
without being forced to do so, voluntarily and with pleasure.

2. Sometimes the kernel which just came out has a bug. The bug can 
interfere with current work even though it is from another kernel 
subsystem. I mentioned a recent example. The problem was in the basic USB 
area. It specifically related to devices running on alt0 and using a bulk 
endpoint. I was trying to support a camera that streams on alt0 over the 
bulk endpoint. Said bug seriously interfered with progress. Who would say 
that everyone should simultaneously use the same tree, suggests that 
everyone should simultaneously experience the same set of bugs.

3. Because of (2) and for other obvious reasons, the ability to develop 
a kernel subsystem semi-independently of the latest git tree is a clever 
and good thing. Why give it up and tie oneself to just one git tree?

4. If it were my decision, I probably would not tie myself in knots if 
something new would "break" a kernel which is more than a couple of 
versions behind. Right now, this would probably mean I would not care at 
all what happened to people running 2.6.24.x or older. Furthermore, if 
what was "broken" was due to a bug in the old kernel, too bad.

5. So I would continue to allow flexibility but I would not become 
extremely concerned if a kernel more than a couple of versions behind 
would start to have problems. I would try to be nice and let people know, 
unless they started to shout at me, at which point I  would start to 
ignore them.

Probably all of the above would please nobody, and it is a good that I am 
not in charge of anything.

Theodore Kilgore

