Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1KCVjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 17:39:07 -0400
Received: by iage36 with SMTP id e36so1798647iag.19
        for <linux-media@vger.kernel.org>; Thu, 03 Nov 2011 14:39:06 -0700 (PDT)
Message-ID: <4EB309F8.8090607@gmail.com>
Date: Thu, 03 Nov 2011 16:39:04 -0500
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Adding PCTV80e support to linuxtv.
References: <4EA75010.3030806@gmail.com> <op.v4b0znse3xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net> <4EB1BFCF.8080701@gmail.com> <op.v4dtorx73xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <op.v4dtorx73xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/2011 01:01 PM, semiRocket wrote:
> On Wed, 02 Nov 2011 23:10:23 +0100, Patrick Dickey
> <pdickeybeta@gmail.com> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 11/02/2011 01:44 PM, semiRocket wrote:
>>> On Wed, 26 Oct 2011 02:10:56 +0200, Patrick Dickey
>>> <pdickeybeta@gmail.com> wrote:
>>>
>>>> Hello everyone,
>>>>
>>>> Since my repository isn't under the linuxtv.org banner, I'm not
>>>> sure how to create an actual patch or pull request for the code.
>>>> It needs some cleanup work, but essentially the code works (for
>>>> the ATSC portion, but possibly not the QAM portion).
>>>>
>>>> The repository is located at
>>>> https://github.com/patrickdickey52761/PCTV80e
>>>>
>>>> so I'd imagine that either git clone
>>>> git://github.com/patrickdickey52761/PCTV80e or git remote add
>>>> git://github.com/patrickdickey52761/PCTV80e will pull the code in
>>>> for you (it's a public repository).
>>>>
>>>> If this doesn't work, I'm asking for assistance in getting the
>>>> code into a repository that can be pulled in (or assistance in
>>>> how to prepare a patch/pull request from my current repository).
>>>>
>>>> If this does work, then I'm asking for assistance in cleanup of
>>>> the code--and specifics on what I need to do to clean up the code
>>>> (breaking lines up into fewer than 80 columns, whitespace, etc).
>>>> One thing to note is that I haven't removed the trailing
>>>> whitespace from the drxj_map.h file, as it was an automatically
>>>> generated file. I wasn't sure what implications could arise from
>>>> altering the file.
>>>>
>>>> Thank you, and have a great day:) Patrick.
>>>
>>> Hi,
>>>
>>> I'm not a developer, but I have some basic understanding how v4l
>>> patching works.
>>>
>>> You don't have to have a repository online, you can simply submit
>>> patches from your local tree using git or hg or even diff tools.
>>> Patches should come from newer trees (preferably current
>>> development tree) so they could apply cleanly.
>>>
>>> Please read the following links and see if they could help:
>>> http://linuxtv.org/wiki/index.php/Developer_Section
>>> http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
>>>
>>>
>>>
>>
>> Thanks for the reply. I've looked through most of the links on those
>> pages, and am almost ready to send the patches. The main problem that
>> I have is that even after rebasing my branch (per the instruction on
>> the media_git.git page), when I do a format patch there are 350+
>> patches generated (all but the last 29 are from other submitters).
>>
>> So, I either have to wait for all of those other patches to be added
>> to the master repository, or I need to figure out how to isolate my
>> specific patches from the list (so I can send them).
>>
>> If you've got any suggestions on that, I'd greatly appreciate it.  I'm
>> more new to git than anything else--as most of my programming was in
>> classes, and they don't teach this stuff there.
>>
>> Have a great day:)
>> Patrick.
> 
> 
> Hello,
> 
> don't know the answer, so I am adding list back.
> 
> Maybe someone else would know how to synchronize your old tree against
> current development tree (except by manually cut/paste).

Just for clarification. When I run git format-patch, it creates 379
patches (the 354 that are already in the repository, and my 25).  I
tried running the git rebase line from the
http://git.linuxtv.org/media_build.git page, but it didn't do anything
(unless I need to run it after generating the other 354 patches).

So, my questions are:

1.  Do I need to rebase after generating the patches that everyone else
has submitted, in order to not have 300+ patches that don't apply to my
portion?
2.  How can I isolate my own patches, if #1 is no (or if it doesn't
work, and I still get 300+ patches)?


Most importantly:

Should I just wait until Mauro creates the staginng-for-v3-3 branch, as
he's already pulling in for the merge window?

Have a great day:)
Patrick.
