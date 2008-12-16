Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LCS9v-0004gi-So
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 06:07:53 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1334549fga.25
	for <linux-dvb@linuxtv.org>; Mon, 15 Dec 2008 21:07:48 -0800 (PST)
Message-ID: <412bdbff0812152107r5e3ac546h2530f9b28d8c8f94@mail.gmail.com>
Date: Tue, 16 Dec 2008 00:07:48 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1229389488.3122.23.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <4728568367913277327@unknownmsgid>
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>
	<8829222570103551382@unknownmsgid>
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>
	<2944906433286851876@unknownmsgid>
	<412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>
	<1229389488.3122.23.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org, Daniel Perzynski <Daniel.Perzynski@aster.pl>
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

On Mon, Dec 15, 2008 at 8:04 PM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2008-12-15 at 18:27 -0500, Devin Heitmueller wrote:
>> On Mon, Dec 15, 2008 at 6:23 PM, Daniel Perzynski
>> <Daniel.Perzynski@aster.pl> wrote:
>
>> > Devin,
>> >
>> > The problem is that I'm in Poland and we don't have ATSC here as far as I'm
>> > aware but I will try to test it anyway.
>> > Could you please look at the wiki for that card and tell me what will be the
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

Ugh.  It looks like Andy is right - nobody appears to have ever gotten
around to doing analog support for the cxusb driver.  Worse, the
driver relies on the dvb_usb framework which doesn't have analog
support at all (this is why the Pinnacle 801e doesn't have analog
too).

Daniel - This is going to be a project - we're not talking adding just
another device profile.  Analog support is a huge piece of the
framework that this driver outright doesn't exist.  Someone would have
to add analog support to dvb_usb and then make it work with the cxusb
driver, and then add the appropriate device profile for the Avermedia
A312.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
