Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jim.kannampuzha@googlemail.com>) id 1L2XVM-0007eI-Q5
	for linux-dvb@linuxtv.org; Tue, 18 Nov 2008 21:49:01 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1656117nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 18 Nov 2008 12:48:56 -0800 (PST)
Message-ID: <387733d70811181248y176c5d7au2a407bbd30241a48@mail.gmail.com>
Date: Tue, 18 Nov 2008 21:48:56 +0100
From: "Jim Kannampuzha" <jim.kannampuzha@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] which module for hvr900h
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

Hi list,

I bought a Hauppauge HVR-900 Live stick. I googled that it is the same
as the HVR-900H and needs the xc3028 firmware. I extracted the
firmware using http://www.mjmwired.net/kernel/Documentation/video4linux/extract_xc3028.pl
and copied the resulting xc3028-v27.fw in /lib/firmware. I checked out
http://linuxtv.org/hg/~mchehab/tm6010/, where the changelog says that
it got support for the HVR900H. It compiled without problems and
created many kernel modules, but there is no tm6010.ko kernel module.
Since there are no other modules, whose names I can connect with my
hvr900h and since there are too many modules to try out each of them,
I just want to ask if somebody can point me to the right file. When I
plug in the stick dmesg just says

[ 5352.304027] usb 2-10: new high speed USB device using ehci_hcd and address 3
[ 5352.442105] usb 2-10: configuration #1 chosen from 1 choice

Thanks in advance,
Jim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
