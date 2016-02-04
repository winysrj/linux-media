Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54790 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbcBDOgD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2016 09:36:03 -0500
Subject: Re: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
To: mtk.manpages@gmail.com, Andy Lutomirski <luto@kernel.org>
References: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
 <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g@mail.gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org, Linux API <linux-api@vger.kernel.org>,
	ALSA development <alsa-devel@alsa-project.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56B361C5.8000101@osg.samsung.com>
Date: Thu, 4 Feb 2016 07:35:49 -0700
MIME-Version: 1.0
In-Reply-To: <CAKgNAkg+cjJS2G5TKvYAYizXWaPewVNtdBQN1x0otbPM7huy5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2016 07:04 AM, Michael Kerrisk (man-pages) wrote:
> [expanding the CC a little]
> 
> Hi Andy, (and Shuah)
> 
> On 4 February 2016 at 05:51, Andy Lutomirski <luto@kernel.org> wrote:
>> [cc list heavily trimmed]
>>
>> On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>>> Change dvb frontend to check if tuner is free when
>>> device opened in RW mode. Call to enable_source
>>> handler either returns with an active pipeline to
>>> tuner or error if tuner is busy. Tuner is released
>>> when frontend is released calling the disable_source
>>> handler.
>>
>> As an actual subscriber to linux-api, I prefer for the linux-api list
>> to be lowish-volume and mostly limited to API-related things.  Is this
>> API related?  Do people think that these series should be sent to
>> linux-api?
> 
> I think not, and I'd like to stem the flood of mail to the list.
> There's two things that we could do:

I simply followed the getmaintainers generate3d list.
A bit surprised to see linux-api, but didn't want to
leave it out.

> 
> 1. Shuah, I know we talked about this in the past, and it made some
> sense to me at the time for kselftest to use linux-api@, but maybe
> it's time to create a dedicated list, and move the traffic there? It'd
> help focus the traffic of linux-api more on its original purpose.

Yes that is a good plan - I will request a new mailing list and
send in a patch to Kselftest MAINTIANER's entry.

> 
> 2. However, I think the bigger cause of the flood is the change made
> to MAINTAINERS by Josh's commit
> ea8f8fc8631d9f890580a94d57a18bfeb827fa2e:
> 
> +ABI/API
> +L:     linux-api@vger.kernel.org
> +F:     Documentation/ABI/
> +F:     include/linux/syscalls.h
> +F:     include/uapi/
> +F:     kernel/sys_ni.c
> 
> The change was well-intentioned (I Acked it), but folk run
> scripts/get-maintainers.pl without thinking too much about its output
> and add all of the resulting lists and CCs to their patch submissions.
> This means we get a lot of useless noise relating to drivers and
> unrelated Documentation changes, and actually miss some of the really
> important changes (e.g., extensions of system calls; and new /proc
> entries tend to get lost in the noise). Furthermore, people doing
> things such as adding new system calls often don't tun
> scripts/get-maintainers.pl it seems. Certainly, I have to often enough
> remind peple to CC linux-api when adding new system calls.
> 
> I'll craft a patch to trim the MAINTAINERS entry.
> 

Thanks for doing this,
-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
