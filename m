Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37762 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139AbcBVKaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 05:30:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B0AA718033B
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 11:30:10 +0100 (CET)
Subject: Re: cron job: media_tree daily build: ERRORS
To: linux-media@vger.kernel.org
References: <20160222032911.37A3918008B@tschai.lan>
 <56CAB637.9070101@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CAE332.9030509@xs4all.nl>
Date: Mon, 22 Feb 2016 11:30:10 +0100
MIME-Version: 1.0
In-Reply-To: <56CAB637.9070101@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/2016 08:18 AM, Hans Verkuil wrote:
> On 02/22/2016 04:29 AM, Hans Verkuil wrote:
>> This message is generated daily by a cron job that builds media_tree for
>> the kernels and architectures in the list below.
> 
> There is something weird going on when this job is started from cron. I'm getting
> strange errors like this:
> 
> /bin/sh: fork: retry: No child processes
> make[5]: fork: Resource temporarily unavailable
> 
> which I don't get when I build manually. It happened after a recent apt-get dist-upgrade
> and I haven't yet found the cause.

So here is the reason: systemd has a new DefaultTasksMax setting which is 512 by
default. It seems unrelated to rlimit since it doesn't show up with ulimit -a,
so this confused the hell out of me.

Setting it explicitly in my /etc/systemd/system.conf fixes the issue.

More details about that setting is available here:

https://www.freedesktop.org/software/systemd/man/systemd-system.conf.html

Aaargh! I wasted 3 hours of my life hunting this down...

	Hans
