Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from core.devicen.de ([62.159.186.206])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.lacher@abian.de>) id 1KAL49-0002mB-TH
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 10:36:57 +0200
Received: from [10.71.67.13] ([10.71.67.13])
	by core.devicen.de (8.13.1/8.13.1/DEVICE/N GmbH 20070903) with ESMTP id
	m5M8ZsGT011039
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 10:35:55 +0200
From: Lutz Lacher <l.lacher@abian.de>
To: linux-dvb@linuxtv.org
Date: Sun, 22 Jun 2008 10:35:49 +0200
References: <200806220300.51879.l.lacher@abian.de> <485DB191.9090907@to-st.de>
In-Reply-To: <485DB191.9090907@to-st.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221035.50028.l.lacher@abian.de>
Subject: Re: [linux-dvb] dvb_usb_dib0700 and Remote Control DSR-0112
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

Hi Tobias,

> So, sticks IR receiver is reported as /class/input/input21 and you are
> trying to use irrecord on /dev/input/event9? Does not fit together, you
> should try irrecord on /dev/input/input21 instead! (just my personal
> opinion ;)
>
i don't have an /dev/input/input21, and if i understood the web page 
correctly, it's always the same device. It says:

But Linux systems runing recent udev will automatically create non-varying 
names, a nicer and automatic way of providing a stable input event name:

ls -l /dev/input/by-path on my system
lrwxrwxrwx 1 root root 9 2008-06-22 09:56 pci-2-1--event-ir -> ../event9

which disappears if i plug out the stick and reappears if i plug it in again.
eg. now it's reported as:
kernel: input: IR-receiver inside an USB DVB receiver as /class/input/input11

Best regards, Lutz



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
