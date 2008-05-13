Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1Jw21q-0007ER-Tu
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 23:27:24 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out2.iol.cz (Postfix) with ESMTP id 5667F9595D
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 23:26:48 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Tue, 13 May 2008 23:26:45 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<1210701513l.6217l.1l@manu-laptop>
In-Reply-To: <1210701513l.6217l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805132326.45168.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : No lock possible at some DVB-S2 channels with
	TT S2-3200/linux
Reply-To: ajurik@quick.cz
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

On Tuesday 13 of May 2008, manu wrote:
> On 05/12/2008 02:42:43 PM, Ales Jurik wrote:
> > Hi,
> >
> > after Telenor switched from Thor-2 to Thor-5 (0.8W) no lock is
> > possible with
> > multiproto(-plus) and TT S2-3200 at these transponders:
> >
> > TV4
> > HD;Telenor:11341:vC34M5O35S1:S0.8W:25000:512:0;641=sve:0:B00:1405:70:42:0
> > CANAL+ FILM
> > HD;Telenor:11421:hC34M5O35S1:S0.8W:25000:513:644=eng;645=eng:0:B00:3306:7
> >0:14:0 Nat Geo
> > HD;Telenor:11434:vC34M5O35S1:S0.8W:25000:512:640=eng:0:B00:3806:70:38:0
> >
> > I'm 100% sure that this problem corresponds with switch from Thor-2
> > to
> > Thor-5
> > as it appeared exactly at times when switch was announced by Telenor.
> >
> > Regarding to official document
> > http://www.telenorsbc.com/upload/PDFS/DVB-S2%20Transponder%20FEC%
> > 20Change_280208.pdf
> >
> > two changes were implemented - FEC from 2/3 to 3/4 and switch off
> > Pilot.
> >
> > On the same HW under Windows it is running ok.
> >
> > If somebody could point me to any direction I'll glad to cooperate in
> > debugging.
>
> Perhaps you can try to increase the freq by 4Mhz, that's what I did
> here (DVB-S though) and I have a perfect picture since then.
> HTH
> Bye
> Manu
>
Hi,

thanks for your hint, but I've already tried it. Without result, but this time 
I've let it without action for long time at same channel - after 1 or 2 
minutes I've got sometimes SYNC, after 8 - 10 minutes LOCK, but unfortunately 
only as spikes - once and the driver was falling back to NOSIGNAL, so I'm 
still not able to receive any program.

Last week I've tried to play a little with the driver (changing gain, 
SearchRange and some other parameters) but without any reasonable result.

As i don't have documentation (datasheets) from used chips I'm not able to 
test it more. Could you be so kind and send me info where is possible to got 
it? Of course if it is not under NDA.

Thanks,

BR,

Ales

>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
