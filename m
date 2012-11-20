Return-path: <linux-media-owner@vger.kernel.org>
Received: from bruce.bmat.com ([176.9.54.181]:34477 "EHLO bruce.bmat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab2KTLTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 06:19:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by bruce.bmat.com (Postfix) with ESMTP id 41C56674063
	for <linux-media@vger.kernel.org>; Tue, 20 Nov 2012 12:19:31 +0100 (CET)
Received: from bruce.bmat.com ([127.0.0.1])
	by localhost (bruce.bmat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oAxjMZhQjwkh for <linux-media@vger.kernel.org>;
	Tue, 20 Nov 2012 12:19:29 +0100 (CET)
Received: from MacBook-Pro-de-Marc.local (164.red-80-28-250.adsl.static.ccgg.telefonica.net [80.28.250.164])
	(Authenticated sender: mbolos@bmat.es)
	by bruce.bmat.com (Postfix) with ESMTPSA id 67DBA674062
	for <linux-media@vger.kernel.org>; Tue, 20 Nov 2012 12:19:28 +0100 (CET)
Message-ID: <50AB6769.1020700@bmat.es>
Date: Tue, 20 Nov 2012 12:20:09 +0100
From: =?ISO-8859-1?Q?Marc_Bol=F3s?= <mark@bmat.es>
Reply-To: mark@bmat.es
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Re: Question Hauppauge Nova-S-Plus.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear again sirs,

After some investigation I've found 2 new clues.

1 - The problem begins always with a small signal drop. It usually lasts 
only a few seconds but that's enough to crash the adapter connected to 
the antenna.
2 - Now the news: if noticed that when this happens, the driver's kernel 
module belonging to that same adapter just dies, as you can see in the 
ps output below with my adapter /dev/dvb/adapter9:

root@*********:/home/*****# ps aux | grep cx88
root       903  0.0  0.0      0     0 ?        S    Nov19   0:00 [cx88 
tvaudio]
root      2036  0.2  0.0      0     0 ?        S    Nov19   3:36 
[cx88[8] dvb]
root      2037  0.2  0.0      0     0 ?        S    Nov19   3:34 
[cx88[2] dvb]
root      2038  1.1  0.0      0     0 ?        S    Nov19  17:11 
[cx88[1] dvb]
root      2039  1.0  0.0      0     0 ?        S    Nov19  15:34 
[cx88[11] dvb]
root      2040  0.1  0.0      0     0 ?        S    Nov19   2:49 
[cx88[3] dvb]
root      2041  1.0  0.0      0     0 ?        S    Nov19  16:12 
[cx88[5] dvb]
root      2043  0.1  0.0      0     0 ?        S    Nov19   2:56 
[cx88[7] dvb]
root     21951  0.0  0.0      0     0 ?        S    10:11   0:00 
[cx88[6] dvb]
root     21975  0.0  0.0      0     0 ?        S    10:11   0:00 
[cx88[4] dvb]
root     22741  0.0  0.0   7552   868 pts/4    S+   10:30   0:00 grep cx88

The adapter's device files /dev/dvb/adapterX are kept in their place, 
but they are no longer readable nor writeable.
My question is: which module is the responsible for launching the kernel 
processes [cx88[XX] dvb]? Is there some way of manually launching one of 
them?
How can I restore the crashed device without needing to restart the 
machine or even remove the driver and affect the remaining working adapters?

Thank you very much for your help and time.

Kind regards.

El 13/08/12 11:44, Marc Bolós escribió:
>
> Dear sirs,
>
> I'm a systems engineer (from spain, so excuse my bad english) working
> for some time with all kinds of TV receivers.
>
> First I wanted to thank you all for your work.
>
> I saw that sometimes your tips on this list are very helpfull, so I
> wanted to make you a question that maybe you can help me with.
>
> I've been working for some time with those devices, and recently I have
> a problem which I've never seen before. The point is that I tune
> properly frequency and I start watching all channels, but after some
> time  one or 2 tuners stops, and you cannot tune again any frequency
> until you reboot all server.
>
> One thing very strange there is that always are the same tuners which
> fails. Signal is OK.
>
> I don't have any error on syslog nor dmesg. And once you reboot it works
> again.
>
> Have anyone seen this problem before and can help me please?
>
> Thanks a lot for your time,
> Kind regards
>
> Marc.
>
