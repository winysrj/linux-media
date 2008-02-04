Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from faunus.aptilo.com ([62.181.224.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JM6QH-0005qf-1j
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 19:52:05 +0100
Received: from [192.168.1.8] (h-134-69.A157.cust.bahnhof.se [81.170.134.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by faunus.aptilo.com (Postfix) with ESMTP id 2AD971F9063
	for <linux-dvb@linuxtv.org>; Mon,  4 Feb 2008 19:51:33 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb@linuxtv.org
In-Reply-To: <1202149689.6981.10.camel@anden.nu>
References: <BC723861-F3E2-4B1C-BA54-D74B8960579A@firshman.co.uk>
	<47A38A25.2030804@firshman.co.uk> <1201902231.935.12.camel@youkaida>
	<200802021020.20298.shaun@saintsi.co.uk>
	<1202031541.17762.23.camel@anden.nu>
	<1202149689.6981.10.camel@anden.nu>
Date: Mon, 04 Feb 2008 19:51:22 +0100
Message-Id: <1202151082.9955.1.camel@anden.nu>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Nova-T 500 issues - losing one tuner
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hmm... typical, isn't it? Just about ten minutes after I've sent out the
patch, the second tuner died again. It appears this is *not* enough to
fix the issue. Please discard the previous mail.

  // J

On Mon, 2008-02-04 at 19:28 +0100, Jonas Anden wrote:
> Hi all, 
> 
> > I have a hunch about this problem...
> ...
> > This, ... leads me to believe that this is timer-induced. Something
> > can't keep up. Adding debugging makes the operations slightly slower
> > (the module needs to do additional IO to speak to syslogd), and this
> > delay seems to be enough to keep it operational.
> 
> Attached is an extremely simple patch which seems to resolve the issue
> for me. Before turning streaming on/off, I have inserted a tiny delay or
> 10 ms-
> 
> Just using 'debug=1' wasn't enough to keep tuner 2 from dying. I set it
> up yesterday morning with debug=1, and when I got back home in the
> evening the second tuner was dead again. I then made the attached patch
> and the system has been stable since then (~24 hrs).
> 
> I also made a slight change by removing a "| 0x00" from the code. It
> performs absolutely nothing (and is probably removed by the compiler in
> optimization) but confuse when reading the code, imho... Patrick, if you
> really want it there I can recreate the patch with the or statement
> back ;)
> 
> Feel free to try it out.
> 
>   // J
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
