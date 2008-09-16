Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KffrB-0001fE-Io
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 21:05:03 +0200
Received: by ug-out-1314.google.com with SMTP id 39so399371ugf.16
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 12:04:58 -0700 (PDT)
Date: Tue, 16 Sep 2008 19:04:56 +0000 (UTC)
To: Benny Amorsen <benny+usenet@amorsen.dk>
In-Reply-To: <m31vzkujjk.fsf@ursa.amorsen.dk>
Message-ID: <alpine.NEB.2.00.0809161818250.4540@Arg.OFQ.QlaQAF.qx>
References: <48CD1F3E.6080900@linuxtv.org>
	<564277.58085.qm@web46102.mail.sp1.yahoo.com>
	<m31vzkujjk.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] OT: Dual/BSD Licensing (was: Re: Multiproto API/Driver
 Update)
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

On Tue, 16 Sep 2008, Benny Amorsen wrote:

> I doubt that *BSD would allow GPL'd .c-files into their kernel trees.

Ha.  Found one.  Present (NetBSD) OS does not give me access
to my up-to-date source repositories, so I don't know if it's
obsolete now, and I can't grep through DragonFly-, Open-,
and other derivates along the BSD family tree.

There are, however, numerous dual GPL/BSD license files to
be found, some with different wordings.

/mnt/usr/local/src/netbsd-current-src/src/NetBSD.cvs/src/sys/dev/pci/if_lmc.c
is an example of a file has plenty of Linuxisms intact.

/mnt/usr/local/src/netbsd-current-src/src/NetBSD.cvs/src/sys/external/bsd/drm/dist/shared-core/via_drv.c
has a BSD license atop, and at the end, a Linux kernel module
GPL license...

/altroot/STABLE-4.4-FreeBSD/usr/local/system/src/sys/kern/kern_random.c
is quite old -- while I do have later source on this disk,
my present kernel limits me to the 16 partitions I've defined
from the 30-odd I can find with Linux (experimental code to
use BSD disklabels or GPT has not been as successful as I
would like); this isn't relevant, is it?  Anyway...  I'll
quote from this file:

 * $FreeBSD: src/sys/kern/kern_random.c,v 1.36.2.4 2002/09/17 17:11:57 sam Exp $
 * Version 0.95, last modified 18-Oct-95
 * Copyright Theodore Ts'o, 1994, 1995.  All rights reserved.
[...]
 * ALTERNATIVELY, this product may be distributed under the terms of
 * the GNU Public License, in which case the provisions of the GPL are
 * required INSTEAD OF the above restrictions.  (This clause is
 * necessary due to a potential bad interaction between the GPL and
 * the restrictions contained in a BSD-style copyright.)

Now we take a look at an interesting file:
 * $FreeBSD: src/sys/dev/dgb/dgm.c,v 1.31.2.3 2001/10/07 09:02:25 brian Exp $
[...]
 * There was a copyright confusion: I thought that having read the
 * GLPed drivers makes me mentally contaminated but in fact it does
 * not. Since the Linux driver by Troy De Jongh <troyd@digibd.com> or
 * <troyd@skypoint.com> was used only to learn the Digi's interface,
 * I've returned this driver to a BSD-style license. I tried to contact
 * all the contributors and those who replied agreed with license
 * change. If you did any contribution when the driver was GPLed and do
 * not agree with the BSD-style re-licensing please contact me.
 *  -SB


``Mentally contaminated''.  Hmmm.  Need to design a suitable
icon for that, and print up biohazard-like warning signs to
wear on my jacket.  Anyway, that's an example of the sort of
flame wars that you can find elsewhere.


Now, a bit futher along, again from my old source tree,

/altroot/STABLE-4.4-FreeBSD/usr/local/system/src/sys/gnu/i386/isa/dgb.c

 *  dgb.c $FreeBSD: src/sys/gnu/i386/isa/dgb.c,v 1.56.2.1 2001/02/26 04:23:09 jlemon Exp $
 *
 *  Digiboard driver.
 *
 *  Stage 1. "Better than nothing".
 *  Stage 2. "Gee, it works!".
 *
 *  Based on sio driver by Bruce Evans and on Linux driver by Troy
 *  De Jongh <troyd@digibd.com> or <troyd@skypoint.com>
 *  which is under GNU General Public License version 2 so this driver
 *  is forced to be under GPL 2 too.

But then, this is under FreeBSD's sys/gnu subdirectory,
where optional non-BSD-licensed files would be found.


Of course, the actual basics of the kernel (memory manglement
and what not) will not be exclusively GPL -- only those
optional components for convenience.


I hope these licenses help any authors who are
considering whether a dual-license for their code
is worthy.  This is all based on `grep', not on an
intimate knowledge of how these source files interface
with the kernel.



> P.S. Interesting place you keep your sources...

Not enough mountpoints, too many external drives with
too many partitions, never enough consistency to add a
fixed mountpoint for anything that I might occasionally
mount, so I just mount it on whatever looks available,
then it kinda gets hardcoded differently into different
scripts on different OSen, and anyway, I usually end up
rearranging or migrating stuff sooner rather than later.


med venlig hilsen,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
