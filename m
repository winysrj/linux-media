Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L8g3A-00046k-9e
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 20:09:17 +0100
Received: by ug-out-1314.google.com with SMTP id x30so86869ugc.16
	for <linux-dvb@linuxtv.org>; Fri, 05 Dec 2008 11:09:12 -0800 (PST)
Date: Fri, 5 Dec 2008 20:08:53 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Uri Shkolnik <urishk@yahoo.com>
In-Reply-To: <911565.38943.qm@web38801.mail.mud.yahoo.com>
Message-ID: <alpine.DEB.2.00.0812051932360.9198@ybpnyubfg.ybpnyqbznva>
References: <911565.38943.qm@web38801.mail.mud.yahoo.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
 support
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

Hello Uri; sorry that I have waited so long to reply to this...

On Wed, 19 Nov 2008, Uri Shkolnik wrote:

> The first adds the SmsHost API support. This API supports DTV standards yet to be fully supported by the DVB-API (CMMB, T-DMB and more).

The patches have all applied cleanly, and built properly,
thank you.  (Or, at least, I had no problems.)

However, what I have is probably a complete-newbie question,
that I should be ashamed to ask, because I *should* know better.


Is there a particular Linux distribution for which the Siano 
source code is intended, and, exactly what should I expect to
see in /dev when I successfully load the module with my device?


I ask this because on my test system, /dev major number 251
appears to be used by `usbdev' -- I'm using ``udev'' on what
I think is a sort-of-recent Debian system; whether I've updated 
`udev' here I can't say without looking -- I know I updated
`udev' on an earlier Debian system if not the one I'm running now...


I see on the static /dev (before possible `udev') that I have
mounted from my earlier Debian, before I decided that trying
to keep up-to-date was best done by a fresh install -- that
/dev major 251 is unused there.

I've updated `udev' independent of the rest of the OS in
the past out of necessity, and while I have not been able
to kill off the part of my brane that haunts me with the
memory of glowing tubes/valves, I can no longer remember
any details of my `udev' hacking.

Of course, I can use module-load-parameters to specify a
different major number, but I don't see any anticipated
character devices getting created upon module load -- if
I need to physically disconnect and reconnect the device
for this, then my apologies, as I didn't get around to that.
Yet.


I am sure I'm either doing something stupid, or I've been
to lazy to fix `udev' for myself, but I'm asking this to
try to help me save a few hours re-learning everything I've
forgotten about devices...


Of course, if Sir Mkrufky@ already has a fix in the works
for this, then I'll just shut up for a short spell.


Thanks!
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
