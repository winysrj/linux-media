Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:46743 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZE1OUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 10:20:16 -0400
Date: Thu, 28 May 2009 09:34:25 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-media@vger.kernel.org
Subject: Re: Licensing question regarding SN9C2028 decompression (fwd)
In-Reply-To: <4A1E3850.5090500@redhat.com>
Message-ID: <alpine.LNX.2.00.0905280928540.3619@banach.math.auburn.edu>
References: <alpine.LNX.2.00.0905271640190.14249@banach.math.auburn.edu> <4A1E3850.5090500@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 28 May 2009, Hans de Goede wrote:

>
>
> On 05/27/2009 11:43 PM, Theodore Kilgore wrote:
>> 
>> Hans,
>> 
>> Here is the answer which I got about the question of GPL->LGPL licensing
>> in regard to the sn9c2028 decompression code.
>> 
>
> Hmm,
>
> Given that you did have contact with the original author years ago and
> he also did ok it back then, and that large parts of the code are written
> by you, I'm ok with moving forward changing the license to LGPL and then
> committing the patch.
>
> Regards,
>
> Hans

If you think it is appropriate, I can include the mail as part of the 
file. I notice that this is done in some other files, for example in 
pac207.c. But as far as contact with the author is concerned, it is even 
more accurate to say that the cooperation was a two-way street. I 
understand that some of my LGPL code for other camera drivers has been put 
to use, too, in the macam project. For example, they also have drivers for 
the SQ cameras and the mr97310a cameras. Clearly, I do not have a problem 
with that any more than Harald has with my using the sn9c2028 
decompression algorithm. In fact, as he called the decompression algorithm 
to my attention, I brought to his attention the work which I had done on 
those other cameras. Sorry I did not keep all the e-mails, though.

Theodore Kilgore

