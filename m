Return-path: <linux-media-owner@vger.kernel.org>
Received: from transplaneta.com ([85.214.124.138]:50211 "EHLO
	www.transplaneta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbZISBQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 21:16:14 -0400
Message-Id: <4DA4F345-7A25-41C7-A24F-875A13EFB480@transplaneta.com>
From: Karsten Siebert <Karsten.Siebert@transplaneta.com>
To: linux-media@vger.kernel.org
In-Reply-To: <d2f7e03e0909181759qf552c86x6fd0cdc818f829b@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [linux-dvb] choice between MPE and ULE in the code
Date: Sat, 19 Sep 2009 03:09:34 +0200
References: <4AB39EF2.3020807@sipradius.com> <d2f7e03e0909181759qf552c86x6fd0cdc818f829b@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbnet contains a parameter, which lets select MPE or ULE. feedtype 0  
or 1 will decide whether the filters in dvb_net will be set for ULE or  
MPE. Once you activate a dvb data interface you select MPE or ULE for  
that PID, you want to receive.


Am 19.09.2009 um 02:59 schrieb Seyyed Mohammad mohammadzadeh:

> I have tried the ULE decapsulation part of code. you can find it in
> the v4l_dvb/linux/driver/media/dvb_core/dvb_net.c you must force ULE
> decapsulation in the code and there is no media to choose it run-time.
> The decapsulation code is too bogus and useless. I'm trying to write a
> new decapsulator based on the original code.
>
> 2009/9/18, Sylvain LESAGE <sylvain@sipradius.com>:
>> Hi,
>>
>> I am working on ULE (ultra-lightweight encapsulation) and MPE
>> (multi-protocol encapsulation) decapsulation of transport stream
>> packets. I can't find, in the code of linuxDVB, where the choice is  
>> done
>> between ULE or MPE when parsing the packets ?
>> Does someone has an idea ?
>>
>> Thank you.
>> Sylvain LESAGE
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux- 
> media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

