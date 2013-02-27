Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:40086 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3B0Xq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 18:46:59 -0500
Message-ID: <512E9B36.2030002@schinagl.nl>
Date: Thu, 28 Feb 2013 00:48:06 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Christian Affolter <c.affolter@purplehaze.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Initial tuning data for upc cablecom Berne, Switzerland
References: <512D2C54.7010205@purplehaze.ch> <512DF217.3000305@schinagl.nl> <512E0DE4.10709@purplehaze.ch> <512E04DE.2040305@schinagl.nl> <512E0E2B.6020706@schinagl.nl> <512E278E.5040901@purplehaze.ch>
In-Reply-To: <512E278E.5040901@purplehaze.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/13 16:34, Christian Affolter wrote:
> Hi Oliver
>
>>>>>> please find the initial tuning data for the Swiss cable provider "upc
>>>>>> cablecom" in Berne.
>>>>>>
>>>>>> I've added the data below to dvb-c/ch-Bern-upc-cablecom
>>>>>>
>>>>>> # upc cablecom
>>>>>> # Berne, Switzerland
>>>>>> # freq sr fec mod
>>>>>> C 426000000 6900000 NONE QAM64
>>>>> Thanks,
>>>>>
>>>>> pushed in 5493eb3f5f7801cc409596de0e2d0edb499daf70
>>>> Thanks a lot, but watch out for the typo within the file name [1]:
>>>> The companies brand is spelled 'upc cablecom' [2] not 'UPC-Capblecom'.
>>>>
>>> I will adjust this immediatly the typo (do'h cablecom, capcom!) and
>>> the capitisation. It appeared that it was lazy capitalization from
>>> your end for that I apologize. I wrongfully assumed since UPC here in
>>> NL is in caps, it should have been there as well. I'll lower the ch one.
>> Adjusted in 88b27009b76203b1a2583a6fe8d7c9d866ede808
>
> Thanks a lot for applying, though I can still see the old files in HEAD...
>
>
>> nl-upc has also been lowercased as that is their official branding here
>> in NL as well [1].
>
> While you're in the renaming mood, 'ch-Zuerich-cablecom' could also be
> renamed to 'ch-Zuerich-upc-cablecom' with the following content
> (according to the cablcom's website, the tuning data still seems to be
> correct):
> # upc cablecom
> # Zurich, Switzerland
> # freq sr fec mod
> C 410000000 6900000 NONE QAM64
Applied and corrected in 3c5fe8488340f23aab289a4f08ed517cacb84b0d
>
> So, and now I stop bothering you ;)
No bother at all. Correct scanfiles is best for all.

>
> Cheers and thanks again for your work!
> Christian
>
>>
>> [1] http://www.upc.nl
>>>
>>>> Thanks again and best regards
>>>> Christian
>>>>
>>>>
>>>> [1]
>>>> http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-c/ch-Bern-UPC-Capblecom
>>>>
>>>> [2] http://www.upc-cablecom.ch/en/b2c/about/ueberuns.htm

