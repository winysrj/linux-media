Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48B64690.4060205@glidos.net>
Date: Thu, 28 Aug 2008 07:32:48 +0100
From: Paul Gardiner <lists@glidos.net>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>
In-Reply-To: <48B6083B.5000803@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Looks like there's a new unsupported WinTV Nova T
 500	out there
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
> Paul Gardiner wrote:
>> Just trying to get MythTV up and running, plugged in my
>> newly arrived WinTV Nova T 500 and no /dev/dvb directory
>> appeared. It's not the known probelmatic Diversity version,
>> but it does say v2.1 on the box, and it seems to have
>> different chips. :-(
>>
>> Just thought I'd warn people and maybe ask if anyone
>> else has run into this.
> 
> What is the 5-digit model number of your PCI card?

Says 99101 LF
      Rev D8B5

Also on the circuit board: 990000-03A LF

It has 2 x 3000P-2122a-G / 6121030-A / 0636-200-A
        1 x 0700C-XCXXa-G / USB2.0 / D2F9Y.7 / 0635-0100-C
        1 x VT6212L / 0617CD

> Did you confirm that it doesn't work in the v4l-dvb master repository?

Do you mean build from the leading edge? No, didn't try that.

> If that's the case, give me a few days and I'll push in a patch for it.

Brilliant, thanks, but how is that possible? I can imagine it's not a
huge change to make a new ID recognised, but with the chips being
different, isn't a huge complicated change? Or are these different
variants of the same chip?

Cheers,
	Paul.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
