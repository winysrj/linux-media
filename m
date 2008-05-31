Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.movial.fi ([62.236.91.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.noordsij@movial.fi>) id 1K2Qta-000513-7O
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 15:13:19 +0200
Received: from localhost (mailscanner.hel.movial.fi [172.17.81.9])
	by smtp.movial.fi (Postfix) with ESMTP id 75A3FC80D2
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 16:12:43 +0300 (EEST)
Received: from smtp.movial.fi ([62.236.91.34])
	by localhost (mailscanner.hel.movial.fi [172.17.81.9]) (amavisd-new,
	port 10026) with ESMTP id XDVdL1oPcLHk for <linux-dvb@linuxtv.org>;
	Sat, 31 May 2008 16:12:43 +0300 (EEST)
Received: from [127.0.0.1] (hellgapp.hel.movial.fi [172.17.83.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.movial.fi (Postfix) with ESMTP id 272B8C809D
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 16:12:43 +0300 (EEST)
Message-ID: <48414EC8.3080008@movial.fi>
Date: Sat, 31 May 2008 15:12:40 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] usb-dvb and endpoints question
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

I am writing a driver for the TerraTec Piranha DVB-T USB stick (actually
the Sanio SMS-1000 chipset). From reading USB logs I have a working
libusb prototype which can tune and receive the transport stream, and
use the hardware PID filter.

Porting it to a proper linux DVB driver I have the following question:

This device has exactly 2 bulk endpoints, as follows:

      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

All control messages go out over EP2. All responses, as well as the
transport stream, come in over EP1.

All incoming packets have a small header which allows it to be mapped
back to the corresponding request (excepting TS data which can be read
spontaneously, but which is still marked with an additional header).

Does this mean that I can not really use the dvb-usb framework ? (since
there is no generic_bulk_ctrl_endpoint, and since the TS stream also
does not come on its own endpoint and even needs additional depackatizing).

Since incoming data is mixed with TS packets, you can no longer just
write a command and read the next response. TS data will be streaming in
and every time you make some request you will probably get some TS data
first, and only then your response. How to solve?

Any pointers in the right direction? :-)

Cheers,
Dennis


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
