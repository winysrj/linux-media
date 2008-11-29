Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thunder.m@email.cz>) id 1L6Qqk-0003ZR-LM
	for linux-dvb@linuxtv.org; Sat, 29 Nov 2008 15:31:12 +0100
Message-ID: <493151F9.2040904@email.cz>
Date: Sat, 29 Nov 2008 15:30:17 +0100
From: =?ISO-8859-2?Q?Mirek_Sluge=F2?= <thunder.m@email.cz>
MIME-Version: 1.0
To: Jonathan <jhhummel@bigpond.com>, linux-dvb@linuxtv.org
References: <4675AD3E.3090608@email.cz> <492FD9E8.9070600@email.cz>
	<200811292353.00677.jhhummel@bigpond.com>
In-Reply-To: <200811292353.00677.jhhummel@bigpond.com>
Subject: Re: [linux-dvb] Patch for Leadtek DTV1800H, DTV2000H (rev I, J),
 and (not working yet) DTV2000H Plus
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

Hi, you should connect internal cable from your TV card to your sound =

card, or use "arecord -D hw:1 -f dat 2>/dev/null | aplay -f dat 2>/dev/null"

Mirek

Jonathan napsal(a):
> On Fri, 28 Nov 2008 10:45:44 pm Mirek Sluge=F2 wrote:
>> Hi, all 3 patches are in one file, they depend on each other.
>>
>> All GPIOs spoted from Windows with original APs
>>
>> DTV1800H - there is patch pending in this thread from Miroslav Sustek,
>> this is only modification of his patch, difference should be only in
>> GPIOs (I think it is better to use GPIOs from Windows).
>>
>> DTV2000H (rev. I) - Only renamed from original old DTV2000H
>>
>> DTV2000H (rev. J) - Almost everything is working, I have problem only
>> with FM radio (no sound).
>>
>> DTV2000H Plus - added pci id, GPIOs, sadly Tuner is XC4000, so it is not
>> working yet.
>>
>> Mirek Slugen
> =

> =

> Hi Mirek,
> =

> Nice work with the patch!
> =

> I gave it a go and found that I still can't get sound for analogue TV and =

> radio.
> I have a DTV2000H rev J
> Tried:
>  - KdeTV
>  - TVtime
>  - Gnome radio
> =

> I'm in Australia with PAL format TV
> =

> Attached is the dmesg output
> =

> What ya think?
> =

> Jon
> =

> =

> ------------------------------------------------------------------------
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
