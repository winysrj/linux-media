Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYLOu-0001W3-P1
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 15:49:33 +0200
Received: by ey-out-2122.google.com with SMTP id 25so502807eya.17
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 06:49:29 -0700 (PDT)
Message-ID: <412bdbff0808270649t69b07207x92bb9754396ab800@mail.gmail.com>
Date: Wed, 27 Aug 2008 09:49:29 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-Reply-To: <617be8890808270212m192b2951x4d5e8313cd788557@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
	<alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
	<617be8890808270212m192b2951x4d5e8313cd788557@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 new i2c implementation
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

Hello Eduard,

2008/8/27 Eduard Huguet <eduardhc@gmail.com>:
> Well, regarding the Nova-T 500 I must say that, using the current HG driver
> code and 1.10 firmware, it's pretty rock solid. I've had no USB disconnects
> nor hangs of any time since a long time ago (since lastest patches for this
> card were merged).
>
> That's the reason I'm very reluctant to use the new firmware, specially if
> the effect seems to be a constantly rebooting machine, as Nicolas Will
> described ;-). However, if the above patche solves the problems then I'll be
> very pleased to test it.

It seems that Nicholas's problems had to do with having random copies
of 1.10 in /lib/firmware.

This is about more than "does it fix my problem".  The patch I am
submitting could cause potential breakage with other devices, so I
need people who have a stable environment to test the change and make
sure it doesn't cause breakage.

Otherwise, it just gets pushed in, you do an "hg update" and all of a
sudden your environment is broken.

The patch is known to fix several problems required to get the xc5000
working with the dib0700, but I want to be sure people with a working
environment don't start seeing problems.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
