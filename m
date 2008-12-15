Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LCMr5-00085O-8o
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 00:28:04 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1294640fga.25
	for <linux-dvb@linuxtv.org>; Mon, 15 Dec 2008 15:27:59 -0800 (PST)
Message-ID: <412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>
Date: Mon, 15 Dec 2008 18:27:59 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
In-Reply-To: <2944906433286851876@unknownmsgid>
MIME-Version: 1.0
Content-Disposition: inline
References: <4728568367913277327@unknownmsgid>
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>
	<8829222570103551382@unknownmsgid>
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>
	<2944906433286851876@unknownmsgid>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia A312 - patch for review
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

On Mon, Dec 15, 2008 at 6:23 PM, Daniel Perzynski
<Daniel.Perzynski@aster.pl> wrote:
>
>
> -----Original Message-----
> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com]
> Sent: Tuesday, December 16, 2008 12:12 AM
> To: Daniel Perzynski
> Cc: linux-dvb@linuxtv.org
> Subject: Re: Avermedia A312 - patch for review
>
> On Mon, Dec 15, 2008 at 6:08 PM, Daniel Perzynski
> <Daniel.Perzynski@aster.pl> wrote:
>>
>> -----Original Message-----
>> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com]
>> Sent: Monday, December 15, 2008 11:29 PM
>> To: Daniel Perzynski
>> Cc: linux-dvb@linuxtv.org
>> Subject: Re: Avermedia A312 - patch for review
>>
>> On Mon, Dec 15, 2008 at 5:25 PM, Daniel Perzynski
>> <Daniel.Perzynski@aster.pl> wrote:
>>> Hi,
>>>
>>>
>>>
>>> According to the suggestions I've modified dvb-usb-ids.h and cxusb.c to
>> add
>>> a support for that card.
>>>
>>>
>>>
>>> I would appreciate someone to look at the code below and compare it with
>>> spec on the wiki for that card.
>>>
>> <snip>
>>
>> Does this patch actually work?  Can you watch ATSC TV?
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>> Good question,
>>
>> How to check it? What about analog TV?
>>
>> Daniel
>
>> Well, the /dev/dvb/adapter0/* files are for the ATSC interface (using
>> the lgdt3303).  You would use tools like scan, azap, mplayer to test
>> digital support:
>
>> http://linuxtv.org/wiki/index.php/Testing_your_DVB_device
>>
>> I'm not sure which analog video decoder that device uses and I'm not
>> confident you have provided any configuration to specify the decoder.
>> Do you have a /dev/video0 device?
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>
> Devin,
>
> The problem is that I'm in Poland and we don't have ATSC here as far as I'm
> aware but I will try to test it anyway.
> Could you please look at the wiki for that card and tell me what will be the
> analog video decoder for that card (I don't have /dev/videoX device).

Hmm....  It's a cx25843.  I would have to look at the code to see how
to hook that into the CY7C68013A bridge.  I'll take a look tonight
when I get home.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
