Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from alsikeapila.uta.fi ([153.1.1.44])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pauli@borodulin.fi>) id 1JyASh-0005ZL-6c
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 20:51:56 +0200
Message-ID: <4831CC3F.803@borodulin.fi>
Date: Mon, 19 May 2008 21:51:43 +0300
From: Pauli Borodulin <pauli@borodulin.fi>
MIME-Version: 1.0
To: Roland Scheidegger <sroland@tungstengraphics.com>
References: <482E114E.1000609@borodulin.fi>	<d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>
	<4831B058.1030107@borodulin.fi>
	<4831B70D.8050809@tungstengraphics.com>
In-Reply-To: <4831B70D.8050809@tungstengraphics.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated Mantis VP-2033 remote control patch for
 Manu's jusst.de Mantis branch
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

Heya!

Roland Scheidegger wrote:
 > [...]
> No offense, but I like my patch much better :-) [1]. I fail to see why
> polling has to be done - just for half-working (at best on some cards,
> not at all if the native repeat rate is too low) "improved" auto-repeat.

Ah, sorry. My bad, I missed your patch. It surely looks better.

What comes to auto-repeat... With your version of the patch it works 
equally well/badly on 2033 as it did with the earlier version.

> I was under the impression that using cancel_rearming_delayed_work
> instead of cancel_delayed_work (as I did in my patch) would make it
> unnecessary to call flush_scheduled_work (but I just followed some other
> drivers and could be easily wrong).

After reading some kernel source code, I agree that 
cancel_rearming_delayed_work is better suited.

 > [...]

Regards,
Pauli Borodulin <pauli@borodulin.fi>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
