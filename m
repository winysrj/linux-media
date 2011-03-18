Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab1CRUUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2011 16:20:49 -0400
Received: by fxm17 with SMTP id 17so4060002fxm.19
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2011 13:20:48 -0700 (PDT)
Message-ID: <4D83BE9B.6080600@gmail.com>
Date: Fri, 18 Mar 2011 21:20:43 +0100
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org, o.endriss@gmx.de
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A97BB.4020704@gmail.com> <4D7B7524.2050108@linuxtv.org> <201103130042.49199@orion.escape-edv.de> <4D7CA0CC.8090308@gmail.com> <4D81348D.2070803@usa.net>
In-Reply-To: <4D81348D.2070803@usa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Issa Gorissen wrote:
> On 13/03/11 11:47, Martin Vidovic wrote:
>   
>>> Btw, we should choose a more meaningful name for 'camX'.
>>> I would prefer something like cainoutX or caioX or cinoutX or cioX.
>>>   
>>>       
>> I agree, camX could be misleading since it's not necessarily a CAM
>> application.
>>
>> According to EN 50221 the two interfaces are named Command Interface
>> (for caX)
>> and Transport Stream Interface (for camX). Then maybe 'tsiX' would be
>> an appropriate
>> name?
>>
>> Anyway, 'cioX' sounds good too.
>>     
>
> I'll prepare the patch with caio (for conditional access I/O) if all
> agrees on it. tsi is a good candidate as it perfectly matches the
> standard specification, but then, ca should have been ci...
>
> --
> Issa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Fine with me, as long as the name is stable.

However, these issues still bother me:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg29022.html

Regards,
Martin
