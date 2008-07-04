Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gomeisa.profiz.com ([62.142.120.210])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter.parkkali@iki.fi>) id 1KEqAD-0002GI-7b
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 20:37:46 +0200
Message-Id: <E227296F-463F-4506-94C8-944A7B579D9E@iki.fi>
From: Peter Parkkali <peter.parkkali@iki.fi>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <486E5BF3.4000501@iki.fi>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Fri, 4 Jul 2008 21:36:59 +0300
References: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>	<486CC15B.5050902@iki.fi>
	<76F87D66-2788-4A13-BE2E-E745AAB8B86C@iki.fi>
	<486E5BF3.4000501@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 driver fails on ubuntu 8.04 / alink dtu-m
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On 4.7.2008, at 20:20, Antti Palosaari wrote:

> Peter Parkkali wrote:
>>
>> I tried it, and it produces exactly the same kind of errors as  =

>> before.  However, this time VLC doesn't crash - it just keeps on  =

>> sending the  garbled stream out. (Could be a coincidence - the  =

>> receiving vlc did  eventually crash.)
>> I tried connecting it via a USB 2 adapter, and there it works 99%  =

>> of  the time :) although there are still some glitches in the  =

>> picture and  sound. Both vlc and kernel still print the same  =

>> messages when running,  but there are fewer,  about 10-20 lines  =

>> after running for ~10 min.
>> - peter
>
> Do you have any USB2.0 port to test?

Yep, that's what I meant in the previous mail - I tested it with both  =

USB 1.1 and 2.0 ports earlier today, and with USB 2.0, it works 99%.  =

But there are still some minor glitches in reception, as if the signal  =

was bad, but it's connected to a keskusantenni so I don't think that's  =

very probable..

I put the logs from testing w/ USB 2.0 here since the mailing list  =

seems to wrap long lines:
http://pastebin.com/m182d08b9
http://pastebin.com/m8164d17

> When I implemented PID-filter for USB1.1 I reached also similar  =

> problem, but that was only for broadcasting MUX A in Finland. With  =

> other muxes I tested it was OK. I don't know why. Can you ensure  =

> that problems are only when viewing MUX A programs?

I'm afraid I don't know how, or what it even means :-/ Do you know if  =

that's possible around Helsinki / p=E4=E4kaupunkiseutu?

The channels.conf I used today was produced with "scan /usr/share/doc/ =

dvb-utils/examples/scan/dvb-t/fi-Espoo" with the adapter connected to  =

HTV/Welho's cable network here (for some reason they transmit the DVB- =

T signal along with DVB-C, so it's possible to use terrestrial devices).

> Anyhow, USB2.0 port and without PID-filtering your device should  =

> work like a charm.

More stupid questions - should I disable PID filtering manually, or is  =

it something the driver does automatically when a USB 2.0 port is used?

I can do more testing in the "evening" once I get home, if needed.

Thanks for the help!

-p

-- =

Peter Parkkali
peter.parkkali@iki.fi




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
