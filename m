Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45425 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbaKKMLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 07:11:39 -0500
Message-ID: <5461FCDC.3050501@xs4all.nl>
Date: Tue, 11 Nov 2014 13:11:08 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sebastian Reichel <sre@kernel.org>
Subject: Re: [GIT PULL FOR v3.19] Various fixes
References: <54609BD2.8070200@xs4all.nl> <20141111090940.61626e4f@recife.lan>
In-Reply-To: <20141111090940.61626e4f@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/14 12:09, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Nov 2014 12:04:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Sparse fixes for saa7164, adv EDID fixes and si4713 improvements in preparation
>> for adding DT support. Tested the si4713 with my USB dev board.
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:
>>
>>   [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git for-v3.19f
>>
>> for you to fetch changes up to 017f179ebd74ec3bd3f2484c3cc0fe48c306a36e:
>>
>>   si4713: use managed irq request (2014-11-10 12:03:30 +0100)
>>
> 
> ...
> 
>> Sebastian Reichel (4):
>>       si4713: switch to devm regulator API
>>       si4713: switch reset gpio to devm_gpiod API
>>       si4713: use managed memory allocation
>>       si4713: use managed irq request
> 
> None of the above was applied, as the first si4713 patch broke compilation.

No problem, I'll look at this on Friday. I should have checked this myself,
sorry about that.

Regards,

	Hans

