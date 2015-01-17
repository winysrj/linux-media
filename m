Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:35223 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbAQMat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 07:30:49 -0500
Received: by mail-we0-f177.google.com with SMTP id l61so2609791wev.8
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 04:30:47 -0800 (PST)
Message-ID: <54BA55F7.8050100@gmail.com>
Date: Sat, 17 Jan 2015 13:30:47 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Raimonds Cicans <ray@apollo.lv>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl> <54B55C23.1070409@apollo.lv> <54B92620.6020408@xs4all.nl> <54B960EC.7090604@apollo.lv> <54BA42CD.3050908@xs4all.nl>
In-Reply-To: <54BA42CD.3050908@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I doubt that there is an issue with multiple frontends, at least not in 
all cases.
I've got 4 DVBSky T982 adapters (2 frontends per card) runing without 
issues so far.
They have a cx23885 and 2x si2168/2157

Regards,
Tycho.

Op 17-01-15 om 12:09 schreef Hans Verkuil:
> On 01/16/2015 08:05 PM, Raimonds Cicans wrote:
>> On 16.01.2015 16:54, Hans Verkuil wrote:
>>
>>> If you get the error again with a 3.18 or higher kernel and with my patch,
>>> then please copy-and-paste that message again.
>> To be sure, I attached full dmesg.
> Thanks. This was with one frontend? And what was the exact sequence of commands
> used to replicate this?
>
> Sorry, but I need precise details of how you reproduce this, especially since I
> can't reproduce it.
>
> I'm pretty sure there are multiple issues here, one of them is fixed by my vb2
> patch, but this page fault is almost certainly a separate problem.
>
> Based on past reports there is also a possible problem with multiple frontends,
> but I don't have hardware like that and even if I had I am not sure I would be
> able to test it properly. Besides, that issue seemed to be unrelated to the
> vb2 conversion. It's all pretty vague, though.
>
> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

