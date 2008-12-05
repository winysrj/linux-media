Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web110805.mail.gq1.yahoo.com ([67.195.13.228])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1L8hAv-0007br-Tu
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 21:21:22 +0100
Date: Fri, 5 Dec 2008 12:20:46 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Cc: linux-dvb@linuxtv.org
In-Reply-To: <alpine.DEB.2.00.0812051932360.9198@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Message-ID: <399384.53896.qm@web110805.mail.gq1.yahoo.com>
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
	support
Reply-To: urishk@yahoo.com
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



--- On Fri, 12/5/08, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost support
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: linux-dvb@linuxtv.org
> Date: Friday, December 5, 2008, 9:08 PM
> Hello Uri; sorry that I have waited so long to reply to
> this...
>
> On Wed, 19 Nov 2008, Uri Shkolnik wrote:
>
> > The first adds the SmsHost API support. This API
> supports DTV standards yet to be fully supported by the
> DVB-API (CMMB, T-DMB and more).
>
> The patches have all applied cleanly, and built properly,
> thank you.  (Or, at least, I had no problems.)
>

Cool. 10x.

> However, what I have is probably a complete-newbie
> question,
> that I should be ashamed to ask, because I *should* know
> better.
>
>
> Is there a particular Linux distribution for which the
> Siano
> source code is intended, and, exactly what should I expect
> to
> see in /dev when I successfully load the module with my
> device?
>

Siano currently has dozens++ of customers using various flavors of Linux. Desktop systems (multiple distributions), embedded Linux (many types and targets) and some Linux derivative systems.

Some use Linux DVB v3 API, most don't (either their system are too small, and the kernel and user space are tailored to the specific target/product, or the DTV standards is unsupported by the DVB sub-system (CMMB, T-DMB and more)).

The Siano (mini/tini) sub-system comes to answer that need.

But....

In order to use the Siano sub-system you need to have C library in user space, and a compatible player (with most DTV standards, just DVB-H can be used with any RTP enabled multimedia player with the proper CODECs).

This C library is supplied usually only to commercial customer because that in many cases it evolve to a direct support given by Siano, simply because there is no other support resource... (as always, every rule has its own exceptions). Andrea Venturi asked this library about 10 days ago, and this request went up to Siano's VP of marketing....(still pending)

Siano is committed to support the LinuxTV community. But to support individual end-users its quite an overstretch... 

Anyway, dev node 251 is defined as "experimental/test" node, and is used by Siano for communication between the kernel's sub-system and the user space library and multimedia player (e.g. both control and data paths).


>
> I ask this because on my test system, /dev major number 251
> appears to be used by `usbdev' -- I'm using
> ``udev'' on what
> I think is a sort-of-recent Debian system; whether I've
> updated
> `udev' here I can't say without looking -- I know I
> updated
> `udev' on an earlier Debian system if not the one
> I'm running now...
>
>
> I see on the static /dev (before possible `udev') that
> I have
> mounted from my earlier Debian, before I decided that
> trying
> to keep up-to-date was best done by a fresh install -- that
> /dev major 251 is unused there.
>
> I've updated `udev' independent of the rest of the
> OS in
> the past out of necessity, and while I have not been able
> to kill off the part of my brane that haunts me with the
> memory of glowing tubes/valves, I can no longer remember
> any details of my `udev' hacking.
>
> Of course, I can use module-load-parameters to specify a
> different major number, but I don't see any anticipated
> character devices getting created upon module load -- if
> I need to physically disconnect and reconnect the device
> for this, then my apologies, as I didn't get around to
> that.
> Yet.
>
>
> I am sure I'm either doing something stupid, or
> I've been
> to lazy to fix `udev' for myself, but I'm asking
> this to
> try to help me save a few hours re-learning everything
> I've
> forgotten about devices...
>
>
> Of course, if Sir Mkrufky@ already has a fix in the works
> for this, then I'll just shut up for a short spell.
>

"Sir Mkrufky" ?
I like that... I'll ask Mike if I'm too have the privilege to refer him with that title....


>
> Thanks!
> barry bouwsma

Welcome...
Uri


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
