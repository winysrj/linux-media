Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36629 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab3B0PMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:12:16 -0500
Message-ID: <512E0E2B.6020706@schinagl.nl>
Date: Wed, 27 Feb 2013 14:46:19 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Christian Affolter <c.affolter@purplehaze.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Initial tuning data for upc cablecom Berne, Switzerland
References: <512D2C54.7010205@purplehaze.ch> <512DF217.3000305@schinagl.nl> <512E0DE4.10709@purplehaze.ch> <512E04DE.2040305@schinagl.nl>
In-Reply-To: <512E04DE.2040305@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-02-13 14:06, Oliver Schinagl wrote:
> On 27-02-13 14:45, Christian Affolter wrote:
>> Hi Oliver
>>
>>>> Hi
>>>>
>>>> please find the initial tuning data for the Swiss cable provider "upc
>>>> cablecom" in Berne.
>>>>
>>>> I've added the data below to dvb-c/ch-Bern-upc-cablecom
>>>>
>>>> # upc cablecom
>>>> # Berne, Switzerland
>>>> # freq sr fec mod
>>>> C 426000000 6900000 NONE QAM64
>>> Thanks,
>>>
>>> pushed in 5493eb3f5f7801cc409596de0e2d0edb499daf70
>> Thanks a lot, but watch out for the typo within the file name [1]:
>> The companies brand is spelled 'upc cablecom' [2] not 'UPC-Capblecom'.
>>
> I will adjust this immediatly the typo (do'h cablecom, capcom!) and 
> the capitisation. It appeared that it was lazy capitalization from 
> your end for that I apologize. I wrongfully assumed since UPC here in 
> NL is in caps, it should have been there as well. I'll lower the ch one.
Adjusted in 88b27009b76203b1a2583a6fe8d7c9d866ede808

nl-upc has also been lowercased as that is their official branding here 
in NL as well [1].

[1] http://www.upc.nl
>
>> Thanks again and best regards
>> Christian
>>
>>
>> [1]
>> http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-c/ch-Bern-UPC-Capblecom 
>>
>> [2] http://www.upc-cablecom.ch/en/b2c/about/ueberuns.htm
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

