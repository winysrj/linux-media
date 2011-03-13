Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1CMKrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 06:47:43 -0400
Received: by fxm17 with SMTP id 17so2139876fxm.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 03:47:42 -0700 (PDT)
Message-ID: <4D7CA0CC.8090308@gmail.com>
Date: Sun, 13 Mar 2011 11:47:40 +0100
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A97BB.4020704@gmail.com> <4D7B7524.2050108@linuxtv.org> <201103130042.49199@orion.escape-edv.de>
In-Reply-To: <201103130042.49199@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Oliver Endriss wrote:
> Hi,
>
> On Saturday 12 March 2011 14:29:08 Andreas Oberritter wrote:
>   
>> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
>>     
>>> Andreas Oberritter wrote:
>>>       
>>>> It's rather unintuitive that some CAMs appear as ca0, while others as
>>>> cam0.
>>>>   
>>>>         
>>> Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
>>> as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
>>> transport stream. To me it  looks like an extension of the current API.
>>>       
>> I see. This raises another problem. How to find out, which ca device
>> cam0 relates to, in case there are more ca devices than cam devices?
>>     
>
> Hm, I do not see a problem here. The API extension is simple:
>
> (1) camX is optional. If camX exists, it is tied to caX.
>
> (2) If there is no camX, the CI/CAM operates in 'legacy mode'.
>
> (3) If camX exists, the encrypted transport stream of the CI/CAM is sent
>     through camX, and the decrypted stream is received from camX.
>     caX behaves the same way as in (2).
>
> Btw, we should choose a more meaningful name for 'camX'.
> I would prefer something like cainoutX or caioX or cinoutX or cioX.
>   

I agree, camX could be misleading since it's not necessarily a CAM 
application.

According to EN 50221 the two interfaces are named Command Interface 
(for caX)
and Transport Stream Interface (for camX). Then maybe 'tsiX' would be an 
appropriate
name?

Anyway, 'cioX' sounds good too.

Regards,
Martin
