Return-path: <linux-media-owner@vger.kernel.org>
Received: from hipper.arcada.fi ([193.167.33.246]:57779 "EHLO hipper.arcada.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab3IIKdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 06:33:17 -0400
Message-ID: <522DA3EF.9050806@arcada.fi>
Date: Mon, 09 Sep 2013 13:33:19 +0300
From: Sam Stenvall <sam.stenvall@arcada.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: Updated fi-HTV scan file
References: <522B2BF9.5020701@arcada.fi> <522D8C28.1070803@schinagl.nl>
In-Reply-To: <522D8C28.1070803@schinagl.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9.9.2013 11:51, Oliver Schinagl wrote:
> On 07-09-13 15:36, Sam Stenvall wrote:
>> Hi,
> Hello,
>
>>
>> Here's an updated fi-HTV scan file according to the official
>> specification available at http://dvb.welho.fi/cable.php.
>
> Patch merged manually and pushed, your diff failed to apply, did you use
> git diff?
>
> Oliver

I used hg diff and copy pasted the output.

>>
>> diff -r 3ee111da5b3a util/scan/dvb-c/fi-HTV
>> --- a/util/scan/dvb-c/fi-HTV    Mon May 13 15:49:02 2013 +0530
>> +++ b/util/scan/dvb-c/fi-HTV    Sat Sep 07 16:32:53 2013 +0300
>> @@ -1,4 +1,38 @@
>>   # HTV
>>   # freq sr fec mod
>> -C 283000000 5900000 NONE QAM128
>> +C 274000000 6900000 NONE QAM128
>> +C 282000000 6900000 NONE QAM128
>> +C 162000000 6900000 NONE QAM64
>> +C 170000000 6900000 NONE QAM128
>> +C 290000000 6900000 NONE QAM128
>> +C 146000000 6900000 NONE QAM128
>>   C 154000000 6900000 NONE QAM128
>> +C 138000000 6900000 NONE QAM128
>> +C 266000000 6900000 NONE QAM128
>> +C 362000000 6900000 NONE QAM128
>> +C 298000000 6900000 NONE QAM128
>> +C 354000000 6900000 NONE QAM128
>> +C 370000000 6900000 NONE QAM128
>> +C 378000000 6900000 NONE QAM128
>> +C 394000000 6900000 NONE QAM128
>> +C 386000000 6900000 NONE QAM128
>> +C 258000000 6900000 NONE QAM128
>> +C 250000000 6900000 NONE QAM128
>> +C 314000000 6900000 NONE QAM128
>> +C 306000000 6900000 NONE QAM64
>> +C 322000000 6900000 NONE QAM128
>> +C 330000000 6900000 NONE QAM256
>> +C 338000000 6900000 NONE QAM256
>> +C 346000000 6900000 NONE QAM128
>> +C 234000000 6900000 NONE QAM256
>> +C 210000000 6900000 NONE QAM256
>> +C 218000000 6900000 NONE QAM256
>> +C 226000000 6900000 NONE QAM256
>> +C 178000000 6900000 NONE QAM256
>> +C 186000000 6900000 NONE QAM256
>> +C 194000000 6900000 NONE QAM256
>> +C 202000000 6900000 NONE QAM256
>> +C 514000000 6900000 NONE QAM256
>> +C 522000000 6900000 NONE QAM256
>> +C 530000000 6900000 NONE QAM256
>> +C 554000000 6900000 NONE QAM256
>>
>> Regards,
>> Sam Stenvall
>>

-- 

Sam Stenvall
+358 (0)40 509 0191
sam.stenvall@arcada.fi
