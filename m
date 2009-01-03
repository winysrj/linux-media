Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJDaE-0006OG-HM
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 21:58:59 +0100
Received: by bwz11 with SMTP id 11so14784176bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 12:58:25 -0800 (PST)
Date: Sat, 03 Jan 2009 21:59:08 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<op.um64vfdkrj95b0@localhost>
	<c74595dc0901031248h3c3d002j2422331c82249d78@mail.gmail.com>
Message-ID: <op.um68ku1qrj95b0@localhost>
In-Reply-To: <c74595dc0901031248h3c3d002j2422331c82249d78@mail.gmail.com>
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

On Sat, 03 Jan 2009 21:48:45 +0100, Alex Betis <alex.betis@gmail.com> wrote:

> On Sat, Jan 3, 2009 at 9:39 PM, Roman Jarosz <roman.jarosz@gmail.com>  
> wrote:
>
>> On Sat, 03 Jan 2009 19:58:45 +0100, Alex Betis <alex.betis@gmail.com>
>> wrote:
>>
>> >> I use scan from dvb-apps, the command is
>> >> "scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
>> >> where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"
>> >
>> > I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
>> > astra's maintainers and connect to any transponder is enough to get a
>> > list
>> > of all others. I personaly don't trust those maintainers since I saw  
>> too
>> > many errors in NIT messages that specify the transponder, so I specify
>> > all
>> > the frequencies I want to scan. I don't have a dish to 19.2, but there
>> > were
>> > many errors with 5 other satellites I have.
>> > You can get a list of those frequencies here:
>> > http://www.lyngsat.com/astra19.html
>>
>> Could you tell me how? I've tried with S 12188000 H 27500000 3/4 and
>> it doesn't find anything.
>
> Try also scan-s2 with:
> S 12188000 H 27500000 3/4 AUTO QPSK

No luck :( http://kedge.wz.cz/dvb/scans2_2.txt


> Do you have a diseqc on the way?

No. I don't.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
