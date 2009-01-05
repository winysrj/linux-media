Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter@hoeg.com>) id 1LJfli-0006H2-NB
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 04:04:43 +0100
Received: by ti-out-0910.google.com with SMTP id w7so6025188tib.13
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 19:04:37 -0800 (PST)
Message-ID: <496178BF.2050302@hoeg.com>
Date: Mon, 05 Jan 2009 11:04:31 +0800
From: Peter Hoeg <peter@hoeg.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-dvb@linuxtv.org
References: <loom.20090103T043514-870@post.gmane.org>
	<200901031727.26569.hfvogt@gmx.net> <496056B4.4050603@hoeg.com>
	<200901042333.47704.hfvogt@gmx.net>
In-Reply-To: <200901042333.47704.hfvogt@gmx.net>
Subject: Re: [linux-dvb] HVR-1200,
	cx23885 driver and Message Signaled Interrupts
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

> cx23885 0000:03:00.0: setting latency timer to 64
> the confirmation that MSI is activated:
> cx23885 0000:03:00.0: irq 315 for MSI/MSI-X
> 
> It seems that for your card, the PCI code is stuck halfways?!
> As you have other devices running with MSI, can you please check whether you 
> see a line ... irq xyz for MSI/MSI-X for them?

I am not getting that message for any of the other devices. Here is the
output of: dmesg | grep -i msi

[    1.533883] pcieport-driver 0000:00:0b.0: found MSI capability
[    1.534197] pcieport-driver 0000:00:0c.0: found MSI capability
[    1.534501] pcieport-driver 0000:00:0d.0: found MSI capability
[    2.905219] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq lnktim
msi desc-v3

Maybe your message comes because you have some DEBUG_MSI_INTERRUPTS flag
set or something (purely guessing here) as my other devices using MSI
are working perfectly and this has to be looked for elsewhere.

Any other info I can provide that will shed some light on the situation?

/peter

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
