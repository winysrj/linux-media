Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43055 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3COTSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 15:18:03 -0400
Received: by mail-ee0-f46.google.com with SMTP id e49so1798312eek.33
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2013 12:18:01 -0700 (PDT)
Message-ID: <514381F5.2080900@gmail.com>
Date: Fri, 15 Mar 2013 21:17:57 +0100
From: Benjamin Schindler <beschindler@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: msp3400 problem in linux-3.7.0
References: <51410709.5040805@gmail.com> <201303140844.37378.hverkuil@xs4all.nl> <5142F063.5000007@gmail.com> <201303151020.02817.hverkuil@xs4all.nl>
In-Reply-To: <201303151020.02817.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I think I've just been really stupid. I tried latest git, but got not 
sound. I then checked my volumes again and noticed, that the rear-mic 
channel was muted. I didn't have that channel in 3.2 (just had mic) so I 
didn't notice...

So may be sound wasn't broken after all in vanilla. Would it be of any 
interest if I were to check?

Regards
Benjamin

On 15.03.2013 10:20, Hans Verkuil wrote:
> On Fri March 15 2013 10:56:51 Benjamin Schindler wrote:
>> I just tried to apply the patch, but it does not apply cleanly:
>>
>> metis linux # patch -p1 < /home/benjamin/Downloads/bttv-patch.txt
>> patching file drivers/media/pci/bt8xx/bttv-driver.c
>> Hunk #1 FAILED at 2007.
>> Hunk #2 FAILED at 2024.
>> Hunk #3 succeeded at 4269 with fuzz 2 (offset 34 lines).
>> Hunk #4 succeeded at 4414 (offset 34 lines).
>> 2 out of 4 hunks FAILED -- saving rejects to file
>> drivers/media/pci/bt8xx/bttv-driver.c.rej
>> patching file drivers/media/pci/bt8xx/bttvp.h
>>
>> I then tried applying it manually, which I think worked. But it did not
>> fix the problem. Given that the patch did not apply cleanly, may be I
>> should either use the media git tree or wait for 3.10.
>
> You might want to try the media git tree (if only so that we know that it
> really fixes your problem). 3.10 will be another 5 months or so before that
> is released.
>
> Regards,
>
> 	Hans
>
>>
>> I just realized that this was on a 3.7.10 kernel (not 3.7.0, but that
>> probably does not make much of a difference)
>>
>> Regards
>> Benjamin
>>
>> On 14.03.2013 08:44, Hans Verkuil wrote:
>>> On Thu March 14 2013 08:13:29 Benjamin Schindler wrote:
>>>> Hi Hans
>>>>
>>>> Thank you for the prompt response. I will try this once I'm home again.
>>>> Which patch is responsible for fixing it? Just so I can track it once it
>>>> lands upstream.
>>>
>>> There is a whole series of bttv fixes that I did that will appear in 3.10.
>>>
>>> But the patch that is probably responsible for fixing it is this one:
>>>
>>> http://git.linuxtv.org/media_tree.git/commit/76ea992a036c4a5d3bc606a79ef775dd32fd3daa
>>>
>>> I say 'probably' because I am not 100% certain that that is the main fix.
>>> I'm 99% certain, though :-)
>>>
>>> As mentioned, it was part of a much longer patch series, so there may be other
>>> patches involved in this particular problem, but I don't think so.
>>>
>>> If you can perhaps test just that single patch then that would be useful
>>> information. If that fixes the problem then that's a candidate for 'stable'
>>> kernels.
>>>
>>>> I have one more question - the wiki states the the WinTV-HVR-5500 is not
>>>> yet supported (as of June 2011) - is there an update on this? It's the
>>>> only DVB-C card I can buy in the local stores here
>>>
>>> No idea. I do V4L2, not DVB :-) Hopefully someone else knows.
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

