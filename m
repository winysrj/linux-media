Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1BYG5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 01:57:19 -0500
Message-ID: <4D6752C9.1090805@suse.cz>
Date: Fri, 25 Feb 2011 07:57:13 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [PATCH 1/1] DVB-USB: dib0700, fix oops with non-dib7000pc devices
References: <1296930047-22689-1-git-send-email-jslaby@suse.cz> <4D664DE5.7020002@gmail.com> <4D6654B2.1080707@infradead.org> <4D665FFF.7050501@suse.cz> <4D6661E4.6040505@infradead.org>
In-Reply-To: <4D6661E4.6040505@infradead.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/24/2011 02:49 PM, Mauro Carvalho Chehab wrote:
> Em 24-02-2011 10:41, Jiri Slaby escreveu:
>> On 02/24/2011 01:53 PM, Mauro Carvalho Chehab wrote:
>>> Em 24-02-2011 09:24, Jiri Slaby escreveu:
>>>> Hmm, could anybody pick it up?
>>>>
>>>> On 02/05/2011 07:20 PM, Jiri Slaby wrote:
>>>>> These devices use different internal structures (dib7000m) and
>>>>> dib7000p pid ctrl accesses invalid members causing kernel to die.
>>>>>
>>>>> Introduce pid control functions for dib7000m which operate on the
>>>>> correct structure.
>>>
>>> Patrick (DibCom drivers maintainer) has proposed an alternate patch for it [1]
>>> that properly address the issues:
>>>
>>> http://git.linuxtv.org/pb/media_tree.git?a=commitdiff;h=80a5f1fdc6beb496347cbb297f9c1458c8cb9f50
>>>
>>> [1] http://www.spinics.net/lists/linux-media/msg27890.html
>>>
>>> Could you please test it?
>>
>> Yes, I will later.
>>
>> Is there any reason why this is not in Linus' and stable trees and
>> mainly in linux/next already?
> 
> Yes. I'm waiting for confirmation that this patch fixes the reported issue.

Ok, it works as expected.

Tested-by: Pavel SKARKA <paul.sp@seznam.cz>
References: https://bugzilla.novell.com/show_bug.cgi?id=644807

thanks,
-- 
js
suse labs
