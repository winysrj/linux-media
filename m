Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep28-int.chello.at ([62.179.121.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1JvsNa-0007jx-A5
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 13:09:13 +0200
Message-ID: <482976B1.9010402@hispeed.ch>
Date: Tue, 13 May 2008 13:08:33 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: nick <boexli@gmx.net>
References: <200805122000.41764.boexli@gmx.net>
In-Reply-To: <200805122000.41764.boexli@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy PCI C  HDTV
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

On 12.05.2008 20:00, nick wrote:
> Hi - Has anybody successfully managed to watch HDTV using the Terratec Cinergy 
> PCI C card?  If is switch to a HD channel using Kaffeine nothing happens and 
> after a couple of minutes the program freezes and does not reponse anymore. 
> Any ideas what I might have done wrong? Thanks Nick

I'm no expert here, but as far as I can tell the hardware driver has
nothing to do with it. These budget cards always capture the whole
transport stream and use software demux to get the parts which are
requested, they don't care at all what type of data is in the stream
(and even if they'd have hardware demux, it's possible they could do it
but is not implemented, they still wouldn't care about the type of
data). If it doesn't work, it's likely kaffeine/libxine/ffmpeg's fault.
For the record, when I got the chance to play with this, it indeed
"kinda" worked, but it was so unstable it usually segfaulted within a
second or so - apparently libxine (1.12) didn't like the stream too
much. Or maybe it's because my cpu was too slow and it had to drop
frames that it crashed (which would be bad behaviour indeed...), though
I think there are still problems with some of the h.264 features HD
channels might use (like PAFF interlacing). Maybe you'd have more luck
with cvs libxine, YMMV.

Roland


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
