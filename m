Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Darron Broad <darron@kewl.org>
To: "Hans Werner" <HWerner4@gmx.de>
In-reply-to: <20080908000941.310670@gmx.net> 
References: <20080907230956.310620@gmx.net> <20080908000941.310670@gmx.net>
Date: Mon, 08 Sep 2008 15:51:10 +0100
Message-ID: <27703.1220885470@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 scratchpad patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <20080908000941.310670@gmx.net>, "Hans Werner" wrote:
>
>-------- Original-Nachricht --------
>> Datum: Mon, 08 Sep 2008 01:09:56 +0200
>> Von: "Hans Werner" <HWerner4@gmx.de>
>> An: linux-dvb@linuxtv.org, darron@kewl.org, stoth@linuxtv.org
>> Betreff: [linux-dvb] HVR4000 scratchpad patch
>
>> Does anyone know about the status of the HVR 4000 patch at
>> http://dev.kewl.org/hauppauge/scratchpad-8628.diff ?
>> According to the note from 18th Aug it's a test version for 2.6.26.
>> But it is 5x larger than previous patches so it looks like it was
>> diffed against the wrong revision. Has anyone rebased it?
>> 
>> Thanks,
>> Hans
>
>For example it's smaller when diffed against rev 227984e4b603 or rev fc018c7e7fe3,
>but still 2x as large as the earlier patches. Does anyone know the exact base?

Hi

Does it work as expected or do you have a problem?

The revision is 8628. The reason that you find this patch larger than
expected is because when I was supplied with some fixes from a fellow user
Carlo Scarfoglio the updates were against an older tree and when
added to a more recent tree it meant that a whole bunch of stuff which
had been added since his patch had to be reverted.

It's a bit messy but it ought to work and has been tested to work.

If you wish to provide a cleaner more up to date multi-frontend diff
then please go ahead, you are welcome.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
