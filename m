Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Kxs8F-0005wd-S1
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 00:49:54 +0100
Received: from localhost.localdomain (unknown [127.0.0.1])
	by a-sasl-fastnet.sasl.smtp.pobox.com (Postfix) with ESMTP id
	70BC279F7F
	for <linux-dvb@linuxtv.org>; Wed,  5 Nov 2008 18:49:03 -0500 (EST)
Received: from [192.168.1.12] (unknown [118.208.2.50]) (using TLSv1 with
	cipher AES128-SHA (128/128 bits)) (No client certificate requested) by
	a-sasl-fastnet.sasl.smtp.pobox.com (Postfix) with ESMTPSA id A3F5579F7E
	for <linux-dvb@linuxtv.org>; Wed,  5 Nov 2008 18:49:00 -0500 (EST)
Message-Id: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Thu, 6 Nov 2008 09:48:47 +1000
Subject: [linux-dvb] dvbloopback:
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

Am trying to use dvbloopback in a setup with two cards, but it seems  
to fail, I get these errors;

Nov  6 09:30:30.151 frontend: Could not open /dev/dvb/adapter2/ 
frontend1. Error was: 14
Open failed
: Bad address
Nov  6 09:30:30.151 demux: Could not open /dev/dvb/adapter2/demux1.  
Error was: 14
Open failed
: Bad address

Looking in /var/log/messages, I see the errors;

Nov  6 09:30:30 htpc kernel: Failed to find private data during open

Looking into the dvbloopback kernel module source, it looks like it's  
not able to retrieve its private member variables;

lbdev = (struct dvblb_devinfo *)dvbdev->priv;
if (lbdev == NULL) {
   printk("Failed to find private data during open\n");
   return -EFAULT;
}

This would indicate something serious is happening with the kernel  
module loading? I am using kernel 2.6.26, am not sure if there are any  
incompatibilities there, as the compile script seems to support up to  
2.6.25 only?

Is the dvbloopback module author subscribed to this list?

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
