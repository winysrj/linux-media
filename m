Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jnyfx-0002b5-2p
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 18:15:32 +0200
From: allan k <sonofzev@iinet.net.au>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Tue, 22 Apr 2008 02:15:28 +1000
Message-Id: <1208794528.9790.10.camel@media1>
Mime-Version: 1.0
Subject: [linux-dvb] help with dvico usb remote on gentoo
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

Hi All 

While I'm waiting for help with the dvico dual express. I have been
trying to get the dvico usb remote working on gentoo. 

I've followed the couple of how-tos for gentoo and lirc and come up with
the same problem every time. 

I get stuck where it asks to load the module...... 

After running emerge lirc, I find there is no lirc_dvico module, as all
the instructions mention. as such I don't end up with an lirc device in
my /dev/ directory. 

I tried issuing the config-kernel --allow-writeable=yes but my system
has no such command and I can't find which package it belongs to. 

I'm pretty sure I'm missing something simple, so any advice will be
appreciated. 

cheers

Allan 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
