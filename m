Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <primijos@gmail.com>) id 1K88jl-00022W-QZ
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 09:02:47 +0200
Received: by wa-out-1112.google.com with SMTP id n7so3881626wag.13
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 00:02:40 -0700 (PDT)
Message-ID: <aea1a9c0806160002w3812d75dpdb8fb9c948bc9b43@mail.gmail.com>
Date: Mon, 16 Jun 2008 09:02:40 +0200
From: "=?ISO-8859-1?Q?Jos=E9_Oliver_Segura?=" <primijos@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] using dvb stick IR receiver with recycled remote?
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

Hi all,

I've been taking a look at how IR receiver is managed (dib0700
receivers, file dib0700_devices.c), because I'm willing to recycle an
"old" DVD Remote in order to use it with mythtv; Actually, I was using
it with a home brew ir receiver based on an Arduino board which died
yesterday :-( The question is that, as far as I've seen, IR codes for
"known" remotes are hardcoded into dib0700_devices.c, so it looks that
are two options here:

a) Add this remote as a "known" device:
       - Do some research to get the list of codes for each of the
keys on this remote (looks doable, since these codes appear in dmesg
as "Unknown remote controller key : XX XX"
       - Add them to dib0700_devices, mapped to the most similar
linux/input.h KEY_xxx values
       - Google around to find how to map these events to Lirc->Mythtv

       This looks ok, but presents a problem which is obvius: I would
have to manually update the dib0700_devices.c for each upgrade of the
devices sources, that's why I'm asking
       about (b)

b) Add support inside dib0700_devices to manage "Unknown remote
controller key" events as -if configured- "customizable" events, in
order to make use of the IR receiver in those sticks with generic IR
controllers. I'm not sure about this option, but it looks like the
"cleanest", despite the fact that (a) can be done for me to work on my
system and (b) could result -potentially- in a benefit for everyone
willing to use a recycled remote with its dvb stick

What do you think about the different options? Specifically about (a)
-the one that I'll implement meanwhile-, do you think there's
something missing?

Best,
Jose

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
