Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jburgess777@googlemail.com>) id 1L6ncQ-0004uD-6q
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 15:49:55 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1213861nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 06:49:49 -0800 (PST)
From: Jon Burgess <jburgess777@googlemail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
In-Reply-To: <4932A1E2.5060606@cadsoft.de>
References: <4932A1E2.5060606@cadsoft.de>
Date: Sun, 30 Nov 2008 14:49:45 +0000
Message-Id: <1228056585.4248.8.camel@localhost.localdomain>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with TT-Budget-T-CI PCI firmware
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

On Sun, 2008-11-30 at 15:23 +0100, Klaus Schmidinger wrote:
> I'm trying to use the latest s2API driver from http://linuxtv.org/hg/v4l-dvb
> (7100e78482d7) with a TT-Budget-T-CI PCI card:
> 
> Nov 30 15:13:45 vdr2 kernel: DVB: registering new adapter (TT-Budget-T-CI PCI)
> Nov 30 15:13:45 vdr2 kernel: adapter has MAC addr = 00:d0:5c:07:d7:39
> Nov 30 15:13:45 vdr2 kernel: input: Budget-CI dvb ir receiver saa7146 (3) as /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/input/input11
> Nov 30 15:13:45 vdr2 kernel: DVB: registering adapter 3 frontend 0 (Philips TDA10046H DVB-T)...
> Nov 30 15:13:45 vdr2 kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> 
> I ran
> 
>   linux/Documentation/dvb/get_dvb_firmware tda10045
> 
> to get the firmware file dvb-fe-tda10045.fw and copied it to
> /lib/firmware. The driver then told me to rename that file to
> dvb-fe-tda10046.fw, which I did. When starting the application
> I get

Which documentation was it that said to rename the '45 file as '46?
The get_dvb_firmware script has an option to fetch the tda10046
firmware.

> The file that got downloaded was tt_budget_217g.zip, and the dvb-fe-tda10045.fw
> has a size of 30555 byte and an md5sum of 2105fd5bf37842fbcdfa4bfd58f3594a.
> 
> Am I doing something wrong here?

The firmware files I have are:

/lib/firmware/dvb-fe-tda10045.fw
size: 30555
md5sum: 2105fd5bf37842fbcdfa4bfd58f3594a

/lib/firmware/dvb-fe-tda10046.fw
size: 24478
md5sum: 6a7e1e2f2644b162ff0502367553c72d

	Jon



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
