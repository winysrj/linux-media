Return-path: <linux-media-owner@vger.kernel.org>
Received: from pitbull.cosy.sbg.ac.at ([141.201.2.122]:58299 "EHLO
	pitbull.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2AVMop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 07:44:45 -0500
Cc: linux-media@vger.kernel.org
Message-Id: <B3BCD6C8-B0B3-456F-8B0B-A4650A3F2666@cosy.sbg.ac.at>
From: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <4F1B70B6.10209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: DVB-S2 multistream support
Date: Sun, 22 Jan 2012 13:44:42 +0100
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org> <4F1B70B6.10209@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Am 22.01.2012 um 03:13 schrieb Mauro Carvalho Chehab:

> Hi Christian,
>
> Em 27-12-2011 08:12, Christian Prähauser escreveu:
>>>
>>> Yes, I'm meaning something like what it was described there. I think
>>> that the code written by Christian were never submitted upstream.
>>>
>>
>> Hello Mauro,
>>
>> Konstantin drew my attention to this discussion. Indeed, some time  
>> ago I wrote
>> a base-band demux for LinuxDVB. It was part of a project to  
>> integrate support
>> for second-generation IP/DVB encapsulations (GSE). The BB-demux  
>> allows to
>> register filters for different ISIs and data types (raw, generic  
>> stream,
>> transport stream).
>>
>> I realized that the repo hosted at our University is down. If there  
>> is interest,
>> I can update my patches to the latest LinuxDVB version and we can  
>> put them on a
>> public repo e.g. at linuxdvb.org.
>
> Sorry, I didn't notice your comment on this thread until today. It  
> sounds
> interesting. Please post the patches at the ML, when they're  
> available, for
> us to review.

No problem, I'll keep you informed about the status of the patches.

Thanks and kind regards,
Christian.

>
> Thanks!
> Mauro
>>
>> Kind regards,
>> Christian.
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

---
Dipl.-Ing. Christian Praehauser <cpraehaus@cosy.sbg.ac.at>

|| //\\//\\ || Multimedia Communications Group,
||//  \/  \\|| Department of Computer Sciences, University of Salzburg
http://www.cosy.sbg.ac.at/~cpraehaus/
http://www.network-research.org/
http://www.uni-salzburg.at/
