Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1Jd1pi-0000rG-LM
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 12:24:19 +0100
Received: by an-out-0708.google.com with SMTP id d18so652730and.125
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 04:24:05 -0700 (PDT)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <1206139910.12138.34.camel@youkaida>
References: <1206139910.12138.34.camel@youkaida>
Date: Sat, 22 Mar 2008 12:24:11 +0100
Message-Id: <1206185051.22131.5.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-T-500 disconnects - They are back!
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


Il giorno ven, 21/03/2008 alle 22.51 +0000, Nicolas Will ha scritto:
> Guys,
> 
> I have upgraded my system to the new Ubuntu (8.04 Hardy), using 2.6.24,
> 64-bit.
> 
> And the disconnects are back.
> 
> I was using a rather ancient v4l-dvb tree, so I grabbed a new one, and
> saw no improvement.
> 
> It may be very well linked to the remote, I was recording anything when
> this one struck, just using the remote.

Hi Nico, did you apply my patch? If so could you please try it with a
clean unpatched tree? I'd like to know if this is someway related to my
patch or to dib0700_rc_setup calls.
BTW, I'm evaluating too an early switch from gusty to hardy, did you
experienced any problem? Is it usable? I've heard something about libc6
failures.. has it been fixed?
Thanks

Filippo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
