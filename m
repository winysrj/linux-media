Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3131 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZBXUkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 15:40:03 -0500
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Reply-To: Rudy@grumpydevil.homelinux.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 21:40:58 +0100
Message-Id: <1235508058.3870.615.camel@belgarion.romunt.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-02-22 at 11:15 +0100, Hans Verkuil wrote:
> Hi all,
> 
> There are lot's of discussions, but it can be hard sometimes to actually 
> determine someone's opinion.
> 
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
> _: Yes

YES

> _: No
> 
> Optional question:
> 
> Why:

>From what i see, i2c is causing trouble, also still in in 2.6.28. I
prefer attention on that in stead of trying to get the old i2c working. 

I've seen a remark seemed to imply that the Mythtv community is using
CentOS a lot. In my experience that is a minority in the mythtv group. 


-- 
Cheers,


Rudy

