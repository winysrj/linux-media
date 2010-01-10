Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38057 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0AJNfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 08:35:41 -0500
Received: by fxm25 with SMTP id 25so60362fxm.21
        for <linux-media@vger.kernel.org>; Sun, 10 Jan 2010 05:35:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B49D1A4.4040702@gmail.com>
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>
	 <3f3a053b1001021411i2e9484d7rd2d13f1a355939fe@mail.gmail.com>
	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>
	 <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>
	 <4B49D1A4.4040702@gmail.com>
Date: Sun, 10 Jan 2010 17:35:38 +0400
Message-ID: <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com>
Subject: Re: CI USB
From: Manu Abraham <abraham.manu@gmail.com>
To: Emmanuel <eallaud@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 10, 2010 at 5:09 PM, Emmanuel <eallaud@gmail.com> wrote:
> Markus Rechberger a écrit :
>>
>> On Sat, Jan 2, 2010 at 11:55 PM, HoP <jpetrous@gmail.com> wrote:
>>
>>>
>>> Hi Jonas
>>>
>>>
>>>>
>>>> Does anyone know if there's any progress on USB CI adapter support?
>>>> Last posts I can find are from 2008 (Terratec Cinergy CI USB &
>>>> Hauppauge WinTV-CI).
>>>>
>>>> That attempt seems to have stranded with Luc Brosens (who gave it a
>>>> shot back then) asking for help.
>>>>
>>>> The chip manufacturer introduced a usb stick as well;
>>>>
>>>> http://www.smardtv.com/index.php?page=products_listing&rubrique=pctv&section=usbcam
>>>> but besides the scary Vista logo on that page, it looks like they
>>>> target broadcast companies only and not end users.
>>>>
>>>>
>>>
>>> You are right. Seems DVB CI stick is not targeted to end consumers.
>>>
>>> Anyway, it looks interesting, even it requires additional DVB tuner
>>> "somewhere in the pc" what means duplicated traffic (to the CI stick
>>> for descrambling and back for mpeg a/v decoding).
>>>
>>> It would be nice to see such stuff working in linux, but because of
>>> market targeting i don' t expect that.
>>>
>>> BTW, Hauppauge's WinTV-CI looked much more promissing.
>>> At least when I started reading whole thread about it here:
>>> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg28113.html
>>>
>>> Unfortunatelly, last Steve's note about not getting anything
>>> (even any answer) has disappointed me fully. And because
>>> google is quiet about any progress on it I pressume
>>> no any docu nor driver was released later on.
>>>
>>>
>>
>> The question is more or less how many people are interested in USB CI
>> support for Linux.
>> We basically have everything to provide a USB CI solution for linux now.
>>
>> Markus
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Well I dont know for others but it really looks interesting as you can have
> multiple cards with only one CI, meaning only one CAM and only one
> subscription card which is economically interesting.


I don't know the details into the USB device, but each of those CAM's
have bandwidth limits on them and they vary from one CAM to the other.
Also, there is a limit on the number of simultaneous PID's that which
you can decrypt.

Some allow only 1 PID, some allow 3. Those are the basic CAM's for
home usage.The most expensive CAM's allow a maximum of 24 PID's. But
then you would be better of buying multiple CAM's for a home use
purpose.



> Also some card (at least for DVB-S) are really good but targeted towards
> free channels, and in France for example, alot of good channels are not.
> If the price is right (tm) I am sure a lot of people would be interested.
> Bye
> Manu


Regards,
Mmanu
