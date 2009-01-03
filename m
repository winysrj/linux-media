Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f30.google.com ([209.85.218.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJAxi-0007qr-RP
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:11:04 +0100
Received: by bwz11 with SMTP id 11so5077906bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 10:10:29 -0800 (PST)
Date: Sat, 03 Jan 2009 19:11:13 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
Message-ID: <op.um60szqyrj95b0@localhost>
In-Reply-To: <c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
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

On Sat, 03 Jan 2009 18:28:03 +0100, Alex Betis <alex.betis@gmail.com> wrote:

> On Sat, Jan 3, 2009 at 6:42 PM, Roman Jarosz <roman.jarosz@gmail.com>  
> wrote:
>
>> Hi,
>>
>> I have a problem with DVB-S channel searching, the scan command doesn't
>> find all channels in Linux on Astra 19.2E.
>> It works in Windows.
>>
> Please specify what driver you use, what scan application, what is the
> command line you gave to the scan application, what is the frequency file
> you've used for scan application, what is the result of the scan you  
> have.
>
> Than maybe I can help somehow.

I use scan from dvb-apps, the command is
"scan -o vdr /root/dvb/Astra-19.2E > /etc/vdr/channels.conf"
where /root/dvb/Astra-19.2E is file with "S 11567500 V 22000000 5/6"

I use cx88-dvb driver but many modules are loaded with it see
http://kedge.wz.cz/dvb/lsmod.txt

Scan console output is in file http://kedge.wz.cz/dvb/channels.conf
and the result in http://kedge.wz.cz/dvb/channels.conf

When console shows
__tune_to_transponder:1508: ERROR: Setting frontend parameters failed: 22 Invalid argument

the dmesg prints
DVB: adapter 0 frontend 0 frequency 8175750 out of range (950000..2150000)

Roman

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
