Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JNCYG-0000ZD-G0
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 20:36:52 +0100
Received: by fk-out-0910.google.com with SMTP id z22so3652268fkz.1
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 11:36:49 -0800 (PST)
Message-ID: <37219a840802071136n4afef7b2y19cdbcdc519fa6b4@mail.gmail.com>
Date: Thu, 7 Feb 2008 14:36:48 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Henry Leinhos" <henry-list@leinhos.com>
In-Reply-To: <20080207173847.865.qmail@pop.iicinternet.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080207173847.865.qmail@pop.iicinternet.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] wintv-hvr-1250 setup?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Feb 7, 2008 12:38 PM, Henry Leinhos <henry-list@leinhos.com> wrote:

> I'm not sure which modules are required, but when I load the cx23885 module
> (via /sbin/modprobe cx23885), I get an error on the tveeprom header.  dmesg
> reports:
>
> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
> [card=3,autodetected]
> cx23885[0]: i2c bus 0 registered
> cx23885[0]: i2c bus 1 registered
> cx23885[0]: i2c bus 2 registered
> tveeprom 4-0050: Encountered bad packet header [ff]. Corrupt or not a
> Hauppauge eeprom.
> cx23885[0]: warning: unknown hauppauge model #0
> cx23885[0]: hauppauge eeprom: model=0
> cx23885[0]: cx23885 based dvb card
> MT2131: successfully identified at address 0x61
> DVB: registering new adapter (cx23885[0])
> DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0, mmio:
> 0xfce00000
> PCI: Setting latency timer of device 0000:03:00.0 to 64
>
>
> I'm concerned about the tveeprom message  -- are there any other modules I
> need to load for this board?  Is there any firmware I'm missing?

Don't worry about the tveeprom error message -- we know why it is
happening, and a fix will probably be committed for it relatively
soon.

For your card, the error has absolutely no influence on the operation
of the device.  The linux driver currently only supports ATSC / QAM
digital tv on your board, you do not need any firmware for this
functionality.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
