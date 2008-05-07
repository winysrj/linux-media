Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vivichrist@gmail.com>) id 1JthXk-0006ee-FH
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 13:11:20 +0200
Received: by wf-out-1314.google.com with SMTP id 27so222028wfd.17
	for <linux-dvb@linuxtv.org>; Wed, 07 May 2008 04:06:47 -0700 (PDT)
Message-ID: <48218BB1.7060802@gmail.com>
Date: Wed, 07 May 2008 23:00:01 +1200
From: vivian stewart <vivichrist@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1210154402.12369.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1210154402.12369.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Problems loading drivers in Ubuntu 8.04
Reply-To: vivichrist@gmail.com
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

I recommend trying deleting all duplicate modules that get installed via 
ubuntu-modules (/lib/modules/2.6."bla"/ubuntu/media) and do a 'depmod 
-a'. although with 2.6.24.17 kernel these don't appear to be installed.

viv.
> Date: Wed, 07 May 2008 10:39:14 +0200
> From: Dennis Schwan <dennis.schwan@leuchtturm-it.de>
> Subject: [linux-dvb] Problems loading drivers in Ubuntu 8.04
>
> Hi,
>
> i just installed the newest drivers via make, make install.
>
> But now loading the drivers fails with both of my cards (cx88 and budget):
>
>  modprobe budget
> WARNING: Error inserting budget_core 
> (/lib/modules/2.6.24-16-generic/kernel/drivers/media/dvb/ttpci/budget-core.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting budget 
> (/lib/modules/2.6.24-16-generic/kernel/drivers/media/dvb/ttpci/budget.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
>
> Any Idea?
>
> Regards Dennis
>   

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
