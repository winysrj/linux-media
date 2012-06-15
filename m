Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOGh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 02:37:58 -0400
Message-ID: <4FDAD843.8070108@mihu.de>
Date: Fri, 15 Jun 2012 08:37:55 +0200
From: Michael Hunold <michael@mihu.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] [RESEND] saa7146: Variable set but not used
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com> <1339696716-14373-3-git-send-email-peter.senna@gmail.com> <4FDACFFB.9020500@mihu.de> <4FDAD50D.1010903@xs4all.nl>
In-Reply-To: <4FDAD50D.1010903@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

on 15.06.2012 08:24 Hans Verkuil said the following:
> On 15/06/12 08:02, Michael Hunold wrote:

>> A few lines below "fh" is allocated and "fh->type" is set to "type".
>> Simply removing "type" will result in a compilation error IMO, so I
>> wonder if your compile-test really worked.
>>
>> Can you have a look again?

> Are you perhaps looking at an older version of this source? 

most likely. :-/

> 'fh->type'
> no longer exists.

> Anyway, this patch is correct.

Ok, then feel free to pick it. :-)

> Regards,
> 
>     Hans

Best regards
Michael.
