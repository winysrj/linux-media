Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJA56-0002pt-Kn
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 18:14:37 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2442873fga.25
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 09:14:33 -0800 (PST)
Date: Sat, 03 Jan 2009 18:15:06 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost> <495F99CD.8000202@braice.net>
Message-ID: <op.um6x7g0vrj95b0@localhost>
In-Reply-To: <495F99CD.8000202@braice.net>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
Reply-To: kedgedev@centrum.cz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, 03 Jan 2009 18:01:01 +0100, Brice DUBOST <braice@braice.net> wrote:

> Roman Jarosz a =E9crit :
>> Hi,
>>
>> I have a problem with DVB-S channel searching, the scan command doesn't  =

>> find all channels in Linux on Astra 19.2E.
>> It works in Windows.
>>
>> For instance the scan doesn't find RTL2, but if I add to channels.conf
>> RTL2:12187:h:0:27500:166:128:12020
>> then szap -r works correctly.
>>
>> I have TeVii S460 DVB-S/S2.
>> Linux kernel 2.6.28.
>>
>> Can anybody help me to find out why the scan doesn't work correctly.
>> I've compiled kernel from source so I can apply patches or change its  =

>> settings.
>>
>> Regards,
>> Roman
>>
>
>
> Hello
>
> Scan tunes on one frequency, and uses the informations given by the
> provider to find the others
>
> Sometimes (quite often in fact) the providers doesn't give full  =

> informations
>
> You can use wscan wich will try to lock on each possible frequency
> (longer method)

I can't make it work

Info: using DVB adapter auto detection.
   Wrong type, ignoring frontend /dev/dvb/adapter0/frontend0
main:2762: FATAL: ***** NO USEABLE DVB CARD FOUND. *****

and on w_scan homepage is said that it doesn't work with DVB-S.


> regards
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
