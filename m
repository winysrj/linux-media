Return-path: <mchehab@pedra>
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:63007 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0IOSel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 14:34:41 -0400
Message-ID: <4C910AF7.9050605@pec.homeip.net>
Date: Wed, 15 Sep 2010 20:05:43 +0200
From: Peter Evertz <leo2@pec.homeip.net>
MIME-Version: 1.0
To: Simon Liddicott <simon@liddicott.com>
CC: Suchita Gupta <suchitagupta@yahoo.com>, linux-media@vger.kernel.org
Subject: Re: Fw: [linux-dvb] DSM-CC question
References: <397375.74162.qm@web55403.mail.re4.yahoo.com> <AANLkTikvMqZyrBWsdo5iGuGES9q4wjj2TJW2HZS5cOtV@mail.gmail.com>
In-Reply-To: <AANLkTikvMqZyrBWsdo5iGuGES9q4wjj2TJW2HZS5cOtV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
>> First of all, I am new to this list, so I am not sire if this is right place for
>>
>> this question.
>> If not, please forgive me and point me to right list.
>>
>> I am writing a DSMCC decoding implementation to persist it to local filesystem.
>> I am unable to understand few thiings related to "srg"
>>
>> I know, it represents the top level directory. But how do I get the name of this
>>
>> directory?
>> I can extract the names of subdirs and files using name components but where is
>> the name of top level directory?
>>
>> Also, as far as I understand it, I can't start writing to the local filesystem
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

