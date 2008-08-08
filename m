Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78LTZ4J021055
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 17:29:35 -0400
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78LTNIr003994
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 17:29:23 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: id012c3076@blueyonder.co.uk
In-Reply-To: <489C984E.70300@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
	<1217457895.4433.52.camel@pc10.localdom.local>
	<48921FF9.8040504@blueyonder.co.uk>
	<1217542190.3272.106.camel@pc10.localdom.local>
	<48942E42.5040207@blueyonder.co.uk>
	<1217679767.3304.30.camel@pc10.localdom.local>
	<4895D741.1020906@blueyonder.co.uk>
	<1217798899.2676.148.camel@pc10.localdom.local>
	<4898C258.4040004@blueyonder.co.uk> <489A0B01.8020901@blueyonder.co.uk>
	<1218059636.4157.21.camel@pc10.localdom.local>
	<489B6E1B.301@blueyonder.co.uk>
	<1218153337.8481.30.camel@pc10.localdom.local>
	<489C984E.70300@blueyonder.co.uk>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 23:21:36 +0200
Message-Id: <1218230496.2865.2.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Ian,

Am Freitag, den 08.08.2008, 20:02 +0100 schrieb Ian Davidson:
> Hi Hermann,
> 
> I got errors in the 'make' (see below).  Presumably, there is something 
> else I need to install/download?
> 
> Ian
> 
> [Ian@localhost ~]$ cd v4l-dvb/
> [Ian@localhost v4l-dvb]$ make
> make -C /home/Ian/v4l-dvb/v4l
> make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
> No version yet, using 2.6.25.11-97.fc9.i686
> make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
> make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
> scripts/make_makefile.pl
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.25
> File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at 
> ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
> make[1]: Entering directory `/home/Ian/v4l-dvb/v4l'
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.25
> File not found: /lib/modules/2.6.25.11-97.fc9.i686/build/.config at 
> ./scripts/make_kconfig.pl line 32, <IN> line 4.
> make[1]: *** No rule to make target `.myconfig', needed by 
> `config-compat.h'.  Stop.
> make[1]: Leaving directory `/home/Ian/v4l-dvb/v4l'
> make: *** [all] Error 2
> [Ian@localhost v4l-dvb]$
> 

yes, you need at least the exported object tree to compile or configured
custom kernel source if not on a vanilla kernel.

Try "yum install kernel-devel".

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
