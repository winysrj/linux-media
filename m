Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759015AbZE1SP1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 14:15:27 -0400
Message-ID: <4A1ED4EE.2040508@redhat.com>
Date: Thu, 28 May 2009 20:16:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: linux-media@vger.kernel.org
Subject: Re: Licensing question regarding SN9C2028 decompression (fwd)
References: <alpine.LNX.2.00.0905271640190.14249@banach.math.auburn.edu> <4A1E3850.5090500@redhat.com> <alpine.LNX.2.00.0905280928540.3619@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0905280928540.3619@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/28/2009 04:34 PM, Theodore Kilgore wrote:
>
>
> On Thu, 28 May 2009, Hans de Goede wrote:
>
>>
>>
>> On 05/27/2009 11:43 PM, Theodore Kilgore wrote:
>>>
>>> Hans,
>>>
>>> Here is the answer which I got about the question of GPL->LGPL licensing
>>> in regard to the sn9c2028 decompression code.
>>>
>>
>> Hmm,
>>
>> Given that you did have contact with the original author years ago and
>> he also did ok it back then, and that large parts of the code are written
>> by you, I'm ok with moving forward changing the license to LGPL and then
>> committing the patch.
>>
>> Regards,
>>
>> Hans
>
> If you think it is appropriate, I can include the mail as part of the
> file. I notice that this is done in some other files, for example in
> pac207.c.

Ack,

But given that you are one of the authors of the original code in this case,
and the mail isn't a 100% clear re-license permission, I think its best to
just change the license and be done with it, without including the mail,
I think if anything the mail will only lead to confusion.

 > But as far as contact with the author is concerned, it is even
> more accurate to say that the cooperation was a two-way street. I
> understand that some of my LGPL code for other camera drivers has been
> put to use, too, in the macam project. For example, they also have
> drivers for the SQ cameras and the mr97310a cameras. Clearly, I do not
> have a problem with that any more than Harald has with my using the
> sn9c2028 decompression algorithm. In fact, as he called the
> decompression algorithm to my attention, I brought to his attention the
> work which I had done on those other cameras.

Ack, as said I think relicensing is fine.

> Sorry I did not keep all
> the e-mails, though.
>

No problem,

Regards,

Hans
