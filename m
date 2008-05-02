Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [203.200.233.138] (helo=nkindia.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gurumurti@nkindia.com>) id 1JrvEn-0002y2-3U
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 15:23:45 +0200
Message-ID: <41108.203.200.233.131.1209735622.squirrel@203.200.233.138>
In-Reply-To: <001f01c8ac52$8fc92900$af5b7b00$@com>
References: <38846.203.200.233.131.1209733086.squirrel@203.200.233.138>
	<001f01c8ac52$8fc92900$af5b7b00$@com>
Date: Fri, 2 May 2008 19:10:22 +0530 (IST)
From: "Gurumurti Laxman Maharana" <gurumurti@nkindia.com>
To: "Ben Backx" <ben@bbackx.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] pes to ts conversion
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


If I am wrong pls correct me.

PES may be as big as 65536 bytes and TS are of fixes size 188 Bytes. we
have to break this bigger PES into smaller TS.
isn't it so?



> Shouldn't you do it the other way around?
> There are different PES in one TS, so it's breaking up the TS into PES...
> Or combine PES into one TS...
> I'm currently working on a program to split the TS into different PES, if
> you're interested, I'll publish the code.
>
>
> Regards,
> Ben
>
>> -----Original Message-----
>> From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-
>> bounces@linuxtv.org] On Behalf Of Gurumurti Laxman Maharana
>> Sent: 02 May 2008 14:58
>> To: linux-dvb@linuxtv.org
>> Subject: [linux-dvb] pes to ts conversion
>>
>> Hi All
>> I want to know the steps to convert the PES stream to TS.
>> basically to break PES into TS.
>> Can any body help inthis regard or siggest any document or site.
>> thanks with regards.
>> --
>> guru
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


-- 
G. L. Maharana


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
