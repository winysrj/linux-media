Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.movial.fi ([62.236.91.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.noordsij@movial.fi>) id 1K2UQD-0007QM-6l
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 18:59:14 +0200
Message-ID: <484183BC.6060405@movial.fi>
Date: Sat, 31 May 2008 18:58:36 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <48414EC8.3080008@movial.fi> <48415A24.5080305@iki.fi>
In-Reply-To: <48415A24.5080305@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] usb-dvb and endpoints question
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


> Other thoughts, wMaxPacketSize 0x0040 1x 64 bytes looks rather small for
> TS.

Incidentally, usb-sniff reports the following:

  ConfigurationDescriptor = 0xffb6adf8 (configure)
  ConfigurationDescriptor : bLength             = 9
  ConfigurationDescriptor : bDescriptorType     = 0x00000002
  ConfigurationDescriptor : wTotalLength        = 0x00000020
  ConfigurationDescriptor : bNumInterfaces      = 0x00000001
  ConfigurationDescriptor : bConfigurationValue = 0x00000001
  ConfigurationDescriptor : iConfiguration      = 0x00000000
  ConfigurationDescriptor : bmAttributes        = 0x00000080
  ConfigurationDescriptor : MaxPower            = 0x00000032
  ConfigurationHandle     = 0x811fa720
  Interface[0]: Length            = 56
  Interface[0]: InterfaceNumber   = 0
  Interface[0]: AlternateSetting  = 0
  Interface[0]: Class             = 0x000000ff
  Interface[0]: SubClass          = 0x00000002
  Interface[0]: Protocol          = 0x00000000
  Interface[0]: InterfaceHandle   = 0xffb7efa0
  Interface[0]: NumberOfPipes     = 2
  Interface[0]: Pipes[0] : MaximumPacketSize = 0x00000040
  Interface[0]: Pipes[0] : EndpointAddress   = 0x00000081
  Interface[0]: Pipes[0] : Interval          = 0x00000000
  Interface[0]: Pipes[0] : PipeType          = 0x00000002 (UsbdPipeTypeBulk)
  Interface[0]: Pipes[0] : PipeHandle        = 0xffb7efbc
  Interface[0]: Pipes[0] : MaxTransferSize   = 0x00010000
  Interface[0]: Pipes[0] : PipeFlags         = 0x00000000
  Interface[0]: Pipes[1] : MaximumPacketSize = 0x00000040
  Interface[0]: Pipes[1] : EndpointAddress   = 0x00000002
  Interface[0]: Pipes[1] : Interval          = 0x00000000
  Interface[0]: Pipes[1] : PipeType          = 0x00000002 (UsbdPipeTypeBulk)
  Interface[0]: Pipes[1] : PipeHandle        = 0xffb7efdc
  Interface[0]: Pipes[1] : MaxTransferSize   = 0x00010000  <<<<<<<<
  Interface[0]: Pipes[1] : PipeFlags         = 0x00000000

which makes more sense ?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
