Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:41587 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbCGQWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 11:22:55 -0500
MIME-Version: 1.0
In-Reply-To: <54F82F5E.7060007@xs4all.nl>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
 <CAHG8p1DFu8Y1qaDc9c0m0JggUHrF4grHBj9VZQ4224v2wPJRbQ@mail.gmail.com>
 <54F575AD.5020307@xs4all.nl> <CA+V-a8uVoUHHtQAGOAjz_wYpmkOg8_=cxv6W5b289coU_Wq0Xg@mail.gmail.com>
 <54F58142.4030201@xs4all.nl> <CA+V-a8uKxZBtwOZ7rqpv6Ym6X9jpgsHUxVAmuUqrVoGT3M8e3A@mail.gmail.com>
 <CAHG8p1DvYQaU7kGJSSh4UTiHYcK2E=g=4vCFAa8rytkYz3jHVw@mail.gmail.com> <54F82F5E.7060007@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sat, 7 Mar 2015 16:22:23 +0000
Message-ID: <CA+V-a8vTBJuiHRPjEN7VHHmAZhAu=W=Zi5a_N9DiLiRZH-Ab0A@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] media: blackfin: bfin_capture enhancements
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 5, 2015 at 10:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/05/15 10:44, Scott Jiang wrote:
>> Hi Hans,
[snip]
>>>>
>>>> cd utils/v4l2-compliance
>>>> cat *.cpp >x.cpp
>>>> g++ -o v4l2-compliance x.cpp -I . -I ../../include/ -DNO_LIBV4L2
>>>>
>>>> I've never used uclibc, so I don't know what the limitations are.
>>>>
>>> Not sure what exactly fails, I haven’t tried compiling it, that was a
>>> response from Scott for v2 series.
>>>
>>
>> I found if I disabled libjpeg ./configure --without-jpeg, it can pass
>> compilation.
>
> Great!
>
>> Would you like me to send the result now or after Lad's v4 patch?
>
> Send it now as v4 won't have any meaningful code changes.
>
But anyway I cant help here much if there are any compliance issues,
as i don't have the hardware.

Thanks,
--Prabhakar Lad
