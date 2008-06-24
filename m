Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [88.151.248.2] (helo=mail.krastelcom.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1KB0cy-00012N-Tz
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 06:59:41 +0200
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: ua0lnj <ua0lnj@bk.ru>
In-Reply-To: <DD6302F4D4084A839650A2FE7D164C76@ua0lnjhome>
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
	<DD6302F4D4084A839650A2FE7D164C76@ua0lnjhome>
Message-Id: <976C5CAC-6426-456A-9509-B7575CB3C5B0@krastelcom.ru>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 24 Jun 2008 08:59:32 +0400
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Express AM2 11044 H 45 MSps
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

Cool. But TT S-1500 and TT S2-3200 have different tuners. Can you take  
a look at those?

Regards,
Vladimir

On Jun 24, 2008, at 8:06 AM, ua0lnj wrote:

> I use TT budget S-1102, it have Philips su-1278 tuner.
> Locked SR 45 MSps on AM2 80E fine.
> But need use my patch for dvb driver, I posted it twice in dvb mail- 
> list, but no response from any user...
>
>
> ----- Original Message ----- From: "Vladimir Prudnikov" <vpr@krastelcom.ru 
> >
> To: "Linux DVB Mailing List" <linux-dvb@linuxtv.org>
> Sent: Monday, June 23, 2008 4:53 PM
> Subject: [linux-dvb] Express AM2 11044 H 45 MSps
>
>
>> Hi!
>>
>> I have recently realized that none of the available cards are able to
>> properly lock on Express AM2 11044H 45 MSps . The only one that can  
>> is
>> TT-S1401 with buf[5] register corrections.
>>
>> I have tried:
>>
>> TT S-1500
>> TT S2-3200
>> Skystar 2.6
>> TT S-1401 with non-modified drivers.
>>
>> Regards,
>> Vladimir
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
