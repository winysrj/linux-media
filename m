Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1HPCUD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 22:20:03 -0400
Message-ID: <4E49D3CD.1040408@redhat.com>
Date: Mon, 15 Aug 2011 19:19:57 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Declan Mullen <declan.mullen@bigpond.com>
CC: linux-media@vger.kernel.org
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
References: <201108150923.44824.declan.mullen@bigpond.com>
In-Reply-To: <201108150923.44824.declan.mullen@bigpond.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2011 16:23, Declan Mullen escreveu:
> On Sunday 14 August 2011 22:14:48 you wrote:
>> On Sun, Aug 14, 2011 at 5:21 AM, Declan Mullen
>>
>> <declan.mullen@bigpond.com> wrote:
>>> Hi
>>>
>>> I've got a 8940 edition of a Hauppauge HVR-2200. The driver is called
>>> saa7164. The versions included in my OS (mythbuntu 10.10 x86 32bit,
>>> kernel 2.6.35-30) and from linuxtv.org are too old to recognise the 8940
>>> edition. Posts #124 to #128 in the "Hauppauge HVR-2200 Tuner Install
>>> Guide" topic
>>> (http://www.pcmediacenter.com.au/forum/topic/37541-hauppauge-hvr-2200-tun
>>> er- install-guide/page__view__findpost__p__321195) document my efforts
>>> with those versions.
>>>
>>> So I wish to use the latest stable drivers from the driver maintainers,
>>> ie http://kernellabs.com/gitweb/?p=stoth/saa7164-stable.git;a=summary
>>>
>>> Problem is, I don't know git and I don't know how I'm suppose to git,
>>> build and install it.
>>>
>>> Taking a guess I've tried:
>>>  git clone git://kernellabs.com/stoth/saa7164-stable.git
>>>  cd saa7164-stable
>>>  make menuconfig
>>>  make
>>>
>>> However I suspect these are not the optimum steps, as it seems to have
>>> downloaded and built much more than just the saa7164 drivers. The git
>>> pulled down nearly 1GB (which seems a lot) and the resultant menuconfig
>>> produced a very big ".config".
>>>
>>> Am I doing the right steps or should I be doing something else to git,
>>> build and install  the latest drivers ?
>>>
>>> Thanks,
>>> Declan
>>
>> Hello Declan,
>>
>> Blame Mauro and the other LinuxTV developers for moving to Git.  When
>> we had HG you could do just the v4l-dvb stack and apply it to your
>> existing kernel.  Now you have to suck down the *entire* kernel, and
>> there's no easy way to separate out just the v4l-dvb stuff (like the
>> saa7164 driver).  The net effect is it's that much harder for
>> end-users to try out new drivers, and even harder still for developers
>> to maintain drivers out-of-tree.

Devin,

Please stop blaming somebody else for that. Nobody including you didn't
have time to keep maintaining two trees. As you know, git _IS_ the SCM 
used for all kernel submission. So, it was not a matter of choice, but the
lack of a develper with available time to keep maintaining the -hg.

This is a community work. As such, if someone has a good idea and has
enough time for it, he/she can just go ahead and implement it. On the
other hand, when time starves, one needs to priorize in order to focus
on the tasks that are more relevant.

Also, there's no need to download the entire kernel tree. The media-build
git tree can download just a tarball. Tarballs with the latest development
drivers are daily generated. What makes harder for people to try out 
new drivers/patches is when developers take months or even years to submit 
new stuff upstream.

Even so, the media-build can work together with another tree that can be a 
full tree or a tree with just the drivers (using build --git option). I've 
tested it only with git trees, but it probably works properly also with any
other SCM.

Regards,
Mauro.
