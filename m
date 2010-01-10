Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:34121 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0AJWsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 17:48:30 -0500
Received: by qyk32 with SMTP id 32so1543156qyk.4
        for <linux-media@vger.kernel.org>; Sun, 10 Jan 2010 14:48:29 -0800 (PST)
Message-ID: <4B4A598D.2090105@gmail.com>
Date: Sun, 10 Jan 2010 18:49:49 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: CI USB
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>	 <3f3a053b1001021411i2e9484d7rd2d13f1a355939fe@mail.gmail.com>	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>	 <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>	 <4B49D1A4.4040702@gmail.com> <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com>
In-Reply-To: <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham a �crit :
> On Sun, Jan 10, 2010 at 5:09 PM, Emmanuel <eallaud@gmail.com> wrote:
>   
>> Markus Rechberger a �crit :
>>     
>>> On Sat, Jan 2, 2010 at 11:55 PM, HoP <jpetrous@gmail.com> wrote:
>>>
>>>       
>>>> Hi Jonas
>>>>
>>>>
>>>>         
>>>>> Does anyone know if there's any progress on USB CI adapter support?
>>>>> Last posts I can find are from 2008 (Terratec Cinergy CI USB &
>>>>> Hauppauge WinTV-CI).
>>>>>
>>>>> That attempt seems to have stranded with Luc Brosens (who gave it a
>>>>> shot back then) asking for help.
>>>>>
>>>>> The chip manufacturer introduced a usb stick as well;
>>>>>
>>>>> http://www.smardtv.com/index.php?page=products_listing&rubrique=pctv&section=usbcam
>>>>> but besides the scary Vista logo on that page, it looks like they
>>>>> target broadcast companies only and not end users.
>>>>>
>>>>>
>>>>>           
>>>> You are right. Seems DVB CI stick is not targeted to end consumers.
>>>>
>>>> Anyway, it looks interesting, even it requires additional DVB tuner
>>>> "somewhere in the pc" what means duplicated traffic (to the CI stick
>>>> for descrambling and back for mpeg a/v decoding).
>>>>
>>>> It would be nice to see such stuff working in linux, but because of
>>>> market targeting i don' t expect that.
>>>>
>>>> BTW, Hauppauge's WinTV-CI looked much more promissing.
>>>> At least when I started reading whole thread about it here:
>>>> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg28113.html
>>>>
>>>> Unfortunatelly, last Steve's note about not getting anything
>>>> (even any answer) has disappointed me fully. And because
>>>> google is quiet about any progress on it I pressume
>>>> no any docu nor driver was released later on.
>>>>
>>>>
>>>>         
>>> The question is more or less how many people are interested in USB CI
>>> support for Linux.
>>> We basically have everything to provide a USB CI solution for linux now.
>>>
>>> Markus
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>       
>> Well I dont know for others but it really looks interesting as you can have
>> multiple cards with only one CI, meaning only one CAM and only one
>> subscription card which is economically interesting.
>>     
>
>
> I don't know the details into the USB device, but each of those CAM's
> have bandwidth limits on them and they vary from one CAM to the other.
> Also, there is a limit on the number of simultaneous PID's that which
> you can decrypt.
>
> Some allow only 1 PID, some allow 3. Those are the basic CAM's for
> home usage.The most expensive CAM's allow a maximum of 24 PID's. But
> then you would be better of buying multiple CAM's for a home use
> purpose.
>   
Well  my Astoncrypt is able to descramble 2 channels simultanueously, 
but here the good thing would be that you could descramble after the 
recording, so that you would be able for example to capture 4 channels 
on the same transponder only to descramble one by one later on.
Bye
Manu

