Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f27.google.com ([209.85.220.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJCKl-0007dO-P3
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 20:38:57 +0100
Received: by fxm8 with SMTP id 8so1289760fxm.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 11:38:22 -0800 (PST)
Date: Sat, 03 Jan 2009 20:39:05 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
Message-ID: <op.um64vfdkrj95b0@localhost>
In-Reply-To: <c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
Reply-To: kedgedev@centrum.cz
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

On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis <alex.betis@gmail.com> wrote:

>> I use scan from dvb-apps, the command is
>> "scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
>> where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"
>
> I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
> astra's maintainers and connect to any transponder is enough to get a  
> list
> of all others. I personaly don't trust those maintainers since I saw too
> many errors in NIT messages that specify the transponder, so I specify  
> all
> the frequencies I want to scan. I don't have a dish to 19.2, but there  
> were
> many errors with 5 other satellites I have.
> You can get a list of those frequencies here:
> http://www.lyngsat.com/astra19.html

Could you tell me how? I've tried with S 12188000 H 27500000 3/4 and
it doesn't find anything.

>
>
>>
>> I use cx88-dvb driver but many modules are loaded with it see
>> http://kedge.wz.cz/dvb/lsmod.txt
>
> I meant to ask what is the origin of the driver. I use Igor's driver  
> from:
> http://mercurial.intuxication.org/hg/s2-liplianin/

I use driver from vanilla kernel 2.6.28 which have DVB api version 5.0.

> If you have a S2API driver (or will use Igor's driver), you can use my
> scan-s2 application with many changes in NIT parsing that might resolve  
> your
> issue.
> http://mercurial.intuxication.org/hg/scan-s2/
>

See below.

>>
>> Scan console output is in file http://kedge.wz.cz/dvb/channels.conf
>> and the result in http://kedge.wz.cz/dvb/channels.conf
>
> You've posted the same link for both outputs. Please post console output
> when you run scan with "-v" parameter. Maybe even with "-vv".
>

The console output should be http://kedge.wz.cz/dvb/scanconsoleout.txt.

I've tried to run scan and scan-s2 on "S 12188000 H 27500000 3/4"
were the "RTL 2 Deutschland" channel should be and neither scan found anything.

The console outputs are here:
http://kedge.wz.cz/dvb/scan.txt
http://kedge.wz.cz/dvb/scans2.txt


If you want me to run the whole scan for "S 11567500 V 22000000 5/6" with -vv
let me know and I'll do it.

>>
>> When console shows
>> __tune_to_transponder:1508: ERROR: Setting frontend parameters failed:  
>> 22
>> Invalid argument
>>
>> the dmesg prints
>> DVB: adapter 0 frontend 0 frequency 8175750 out of range  
>> (950000..2150000)
>
> It could be anything. Bad NIT message (most probably) or a memory  
> smashing
> in scan application.
>
>
>>
>>
>> Roman
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
