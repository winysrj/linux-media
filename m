Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.movial.fi ([62.236.91.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.noordsij@movial.fi>) id 1K35xQ-0003lx-IU
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 11:04:01 +0200
Received: from localhost (mailscanner.hel.movial.fi [172.17.81.9])
	by smtp.movial.fi (Postfix) with ESMTP id DEF21C8044
	for <linux-dvb@linuxtv.org>; Mon,  2 Jun 2008 12:03:26 +0300 (EEST)
Received: from smtp.movial.fi ([62.236.91.34])
	by localhost (mailscanner.hel.movial.fi [172.17.81.9]) (amavisd-new,
	port 10026) with ESMTP id YmLqTUiUQesX for <linux-dvb@linuxtv.org>;
	Mon,  2 Jun 2008 12:03:26 +0300 (EEST)
Received: from [127.0.0.1] (hellgapp.hel.movial.fi [172.17.83.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.movial.fi (Postfix) with ESMTP id 94208C809D
	for <linux-dvb@linuxtv.org>; Mon,  2 Jun 2008 12:03:26 +0300 (EEST)
Message-ID: <4843B75C.7090505@movial.fi>
Date: Mon, 02 Jun 2008 11:03:24 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Driver TerraTec Piranha functional,
	need some advice to finish up
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


Dear List,

I am finishing up the last stages of a new driver for the TerraTec
Piranha DVB-T adapter (Sanio SMS-100x chipset), and I have some general
questions some of the more experienced driver writers could perhaps
provide some advice on.

First of all, because of some odd USB interfacing (see my previous mail
about endpoints) I do not use the dvb-usb framework, but used the
ttusb-budget driver as my main example.

The device scans, tunes, filters PIDs etc correctly. With Kaffeine, one
can do all the usual watching-TV stuff. Some details such as reporting
signal quality are missing (so far).


* All TS data comes in from a bulk endpoint, and always in quantities of
exactly 21 TS packets (plus 8 byte header, so always exactly 3956 bytes,
never more, never less). Occasionally a command-response is received on
the same endpoint, about 12-60 bytes.

How many urbs should I have doing the reading ? Does having multiple
urbs help also for bulk transfers ? I allocate the memory with
pci_alloc_consistent, one large block of "how-many-urbs * 3965" bytes
and distribute this over the urbs.


* When receiving a TS packet (so in the urb completion irq handler) I
feed the TS data to dvb_dmx_swfilter(..). Is it OK to do that in the irq
handler? (i.e. from a performance point of view the rule is to do as
little as possbible in the completion function).


* Can usb urb read completion callbacks come back concurrently, i.e. do
I need to lock the call to dvb_dmx_swfilter(...) ?


* When loading the module, and plugging in the device, the module
becomes in-use and can not be unloaded until the device is unplugged. Is
it possible to change this, so that the module will "close" the device
and allow itself to be unloaded, event when the device is still plugged in ?


* When unplugging the device during playback, the tv app stops
(obviously), but the module gets stuck, i.e. can not be unloaded anymore
and may or may not be in some kind of sane state where replugging the
device will work. Can this be handled gracefully ?


* Some applications request the frontend status very often (many times
per second), to really ask the status from the device needs a round-trip
request. Is it common to cache the results and only ask the device for
an update occasionally, or is it normal to just ask every time ? (it
just logs a lot of debug messages so it looks like a lot, don't know if
it is really an issue)


* The only locking I am doing currently is in sending a request and
reading a response from the device (the whole routine, including the
completion wait at the read step). This is similar to the "semusb" lock
of the ttusb-budget driver. Where else should I be careful with locking ?


* Any common gotchas I should keep in mind? :-)

Thanks!

Dennis





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
