Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail0.scram.de ([78.47.204.202] helo=mail.scram.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jochen@scram.de>) id 1LDlik-0005A7-Si
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 21:13:15 +0100
Message-ID: <494C0002.1060204@scram.de>
Date: Fri, 19 Dec 2008 21:11:46 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Roberto Ragusa <mail@robertoragusa.it>
References: <4936FF66.3020109@robertoragusa.it>
In-Reply-To: <4936FF66.3020109@robertoragusa.it>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend
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

Hi Roberto,

> Is there any plan to include this frontend in mainline kernels?
> I used to run this driver months ago and it was working well.

The reason is the huge memory footprint due to the included frequency table.
I worked a bit on the driver to get rid of this table. Could you try this version:

1. Patch for AF9015:

http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=commitdiff;h=e5d7398a4b2d3c520d949e53bbf7667a481e9690

2. MC44S80x tuner driver:

http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.c;h=b8dd335e64b03b8544b4c95e2d7f3dbd968078a0;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x.h;h=c6e76da6bf51163c90f0ead259c0e54d4f637671;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=blob;f=drivers/media/common/tuners/mc44s80x_reg.h;h=299c1be9a80a3777fb46f65d6070965de9754787;hb=4bde668b4eca90f8bdcc5916dfc88c115a3dfd20

Thanks,
Jochen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
