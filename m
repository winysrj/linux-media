Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@guz.org.uk>) id 1MHHw5-0008PD-1A
	for linux-dvb@linuxtv.org; Thu, 18 Jun 2009 15:45:49 +0200
Received: by ey-out-2122.google.com with SMTP id d26so114251eyd.17
	for <linux-dvb@linuxtv.org>; Thu, 18 Jun 2009 06:45:45 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Jun 2009 15:45:45 +0200
Message-ID: <519c90150906180645s7be0a5aeo7772c012da50c162@mail.gmail.com>
From: Mark Guz <mark@markguz.nl>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems switching between LO bands with NOVA-S2
Reply-To: linux-media@vger.kernel.org
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

Hi there,

I have a Hauppauge Nova-S2 connected to a dish with a universal LNB
pointing at ASTRA 28.2e (i don't know the make/model of the LNB as I
inherited it from the previous tennant and it's way to hi up for me to
look)
When I connect this to my CentOS 5.3 (2.6.18-1.10.127 server running a
recent v4l-dvb build (this has been consistent over various nightly
builds stretching back to 1 year ago) and try and tune to any channels
on the loband  i cannot get a lock.
This works fine with the standard sky digi box but if i try szap or
scan i can not lock. But if I try to tune any hiband channels i get
lock no problem.

 However if i use dvbtune-0.5: ./dvbtune -tone 0 -c 2 -p H -s 22000 -f
10803000 -m
I get a lock no problem, and then i can use scan -c to pull a list of
channels. No other apps with dvb-s support seem to be able to lock
into the loband only dvbtune.

I've debugged this till I'm blue in the face. I can switch H/V
polarity no problems but just can't switch between loband and hiband.
This is a major problem as most of Freesat (UK) is on the loband
transponders.

>From what I've read switching between loband and hiband is something
to do with a 22khz tone but i don't see any option on scan or szap to
switch 22khz tones on or off.

I've tried the NOVA-S card and the HVR-3000 card and they both behave the same.

So can anyone suggest why the v4l-dvb tools don't lock onto the loband
but dvbtune can? what is the difference ? Is there somewhere i can
hack something? (not really a programmer but not afraid to fiddle with
variable values if necessary)

I'm just totally frustrated with this.

I hope someone could advise me here, or point me to some more info
that would help? I've googled till my head nearly exploded......

Thanks in advance...

Mark Guz

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
