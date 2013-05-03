Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763190Ab3ECLh0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 May 2013 07:37:26 -0400
Message-ID: <5183A16B.8050807@redhat.com>
Date: Fri, 03 May 2013 08:37:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9uIEFybmUgSsO4cmdlbnNlbg==?= <jonarne@jonarne.no>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org, jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no> <1367268069-11429-2-git-send-email-jonarne@jonarne.no> <20130503020913.GB5722@localhost> <20130503063228.GB1232@dell.arpanet.local>
In-Reply-To: <20130503063228.GB1232@dell.arpanet.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-05-2013 03:32, Jon Arne Jørgensen escreveu:
> On Thu, May 02, 2013 at 11:09:14PM -0300, Ezequiel Garcia wrote:
>> Hi Jon,
>>
>> On Mon, Apr 29, 2013 at 10:41:07PM +0200, Jon Arne Jørgensen wrote:
>>> As we're now seeing other variants from chinese clones, like
>>> gm1113c, we'll need to add more bits at the detection code.
>>>
>>> So, move it into a separate function.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
>>
>> As far as I can see, this patch is identical to the one sent
>> by Mauro. Therefore, your SOB here is incorrect, since you are not
>> the author of the patch.
>>
>> The proper way of re-submitting patches that have been previously
>> submitted by another developer is this:
>>
>> --
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> Commit message goes here.
>>
>> Notice how the first line is a 'From:' tagcindicating who's the
>> real submitter. The SOB tag indicates the patch author, and you
>> can add your acked-by, tested-by or reported-by if you want.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Reported-by: Jon Arne Jørgensen <jonarne@jonarne.no>

Please also add here your Tested-by: if you tested (very likely
you did it). The same applies to patch 2/3.

>> --
>>
>> You can read more about this in Documentation/SubmittingPatches.
>
> Ok, I'll fix this


Regards,
Mauro.

