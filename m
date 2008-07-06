Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KFJ77-0000PC-JD
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 03:32:32 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 6 Jul 2008 03:31:37 +0200
References: <1214127575.4974.7.camel@jaswinder.satnam>
In-Reply-To: <1214127575.4974.7.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807060331.37548@orion.escape-edv.de>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
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

Jaswinder Singh wrote:
> +config DVB_AV7110_BOOTCODE
> +	bool "Compile AV7110 bootcode into the driver"
> +	depends on DVB_AV7110
> +	help
> +	  This includes firmware for AV7110 bootcode
> +	  Say 'N' and let it get loaded from userspace on demand 

This option does not make any sense.

Nobody needs to replace the bootloader.
Furthermore, if you load the boot code from userspace, you must provide
some means to ensure data integrity (file header, crc protection).
It is a very bad idea to load garbage into the ARM processor...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
