Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12] helo=amy.cooptel.qc.ca)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlemieu@cooptel.qc.ca>) id 1MMLj5-0001vg-6R
	for linux-dvb@linuxtv.org; Thu, 02 Jul 2009 14:49:19 +0200
Message-ID: <4A4CACAA.5060204@cooptel.qc.ca>
Date: Thu, 02 Jul 2009 08:48:42 -0400
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] kernel configuration: CX88 and RealTime kernel rt22.
Reply-To: linux-media@vger.kernel.org
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

Hi,

I applied patch-2.6.29.5-rt22.bz2 to a copy of my running 2.6.29.5
kernel and I find that this removes support for CX88.  This is
my first attempt at compiling/using the real-time kernel.

Just running 'menuconfig' without selecting other option purges
CX88_DVB from the .config file.

pc3:/sa107/wa_rlx/linux-2.6.29.5-rt22$ cp /c/boot/sa103/config-2.6.29.5 .config
pc3:/sa107/wa_rlx/linux-2.6.29.5-rt22$ grep CX88 .config
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
# CONFIG_VIDEO_CX88_BLACKBIRD is not set
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
pc3:/sa107/wa_rlx/linux-2.6.29.5-rt22$ make menuconfig
scripts/kconfig/mconf arch/x86/Kconfig
#
# configuration written to .config
#


*** End of Linux kernel configuration.
*** Execute 'make' to build the kernel or try 'make help'.

pc3:/sa107/wa_rlx/linux-2.6.29.5-rt22$ grep CX88 .config
pc3:/sa107/wa_rlx/linux-2.6.29.5-rt22$


All symbols with CX88 have disappeared from the .config file.

Trying menuconfig and xconfig, both seem to know about CX88_DVB
but there is no way to find 'Conexant 2388x' driver.

Was this intended by the CX88 team or is it just just an error from
the real-time team?  This is not that I absolutely need the realtime
kernel, but I am just curious, and a number applications including
'jack' would be happier with it.


Richard

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
