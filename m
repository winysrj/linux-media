Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.aster.pl ([212.76.33.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Daniel.Perzynski@aster.pl>) id 1LCMmv-0007PW-BT
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 00:23:45 +0100
From: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <4728568367913277327@unknownmsgid>	
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>	
	<8829222570103551382@unknownmsgid>
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>
In-Reply-To: <412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>
Date: Tue, 16 Dec 2008 00:23:28 +0100
Message-ID: <000f01c95f0c$22fbe6b0$68f3b410$@Perzynski@aster.pl>
MIME-Version: 1.0
Content-Language: en-us
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



-----Original Message-----
From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com] 
Sent: Tuesday, December 16, 2008 12:12 AM
To: Daniel Perzynski
Cc: linux-dvb@linuxtv.org
Subject: Re: Avermedia A312 - patch for review

On Mon, Dec 15, 2008 at 6:08 PM, Daniel Perzynski
<Daniel.Perzynski@aster.pl> wrote:
>
> -----Original Message-----
> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com]
> Sent: Monday, December 15, 2008 11:29 PM
> To: Daniel Perzynski
> Cc: linux-dvb@linuxtv.org
> Subject: Re: Avermedia A312 - patch for review
>
> On Mon, Dec 15, 2008 at 5:25 PM, Daniel Perzynski
> <Daniel.Perzynski@aster.pl> wrote:
>> Hi,
>>
>>
>>
>> According to the suggestions I've modified dvb-usb-ids.h and cxusb.c to
> add
>> a support for that card.
>>
>>
>>
>> I would appreciate someone to look at the code below and compare it with
>> spec on the wiki for that card.
>>
> <snip>
>
> Does this patch actually work?  Can you watch ATSC TV?
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>
> Good question,
>
> How to check it? What about analog TV?
>
> Daniel

> Well, the /dev/dvb/adapter0/* files are for the ATSC interface (using
> the lgdt3303).  You would use tools like scan, azap, mplayer to test
> digital support:

> http://linuxtv.org/wiki/index.php/Testing_your_DVB_device
>
> I'm not sure which analog video decoder that device uses and I'm not
> confident you have provided any configuration to specify the decoder.
> Do you have a /dev/video0 device?
>
> Devin
>
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

Devin,

The problem is that I'm in Poland and we don't have ATSC here as far as I'm
aware but I will try to test it anyway.
Could you please look at the wiki for that card and tell me what will be the
analog video decoder for that card (I don't have /dev/videoX device).

Regards,



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
