Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1LLK5q-0003sD-Or
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 17:20:20 +0100
Message-ID: <012b01c97276$68e03000$f4c6a5c1@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: "Manu Abraham" <abraham.manu@gmail.com>
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org><26D75E582F22456998AE6365440ACEC6@xplap>
	<49673D65.9030404@gmail.com>
	<58390.90.152.140.181.1231503119.squirrel@webmail.dark-green.com>
Date: Fri, 9 Jan 2009 17:22:04 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

> The official mantis repository is at http://jusst.de/hg/mantis. It
> contains the latest mantis related changes.
>
> Please do test and report.
>
> Regards,
> Manu

Hi Manu,
I have Technistat CableStar HD 2
http://www.technisat.com/index7b97.html?nav=PC_products,en,76-211 which is
VP-2040

I have tested two mantis versions.

Sep 21 mantis-303b1d29d735
- It reports unsupported CAM (Technisat TechniCrypt CX Conax module)
dvb_ca adapter 1: Invalid PC card inserted :(
but at least few FTA channels work perfectly.

Recent mantis-147f405ecd77
- Almost the same behaviour only after inserting the mantis module dmesg
reports one new line more at the end:
mantis_uart_read (0): RX Fifo FULL
but the FTA channels still work.

I saw in the archive of the linux-dvb list that the mantis CI support is not
finalized yet. Is there any plan/chance to get it working?

Regards,
Tomas


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
