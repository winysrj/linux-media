Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:53113 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbAQMCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 07:02:36 -0500
Received: from mailo-proxy2.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t0HC2XL4011862-t0HC2XL5011862
	for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 14:02:33 +0200
Message-ID: <54BA4F58.5060809@apollo.lv>
Date: Sat, 17 Jan 2015 14:02:32 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl> <54B55C23.1070409@apollo.lv>
 <54B92620.6020408@xs4all.nl> <54B960EC.7090604@apollo.lv>
 <54BA42CD.3050908@xs4all.nl>
In-Reply-To: <54BA42CD.3050908@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.01.2015 13:09, Hans Verkuil wrote:
> Thanks. This was with one frontend? And what was the exact sequence of commands
> used to replicate this?
>
> Sorry, but I need precise details of how you reproduce this, especially since I
> can't reproduce it.
This test was run on first front end.
I just started "w_scan -fs -s S13E0 -D0c -a 4" (which mean: do satellite 
channel
scan using S13E0 initial transponder list on first DiSEqC port on 
adapter 4) and
waited until error appeared in "dmesg --follow". It may take some time 
(for me
in average 5-15 minutes)
> I'm pretty sure there are multiple issues here, one of them is fixed by my vb2
> patch, but this page fault is almost certainly a separate problem.
>
> Based on past reports there is also a possible problem with multiple frontends,
> but I don't have hardware like that and even if I had I am not sure I would be
> able to test it properly. Besides, that issue seemed to be unrelated to the
> vb2 conversion. It's all pretty vague, though.
IMHO: I also think problem is with multiple front ends,
            because on some usage patterns problem almost go away

IMHO: page fault problem IS related to the vb2 conversion, because
1) I did not have this problem on kernel 3.13.10
2) during bisection this error appeared exactly on conversation commit

Can we test multiple front ends version? Because you do not have hardware
I propose to test it other way around: can you make patch which disables or
ignores one front end on my hardware (TBS 6981)?



Raimonds Cicans
