Return-path: <linux-media-owner@vger.kernel.org>
Received: from amber.schedom-europe.net ([193.109.184.92]:48368 "EHLO
	amber.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0AJSzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 13:55:04 -0500
Message-ID: <4B4A226C.4000806@dommel.be>
Date: Sun, 10 Jan 2010 19:54:36 +0100
From: Johan <johan.vanderkolk@dommel.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: CI USB]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Sun, Jan 10, 2010 at 5:09 PM, Emmanuel <eallaud@gmail.com> wrote:
>  
>> Markus Rechberger a écrit :
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
>>>>>
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
>>> We basically have everything to provide a USB CI solution for linux 
>>> now.
>>>
>>> Markus
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>       
>> Well I dont know for others but it really looks interesting as you 
>> can have
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
>
>
>  
>> Also some card (at least for DVB-S) are really good but targeted towards
>> free channels, and in France for example, alot of good channels are not.
>> If the price is right (tm) I am sure a lot of people would be 
>> interested.
>> Bye
>> Manu
>>     
>
>
> Regards,
> Mmanu
>   
Here in Belgium and the Netherlands all channels are encrypted and 
besides the economics, I have very little possibility to view those 
channels.
(not since my nexus-S with dual CI is not keeping up with the latest 
developments anymore).

I now own a HVR4000, but Hauppauge are only supporting the USB CI for 
all new cards and apparently dropped the flatcable direct connection to 
a CI interface.
There is software available to use a USB cardreader, which I am using 
now. This software however permits illegal distribution of keys as well.

Interesting though is that this software doesn't use the official CI, 
nor a CAM, but a generic USB smartcard reader.
If a solution could be developed, which is manufacturer independent, 
does not use a CAM and does not permit illegal use that would be great...

regards,

Johan
