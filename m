Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48B6ADB3.5010003@glidos.net>
Date: Thu, 28 Aug 2008 14:52:51 +0100
From: Paul Gardiner <lists@glidos.net>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>	
	<48B64690.4060205@glidos.net>
	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>
In-Reply-To: <37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>
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

Michael Krufky wrote:
> On Thu, Aug 28, 2008 at 2:32 AM, Paul Gardiner <lists@glidos.net> wrote:
>> Michael Krufky wrote:
>>> Paul Gardiner wrote:
>>>> Just trying to get MythTV up and running, plugged in my
>>>> newly arrived WinTV Nova T 500 and no /dev/dvb directory
>>>> appeared. It's not the known probelmatic Diversity version,
>>>> but it does say v2.1 on the box, and it seems to have
>>>> different chips. :-(
>>>>
>>>> Just thought I'd warn people and maybe ask if anyone
>>>> else has run into this.
>>> What is the 5-digit model number of your PCI card?
>> Says 99101 LF
>>     Rev D8B5
>>
>> Also on the circuit board: 990000-03A LF
>>
>> It has 2 x 3000P-2122a-G / 6121030-A / 0636-200-A
>>       1 x 0700C-XCXXa-G / USB2.0 / D2F9Y.7 / 0635-0100-C
>>       1 x VT6212L / 0617CD
> 
> 
> Based on the info above, it looks like you have a board that actually
> *is* supported in the mercurial repository.

Great I hope that's right.

>>> Did you confirm that it doesn't work in the v4l-dvb master repository?
>> Do you mean build from the leading edge? No, didn't try that.

Sorry, I'm being daft. I think that may have been exactly what I did. (I
was thinking there might be separate stable and beta releases or 
something when I replied before)
I did:

   hg clone http://linuxtv.org/hg/v41-dvb
   cd v41-dvb
   make
   su
   make install


I overlooked

   make load

but I've just repeated the process and remembered this time, and I
still have no /dev/dvb directory. dvb_usb_dib0700 doesn't load
automatically at boot. I can modprobe it, but still no /dev/dvb
directory.

> Please test the linuxtv.org v4l-dvb master development repository and
> confirm -- if it is still not recognized, then let me know.
> 
> 
>>> If that's the case, give me a few days and I'll push in a patch for it.
>> Brilliant, thanks, but how is that possible? I can imagine it's not a
>> huge change to make a new ID recognised, but with the chips being
>> different, isn't a huge complicated change? Or are these different
>> variants of the same chip?
> 
> It might be no change at all.  I'd look it up in the code, but I don't
> even know what the usb ID's of your device are, offhand -- what are
> they?  (do "lsusb -n | grep 2040" )

I get no output from that.

> You should really try the development repository before you go off
> telling other people that the card isnt supported.

Sorry, new to all this

> If it turns out, in fact, that your card isn't supported, then we'll
> be able to take care of that quickly.

Wow! I'm surprised you can be that certain. I don't want to keep hold
of the card too long in case I miss the deadline for returning it, but
I'll certainly keep hold of it while you think support is likely (would
be rude to accept your help and then not even be in a position to test).

Thanks very much for the help.

Cheers,
	Paul.

P.S. This could be some unrelated problem, like could my motherboard 
support only PCI2.1?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
