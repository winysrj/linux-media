Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:49550 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0ASPy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 10:54:28 -0500
Received: by qyk32 with SMTP id 32so731142qyk.4
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 07:54:27 -0800 (PST)
Message-ID: <4B55D5AD.2030108@gmail.com>
Date: Tue, 19 Jan 2010 13:54:21 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl>
In-Reply-To: <201001190853.11050.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

n 01/19/2010 05:53 AM, Hans Verkuil wrote:
> On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
>    
>> Hi,
>>
>> Today, a step to the future was given, in order to help developers to better
>> do their work: the addition of -git support at linuxtv.org server.
>>
>> This is one idea that is being recurrent along the last years: to start using -git
>> as our primary resource for managing the patches at the development[1].
>>
>> At the beginning, the usage CVS for of a SCM (Source Code Management) were
>> choosen on V4L/DVB. Both of the original V4L and DVB trees were developed with the
>> help of cvs. On that time, upstream Linux kernel used to have another tree (BitKeeper).
>>
>> In 2005, both V4L and DVB trees got merged into one cvs repository, and we've
>> discussed about what would be the better SCM solution. We've discussed more
>> about using svn, hg and git. On that time, both hg and git were new technologies,
>> based on the concept of a distributed SCM, where you don't need to go to the
>> server every time you're doing a command at the SCM.
>>
>> Yet, Mercurial were more stable and used, while -git were giving his first
>> steps[2], being used almost only by the Linux Kernel, and several distros didn't use
>> to package it. Git objects were stored uncompressed, generating very large
>> trees. Also, -git tools were complex to use, and some "porcelain" packages were
>> needed, in order to be used by a normal user.
>>
>> So, the decision was made to use mercurial. However, as time goes by, -git got much
>> more eyes than any other SCM, having all their weakness solved, and being developed
>> really fast. Also, it got adopted by several other projects, due to its capability
>> and its number of features.
>>
>> Technically speaking, -git is currently the most advanced distributed open-source
>> SCM application I know.
>>
>> Yet, Mercurial has been doing a very good job maintaining the V4L/DVB trees, and, except
>> for a few points, it does the job.
>>
>> However, the entire Linux Kernel development happens around -git. Even the ones that
>> were adopting other tools (like -alsa, that used to have also Mercurial repositories)
>> migrated to -git.
>>
>> Despite all technical advantages, the rationale for the migration is quite simple:
>> converting patches between different repositories and SCM tools cause development
>> and merge delays, may cause patch mangling and eats lot of the time for people
>> that are part of the process.
>>
>> Also, every time a patch needs to touch on files outside the incomplete tree
>> used at the subsystem, an workaround need to be done, in order to avoid troubles
>> and to be able to send the patch upstream.
>>
>> So, it is simpler to just use -git.
>>
>> Due to all the above reasons, I took some time to add -git support at linuxtv servers.
>> Both http and git methods to retrieve trees were enabled.
>>
>> The new trees will be available at:
>> 	http://linuxtv.org/git/
>>
>> The merge tree, where all submitted patches will be merged, before sending upstream is:
>> 	http://linuxtv.org/git?p=v4l-dvb.git;a=summary
>>
>> This tree is basically a clone of Linus tree, so it runs the latest development kernel.
>> It is also (almost) in sync with our -hg tree (needing just a few adjustments).
>>
>> The above tree will never be rebased, so it should be safe to use it for development.
>>
>> I'll basically merge there all patches I receive. It is OK to submit patches against -hg,
>> since I can still run my old conversion stripts to convert them to -git. However, as
>> the conversion script is not fast (it takes between 15-30 secs to convert a single patch
>> to -git, since it needs to re-generate the entire tree with v4l/scripts/gentree.pl, for
>> ever patch), I kindly ask you to prefer submit me patches directly to -git.
>>
>> With respect to the -hg tree with the out-of-tree building system, We really want to
>> keep having a way to allow running the drivers with kernels other than the latest -rc
>> one, for both development and testing.
>>
>> As you all know, the number of drivers and the average number of merges per day is being
>> increasing, among with more complexity on some drivers that also touches arch and other
>> files outside drivers/media tree. Due to that, lots of my current time is devoted to keep
>> -hg and -git in sync, distracting me from my develoment and maintanership tasks to do it.
>> So, I simply don't have more time to keep maintaining both -hg and -git.
>>
>> Due to that, I'm delegating the task of keeping -hg in sync with upstream and backporting
>> patches to run on older kernels to another person: Douglas has offered his help to keep
>> the tree synchronized with the -git tree, and to add backport support.
>>
>> He already started doing that, fixing some incompatibility troubles between some drivers
>> and older kernels.
>>      
> Mauro, I just wanted to thank you for doing all the hard work in moving to git!
>
> And a big 'thank you' to Douglas as well for taking over hg maintenance!
>    

You are welcome!

> I do have one proposal: parts of our hg tree are independent of git: v4l2-apps,
> possibly some firmware build code (not 100% sure of that), v4l_experimental,
> perhaps some documentation stuff. My proposal is that we make a separate hg
> or git tree for those. It will make it easier to package by distros and it makes it
> easier to maintain v4l2-apps et al as well. It might even simplify Douglas's work
> by moving non-essential code out of the compat hg tree.
>
> I'll be updating my daily build scripts to start using git soon (I'll keep using
> hg for the older kernels of course).
>
>    

Thanks for doing the daily build email, helps a lot. Also, helps bring 
more people involved with the
subsystem.

Cheers,
Douglas
