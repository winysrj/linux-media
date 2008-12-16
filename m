Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.aster.pl ([212.76.33.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Daniel.Perzynski@aster.pl>) id 1LCY7g-0007gf-NB
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 12:29:57 +0100
From: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>,
	"'Andy Walls'" <awalls@radix.net>
References: <4728568367913277327@unknownmsgid>	
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>	
	<8829222570103551382@unknownmsgid>	
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>	
	<2944906433286851876@unknownmsgid>	
	<412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>	
	<1229389488.3122.23.camel@palomino.walls.org>
	<412bdbff0812152107r5e3ac546h2530f9b28d8c8f94@mail.gmail.com>
In-Reply-To: <412bdbff0812152107r5e3ac546h2530f9b28d8c8f94@mail.gmail.com>
Date: Tue, 16 Dec 2008 12:29:08 +0100
Message-ID: <000001c95f71$82bfc980$883f5c80$@Perzynski@aster.pl>
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
Sent: Tuesday, December 16, 2008 6:08 AM
To: Andy Walls
Cc: Daniel Perzynski; linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia A312 - patch for review

On Mon, Dec 15, 2008 at 8:04 PM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2008-12-15 at 18:27 -0500, Devin Heitmueller wrote:
>> On Mon, Dec 15, 2008 at 6:23 PM, Daniel Perzynski
>> <Daniel.Perzynski@aster.pl> wrote:
>
>> > Devin,
>> >
>> > The problem is that I'm in Poland and we don't have ATSC here as far as
I'm
>> > aware but I will try to test it anyway.
>> > Could you please look at the wiki for that card and tell me what will
be the
>> > analog video decoder for that card (I don't have /dev/videoX device).
>>
>> Hmm....  It's a cx25843.  I would have to look at the code to see how
>> to hook that into the CY7C68013A bridge.  I'll take a look tonight
>> when I get home.
>
> The cxusb.[ch] files seem to devoid of analog support.  There's this
> comment which sums it up:
>
> * TODO: Use the cx25840-driver for the analogue part
>
>
> Although the linux/media/video/pvrusb2 driver appears to have at least
> two hybrid boards with a cx2584x and an FX2 (WinTV HVR-1900 and HVR-1950
> in pvrusb2_devattr.c).  Maybe that driver could help... (or maybe I
> haven't got a clue :] )
>
> Regards,
> Andy

> Ugh.  It looks like Andy is right - nobody appears to have ever gotten
> around to doing analog support for the cxusb driver.  Worse, the
> driver relies on the dvb_usb framework which doesn't have analog
> support at all (this is why the Pinnacle 801e doesn't have analog
> too).
>
> Daniel - This is going to be a project - we're not talking adding just
> another device profile.  Analog support is a huge piece of the
> framework that this driver outright doesn't exist.  Someone would have
> to add analog support to dvb_usb and then make it work with the cxusb
> driver, and then add the appropriate device profile for the Avermedia
> A312.
>
> Devin
>
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

Hmm, not good then :( How we can start that project? I have to tell you that
I'm not a programmer and I've added a312 support to cxusb based on the
similarities to Avermedia Volar.
There is a radio also in that card (I don't know which chipset is
responsible for that) + WM8739 for which the driver do exist (wm8739.c). I
can try to modify pvrusb2 but the question is if we shouldn't have one
"driver" to support both analog and digital TV + Radio on that card?
 
Daniel,



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
