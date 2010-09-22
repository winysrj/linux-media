Return-path: <mchehab@pedra>
Received: from web55402.mail.re4.yahoo.com ([206.190.58.196]:39216 "HELO
	web55402.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752780Ab0IVNw5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 09:52:57 -0400
Message-ID: <102147.29196.qm@web55402.mail.re4.yahoo.com>
References: <397375.74162.qm@web55403.mail.re4.yahoo.com> <AANLkTikvMqZyrBWsdo5iGuGES9q4wjj2TJW2HZS5cOtV@mail.gmail.com> <4C910AF7.9050605@pec.homeip.net>
Date: Wed, 22 Sep 2010 06:52:51 -0700 (PDT)
From: Suchita Gupta <suchitagupta@yahoo.com>
Subject: Re: Fw: [linux-dvb] DSM-CC question
To: Peter Evertz <leo2@pec.homeip.net>,
	Simon Liddicott <simon@liddicott.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C910AF7.9050605@pec.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

Thanks to everyone for their help.
I am able to build a tree from DSMCC carousel.

I have done only file, dir and srg messages at the time being as I don't 
understand the usage of stream and stream event messages at the moment.
Can anyone please explain these to me and how can they be assembled. 

Thanks,
rs


----- Original Message ----
From: Peter Evertz <leo2@pec.homeip.net>
To: Simon Liddicott <simon@liddicott.com>
Cc: Suchita Gupta <suchitagupta@yahoo.com>; linux-media@vger.kernel.org
Sent: Wed, 15 September, 2010 19:05:43
Subject: Re: Fw: [linux-dvb] DSM-CC question

Or take a look at "mhp" or "dsmcc" plugins for vdr. Both not activ 
projects, but both have a dsmcc implementation.

Are you working on a "hbbtv" solution ?

Simon Liddicott schrieb:
> Have you had a look at the code for redbutton?
>
> http://redbutton.sourceforge.net/
>
> Si
>
> On 14 September 2010 21:32, Suchita Gupta <suchitagupta@yahoo.com> wrote:
>  
>> Hi,
>>
>> First of all, I am new to this list, so I am not sire if this is right place 
>>for
>>
>> this question.
>> If not, please forgive me and point me to right list.
>>
>> I am writing a DSMCC decoding implementation to persist it to local 
>filesystem.
>> I am unable to understand few thiings related to "srg"
>>
>> I know, it represents the top level directory. But how do I get the name of 
>>this
>>
>> directory?
>> I can extract the names of subdirs and files using name components but where 
>is
>> the name of top level directory?
>>
>> Also, as far as I understand it, I can't start writing to the local 
filesystem
>> until I have acquired the whole carousel.
>>
>> Can, anyone please provide me some guidance.
>>
>> Thanks in Advance,
>> rs
>>
>>
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



      
