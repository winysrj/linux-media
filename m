Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1Ks3PF-0006tX-91
	for linux-dvb@linuxtv.org; Tue, 21 Oct 2008 00:39:22 +0200
Received: from geppetto.reilabs.com (78.15.179.122) by relay-pt1.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48FBCA4D0000BB6B for linux-dvb@linuxtv.org;
	Tue, 21 Oct 2008 00:39:17 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1Ks3OD-0002OR-VM
	for linux-dvb@linuxtv.org; Tue, 21 Oct 2008 00:38:17 +0200
Date: Tue, 21 Oct 2008 00:38:17 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb@linuxtv.org
Message-ID: <20081020223817.GB5164@geppetto>
References: <48FCA270.8C56.0056.0@matc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48FCA270.8C56.0056.0@matc.edu>
Subject: Re: [linux-dvb] Unresolved symbols
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

On date Monday 2008-10-20 15:23:22 -0500, Jonathan Johnson wrote:
> Hello all,
> 
>    I have tried to use the drivers and have gotten everything to compile.
> I followed the posted instruction and then........
> I then make "rmmod" and make "insmod" and after the "make insmod" I look at dmesg|more
> It is filled with unresolved symbols.  I have tried rebooting (at nauseam) and no change.
> I have upgraded the kernel and done all the steps all over again with the same results.
> If someone wants to look at about 5 screen fulls of unresolved symbols I can post the relevant parts of dmesg.
> 
> IF any one has any suggestions I will try them and report the results.

You should check:

1) that you're compiling against the same linux headers of the linux
kernel you're using.

Use uname -a to get the linux kernel in use, and verify that the
headers used during compilation are the correct ones. On a
Debian/Ubuntu based system for each pre-compiled linux-image package there is
a corresponding linux-headers package, eventually install it.

2) that you don't have a conflict with some already installed
module. For example I experienced this when installing the v4l-dvb
modules which conflicted with the old standalone gspca module (gspca
V1). Since you can't have both installed you have either to remove the
old module and reinstall the v4l-dvb modules either to remove the
v4l-dvb modules and reinstall the old standalone module.

Unfortunately I think there isn't a make uninstall rule, so I think
the only solution to revert a system is to reinstall the kernel
(easily done with a package management).

HTH, regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
