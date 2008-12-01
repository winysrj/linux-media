Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.belimov@gmail.com>) id 1L6y5U-0005UQ-Ua
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 03:00:39 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1312683nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 18:00:32 -0800 (PST)
Date: Mon, 1 Dec 2008 11:02:16 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Behzat <b3hzat@gmail.com>
Message-ID: <20081201110216.4c2d600d@glory.loctelecom.ru>
In-Reply-To: <200811291557.57092.b3hzat@gmail.com>
References: <200811291557.57092.b3hzat@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to write driver for xilinx spartan iie xc2s50e
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

Hi 
 
> I want to write driver for xilinx spartan iie xc2s50e chipset.
> 
> How to start for this case. Could you give me any suggest or idea for
> this?

This is FPGA Field Programmed Array. A hardware designer write some code on VHDL or Verilog
describing howto it should be worked and programm this FPGA. For work with current firmware in FPGA
you should have description or API. If you have, write your driver as for common chip.

With my best regards, Dmitry.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
