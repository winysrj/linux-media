Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <knowledgejunkie@gmail.com>) id 1Jk5Gc-0002wl-S1
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 00:29:16 +0200
Received: by yw-out-2324.google.com with SMTP id 5so76345ywh.41
	for <linux-dvb@linuxtv.org>; Thu, 10 Apr 2008 15:29:09 -0700 (PDT)
Message-ID: <5387cd30804101529o279d83j968b75bc9a145117@mail.gmail.com>
Date: Thu, 10 Apr 2008 23:29:09 +0100
From: "Nick Morrott" <knowledgejunkie@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <5b5250670804100626p223df572r1c99e89b7d4da576@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <5b5250670804100626p223df572r1c99e89b7d4da576@mail.gmail.com>
Subject: Re: [linux-dvb] Trouble in loading drivers for both wintv
	nova-s-plus and pvr-500 card simultaneously (mainly becos of
	tveeprom.ko module)
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

On 10/04/2008, thirunavukarasu selvam <gs.thiru@gmail.com> wrote:
> Hi all,
>
> I am working with WinTV NOVA-S-Plus card and WinTV PVR-500 card in RHEL 4.4
> machine.
> I am using kernel 2.6.12.
> For WinTV NOVA-S-plus card i have used v4l-dvb drivers.
> For PVR-500 card i have used ivtv-0.4.9 drivers.
>  After compiling and installing these two drivers, i tried the following
> steps to load the drivers.
>
> 1. for NOVA-S-Plus card
> modprobe tveeprom
> modprobe cx24123
> modprobe cx8800
> modprobe cx8802
> modprobe cx88xx
>  modprobe cx88-dvb

You only need to 'modprobe cx88-dvb' - modprobe will automatically
load any other required modules.

>
> 2. for PVR-500 card
> depmod -a
> modprobe tveeprom
> modprobe ivtv

Again, you only need to 'modprobe ivtv'

> U can see the tveeprom is loaded twice. becos both the drivers has its own
> tveeprom

Newer versions of ivtv do not have the same limitation.

<cut>

> From the result what i understood is both drivers have a module called
> tveeprom.ko and that's where the problem starts.

Yes, this was a problem a few years ago

>
> so please tell the solution for both the cards to work simultaneously.

You could try temporarily removing the kernel tveeprom file and
replacing it with that supplied with ivtv to work with both cx88-dvb
and ivtv. The ivtv 0.4.x tveeprom module was an adapted version of
that supplied with older kernels. Now that ivtv is in the kernel,
there are no such issues (See
http://ivtvdriver.org/index.php/Howto_legacy_ivtv).

Another way that was used in years past was to rename the ivtv files
and then alias the renamed ivtv-provided modules to names like
tveeprom-ivtv and tuner-ivtv in modprobe.conf. You could Google for
this - there are plenty of results.

If you have some degree of flexibility, you could upgrade your kernel
or distro - RHEL/CentOS5 to at least kernel 2.6.18. In my experience
you can expect to hit issues such as this using old kernels and
modules for video-capture, especially when some old versions of
modules contain forked versions of in-kernel modules.

Nick

-- 
Nick Morrott

MythTV Official wiki:
http://mythtv.org/wiki/
MythTV users list archive:
http://www.gossamer-threads.com/lists/mythtv/users

"An investment in knowledge always pays the best interest." - Benjamin Franklin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
