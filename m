Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 13 Jan 2009 18:55:24 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Uri Shkolnik <urishk@yahoo.com>
In-Reply-To: <802888.40255.qm@web110808.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.0901131803550.12827@ybpnyubfg.ybpnyqbznva>
References: <802888.40255.qm@web110808.mail.gq1.yahoo.com>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, linuxtv-commits@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Siano (SMS) DTV driver [WAS: Re:
 Introduction]
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

(Leaving the original recipient list intact, although I'm not
sure if I need to send to `linuxtv-commits@' as I don't keep
up-to-date with much of anything...)

On Tue, 13 Jan 2009, Uri Shkolnik wrote:

> [Uri S.] I'm attaching to this email an archive of patches.

Hello Uri, and first let me thank you for making available the
Siano Mobile Host-lib, as the header files included have answered
most of the questions I had about using Siano devices in 
non-DVB-T applications.

This does not mean that I've yet received and decoded any such
signals, as Real Life[tm] has gotten in the way, but at least it
has saved me from asking you stupid questions which were answered
in the header file  :-)


But, back to the real subject of this mail:

The patches you've supplied set a particular device major ID
from the `available' range, that unfortunately has already been
made use of by other services on a recent (sort-of) machine I'm
using.

I've already noted this in mail to the dvb@ mailing list, but it
probably doesn't hurt to repeat this...  Or maybe it does

Anyway, here's a cut-n-paste or copy-n-paste or whatever is 
correct, from the patches you sent in the mail I'm replying to...

+/*!  Holds the major number of the device node. may be changed at load
+time.*/
+int smschar_major = 251;


The problem is that there is no guarantee that on a 
full-functional Linux system, this major number is actually
free.  For me, it wasn't.

I would imagine that changing this will adversely affect any
embedded-product vendors, or the like, who today can happily
use this major number...


Anyway, thanks to the library you provided me and associated
files, I see there's a simple script that creates the devices,
which presumably the SMS library accesses by name, not number,
and this can be hacked in my case to match reality.


However, I'm not sure if this can be a solution in the general
case.  Given the scarcity of major numbers, I can't expect there
to be a major dedicated to these devices, but I wouldn't be
surprised if someone could come up with some magic to make use
of a DVB major number for alternative non-DVB-T access to these
products.  (This probably would require making public the ten-
or-so lines of the script that creates the alternative access
dev thingies, which shouldn't violate your IP much)


That might break plug-in compatibility with devices which today
depend on major 251 being free, but such is life, eh?



Sorry for any typos or errors in grammar or logic, I'm typing
this in total darkness in an unheated room, and the amount of
not-freebeer I've consumed to try to keep warm has probably
somehow affected my ability to ``think'' as it were.  Maybe.
Plus I can't see the keyboard...


cheers*hic*prost*hic*skaal*hic*nazdravie*hic*
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
