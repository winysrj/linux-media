Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roshan@olenepal.org>) id 1LDzy8-0003zA-UR
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 12:26:06 +0100
Received: by ti-out-0910.google.com with SMTP id w7so1373241tib.13
	for <linux-dvb@linuxtv.org>; Sat, 20 Dec 2008 03:25:58 -0800 (PST)
From: Roshan Karki <roshan@olenepal.org>
To: linux-dvb@linuxtv.org
Date: Sat, 20 Dec 2008 17:10:41 +0545
Message-Id: <1229772341.6521.5.camel@roxan-laptop>
Mime-Version: 1.0
Subject: [linux-dvb] YUAN High-Tech STK7700PH problem
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

Hello,

I have tv-tuner with may laptop. I downloaded the source from
linuxtv.org and installed it. It asked for two files
dvb-usb-dib0700-1.20.fw and xc3028-v27.fw. which I copied from internet.

I cant however scan for any channels. I have added dump_stack to
dib0700_core.c and here is the dmesg output.

http://pastebin.com/d77534a37

snippet from irc
<roxan> devinheitmueller: does it look if my hardware is damaged?
<devinheitmueller> Well, the dib7000p demodulator is not answering the
very first i2c command it is sent, which usually means the chip is
totally non-functional.

Please help.
-- 
Regards,
Roshan Karki

--
This message is intended only for the person or entity to which it is
addressed and may contain confidential and/or privileged information. If
you have received this message in error, please notify the sender
immediately and delete this message from your system. 

Reasonable precautions have been taken to ensure that this message is
virus-free. However, I do not accept responsibility for any loss or
damage arising from the use of this message or attachments.
--


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
