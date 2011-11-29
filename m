Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30350 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1K2Q4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 11:56:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVF00GKVLPSBS90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 16:56:16 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVF00AIILPSBV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 16:56:16 +0000 (GMT)
Date: Tue, 29 Nov 2011 17:56:16 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH resent] Fix logic in sanity check
In-reply-to: <201111291326.11352.thomas.jarosch@intra2net.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>
Message-id: <4ED50EB0.1050505@samsung.com>
References: <4E99FD60.5090606@intra2net.com> <4EB3AD88.1090702@samsung.com>
 <4EC93835.7010200@gmail.com> <201111291326.11352.thomas.jarosch@intra2net.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On 11/29/2011 01:26 PM, Thomas Jarosch wrote:
> On Sunday, 20. November 2011 18:26:13 Sylwester Nawrocki wrote:
>> If you care to resend the patch, please add "m5mols:" as a subsystem name
>> in the subject so it looks something like:
>>
>> [PATCH ...] m5mols: Fix ...
>>
>>>> ---
>>>>
>>>>   drivers/media/video/m5mols/m5mols_core.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> I'll resend something soonish. Though feel free to
> fix these cosmetic issues on the fly, too.

OK, sorry to bother. I'll pick the patch and amend it when adding
to a pull request.

-- 
Thanks!
Sylwester

> 
> Cheers,
> Thomas
