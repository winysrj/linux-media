Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp104.mail.ukl.yahoo.com ([77.238.184.36]:36812 "HELO
	smtp104.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753334AbZISBNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 21:13:46 -0400
Message-ID: <4AB42EBB.9070807@sipradius.com>
Date: Fri, 18 Sep 2009 21:07:07 -0400
From: Sylvain LESAGE <sylvain@sipradius.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] choice between MPE and ULE in the code
References: <4AB39EF2.3020807@sipradius.com> <d2f7e03e0909181759qf552c86x6fd0cdc818f829b@mail.gmail.com>
In-Reply-To: <d2f7e03e0909181759qf552c86x6fd0cdc818f829b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you very much for your answer, Seyyed... I was pretty sure there 
was a place in the code dedicated to this choice between MPE and ULE, 
but I couldn't find it. I better understand why, now.

Sylvain LESAGE

Seyyed Mohammad mohammadzadeh a écrit :
> I have tried the ULE decapsulation part of code. you can find it in
> the v4l_dvb/linux/driver/media/dvb_core/dvb_net.c you must force ULE
> decapsulation in the code and there is no media to choose it run-time.
> The decapsulation code is too bogus and useless. I'm trying to write a
> new decapsulator based on the original code.
>
> 2009/9/18, Sylvain LESAGE <sylvain@sipradius.com>:
>   
>> Hi,
>>
>> I am working on ULE (ultra-lightweight encapsulation) and MPE
>> (multi-protocol encapsulation) decapsulation of transport stream
>> packets. I can't find, in the code of linuxDVB, where the choice is done
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
>>     
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

