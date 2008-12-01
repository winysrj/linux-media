Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp125.rog.mail.re2.yahoo.com ([206.190.53.30])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L6zaY-0003m4-WA
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 04:36:48 +0100
Message-ID: <49335BAB.70107@rogers.com>
Date: Sun, 30 Nov 2008 22:36:11 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
References: <200811291557.57092.b3hzat@gmail.com>
	<20081201110216.4c2d600d@glory.loctelecom.ru>
In-Reply-To: <20081201110216.4c2d600d@glory.loctelecom.ru>
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

Dmitri Belimov wrote:
> Hi 
>  
>   
>> I want to write driver for xilinx spartan iie xc2s50e chipset.
>>
>> How to start for this case. Could you give me any suggest or idea for
>> this?
>>     
>
> This is FPGA Field Programmed Array. A hardware designer write some code on VHDL or Verilog
> describing howto it should be worked and programm this FPGA. For work with current firmware in FPGA
> you should have description or API. If you have, write your driver as for common chip.
>
> With my best regards, Dmitry.

You'd have to check, but I'd imagine that you can get the datasheet from
Xilinx, which would greatly assist your effort. (I know that I have a
Spartan 3e sheet which I found on their site probably a year or so ago,
so can't think why the 2e wouldn't be as freely available).

And pulling up a stored link, here is a project that makes use of a 2e
family member, so you could likely find other some examples and code:

http://www.linuxdevices.com/articles/AT2441343146.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
