Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KYmwq-0000oZ-OA
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 21:14:26 +0200
Received: by fg-out-1718.google.com with SMTP id e21so331493fga.25
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 12:14:21 -0700 (PDT)
Message-ID: <37219a840808281214r18d90a95s389c1f5d3234bf9f@mail.gmail.com>
Date: Thu, 28 Aug 2008 15:14:16 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Paul Gardiner" <lists@glidos.net>
In-Reply-To: <48B6EFE1.3040009@glidos.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>
	<48B64690.4060205@glidos.net>
	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>
	<37219a840808280825i4c867c03u3c2d48888f51dde4@mail.gmail.com>
	<48B6CDEB.2060305@glidos.net>
	<37219a840808280921g3e602acco6697c4f4af43ec74@mail.gmail.com>
	<48B6E525.7070306@glidos.net> <48B6EFE1.3040009@glidos.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Looks like there's a new unsupported WinTV Nova T
	500 out there
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

On Thu, Aug 28, 2008 at 2:35 PM, Paul Gardiner <lists@glidos.net> wrote:
> Paul Gardiner wrote:
>>
>> I'm going to try the card in a Windows machine. Didn't
>> want to pollute that machine with the extra drivers, but
>> I guess now it's looking like a dead card.
>
> Oh sorry. It's a dead card. The Latest drivers for Windows,
> from the Hauppauge web site agree with your drivers in
> finding no supported hardware.  The USB part is recognised
> but then a device called HOOK appears, and the Windows
> drivers just don't want to touch that.
>
> I think I was justifiably confused by the wiki. There's
> plenty about the Diversity version that isn't supported,


Diversity version *is* supported.  Silly wiki.  Anybody interested
should try my Bristol tree -- I'll have it merged within the week or
so.


> but nothing saying that there are any v2.1 versions that
> do work, or anything about the 99XXX series. I could
> try updating it, but that's a bit risky: if I had done
> so yesterday, I'd have been spreading my scaremongering
> further afield. Better if people really in the know do so.


Anybody can edit the wiki.  I choose to spend my time working on code
rather than the wiki.


> On the other hand, if the experts have little time and
> it's the choice between updating the drivers and the wiki,
> I know which I'd vote for! :-)

heh.. like I said, above.


> Anyway, thanks for all the friendly advice. I'll let you
> know how I get on with the replacement, when it arrives.

You can fix it yourself if you want.... or you can get a replacement
-- it's up to you.

Based on the information in your dmesg, I can see that the eeprom on
your device has gotten erased or corrupted.  Some informative links:

http://article.gmane.org/gmane.linux.drivers.dvb/36609

http://www.mail-archive.com/linux-dvb@linuxtv.org/msg26676.html

Anyway, for all the interested readers out there -- this was a false
alarm -- the card *is* supported, and it is *not* end-of-life.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
