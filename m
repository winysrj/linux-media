Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KP5K8-0001tl-MN
	for linux-dvb@linuxtv.org; Sat, 02 Aug 2008 02:50:21 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Muppet Man <muppetman4662@yahoo.com>
In-Reply-To: <595821.21214.qm@web34403.mail.mud.yahoo.com>
References: <595821.21214.qm@web34403.mail.mud.yahoo.com>
Date: Sat, 02 Aug 2008 02:43:16 +0200
Message-Id: <1217637796.2678.1.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Error message trying to compile v4l with Fedora 9
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

Hi,

Am Freitag, den 01.08.2008, 16:59 -0700 schrieb Muppet Man:
> Greetings all,
> I am attempting to compile the v4l-dvb drivers via the instructions on
> the website, but when I go into root to "make" I get this error.
> 
> [root@localhost ~]# cd /home/ed/v4l-dvb/
> [root@localhost v4l-dvb]# make
> make -C /home/ed/v4l-dvb/v4l 
> make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
> No version yet, using 2.6.25.11-97.fc9.i686
> make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
> make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
> scripts/make_makefile.pl
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.25
> File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config
> at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
> make[1]: Entering directory `/home/ed/v4l-dvb/v4l'
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.25
> File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config
> at ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: *** No rule to make target `.myconfig', needed by
> `config-compat.h'.  Stop.
> make[1]: Leaving directory `/home/ed/v4l-dvb/v4l'
> make: *** [all] Error 2
> 
> I have searched around trying to find any answers but I found nothing.
> Any help would be greatly appreciated.
> Thanks

eventually,

"yum install kernel-devel" ?

Cheers,
Hermann




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
