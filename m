Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:53486 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZCATuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 14:50:32 -0500
Message-ID: <49AAE742.8090101@to-st.de>
Date: Sun, 01 Mar 2009 20:51:30 +0100
From: Tobias Stoeber <tobi@to-st.de>
Reply-To: tobi@to-st.de
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Hans Verkuil schrieb:
> So here is a quick poll, please reply either to the list or directly to me 
> with your yes/no answer and (optional but welcome) a short explanation to 
> your standpoint. It doesn't matter if you are a user or developer, I'd like 
> to see your opinion regardless.
> 
> Please DO NOT reply to the replies, I'll summarize the results in a week's 
> time and then we can discuss it further.
> 
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> 

X : Yes

> _: No
> 
> Optional question:
> 
> Why:

I am voting for "Yes" because ...

a) developers complain about technical reasons (changes to i2c etc.) 
which - in the words of the developers - make it harder to provide a 
backward compatibility. This is a valid reason.

b) I hope, that the resources freed will leed to a better v4l / dvb 
subsystem (and to surrounding tasks as, for instance, having 
documentation that is in line with the state of development etc.)

Maybe this also frees time, to really think about the direction of 
subsystem and whether it must be really depended that much to specific 
kernel versions, especially for devices like USB.

c) in the end: it would also not be of any value to insist on support 
for older kernels, because the users are dependend on developers and in 
some way in "their hands"  ...

d) I furthermore hope, that there will be snapshots (as archives) 
provided to allow for more recent device support to pre-2.6.22 kernel 
users (as provided by the kernel itself)

It should a least be stated (in the wiki) which devices are supported 
from what kernel version upwards, so users then can select - as it 
always has been - older hardware.

In the end, the process of having a poll including the question of "Why" 
gives an interesting view into how - at least some - developers and 
"users" see the facts and what hopes expactations exist.

In a way I am a bit shocked about some of the replies, which - just my 
personal opinion - placed ease and development speed above the users 
(and I don't have in mind those "users" here, who have a broad technical 
knowledge and resources to *really* know what they are doing when 
upgrading to recent or even git kernels!) of this "product" of development.

Regards, Tobias
