Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56342 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbbAQLJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 06:09:21 -0500
Message-ID: <54BA42CD.3050908@xs4all.nl>
Date: Sat, 17 Jan 2015 12:09:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl> <54B55C23.1070409@apollo.lv> <54B92620.6020408@xs4all.nl> <54B960EC.7090604@apollo.lv>
In-Reply-To: <54B960EC.7090604@apollo.lv>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/16/2015 08:05 PM, Raimonds Cicans wrote:
> On 16.01.2015 16:54, Hans Verkuil wrote:
> 
>> If you get the error again with a 3.18 or higher kernel and with my patch,
>> then please copy-and-paste that message again.
> 
> To be sure, I attached full dmesg.

Thanks. This was with one frontend? And what was the exact sequence of commands
used to replicate this?

Sorry, but I need precise details of how you reproduce this, especially since I
can't reproduce it.

I'm pretty sure there are multiple issues here, one of them is fixed by my vb2
patch, but this page fault is almost certainly a separate problem.

Based on past reports there is also a possible problem with multiple frontends,
but I don't have hardware like that and even if I had I am not sure I would be
able to test it properly. Besides, that issue seemed to be unrelated to the
vb2 conversion. It's all pretty vague, though.

Regards,

	Hans
