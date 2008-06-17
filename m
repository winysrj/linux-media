Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K8iXv-0007rQ-DR
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 23:16:56 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Tue, 17 Jun 2008 23:16:21 +0200
References: <1a18e9e80806171353x49b36059h17dcfb40f6bfe7b0@mail.gmail.com>
In-Reply-To: <1a18e9e80806171353x49b36059h17dcfb40f6bfe7b0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806172316.22039.ajurik@quick.cz>
Subject: Re: [linux-dvb] TT 3200 locking on 8PSK channels fail
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

On Tuesday 17 of June 2008, Meysam Hariri wrote:
> After successfull compilation of multiproto drivers and dvb-utils with
> patched szap on linux kernel 2.6.25.7, locking works great on dvb-s2
> channels with QPSK modulation but no chance on 8PSK. the patched szap and
> the unpached version also lock on dvb-s channels but i need to run szap
> multiple times until i get lock.on an 8PSK channel with FEC 9/10 locking
> fails totally and i could never get lock. any suggestions?
>
> Regards,

Hi, 

your problem seems to correspond with problem in this thread: 
http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026020.html.

But I'm able to get without problem lock on some channels DVB-S2, 8PSK and 
FEC2/3 (SkyItalia from 13.0E) but not on channels with higher FEC.

I've tried only on FEC 3/4 - which channels with FEC 9/10 did you tested?

Regards,

Ales



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
