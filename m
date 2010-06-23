Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1ORSf9-0001ha-Hh
	for linux-dvb@linuxtv.org; Wed, 23 Jun 2010 18:18:57 +0200
Received: from ey-out-2122.google.com ([74.125.78.25])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1ORSf8-0000Kc-6K; Wed, 23 Jun 2010 18:18:55 +0200
Received: by ey-out-2122.google.com with SMTP id 9so455758eyd.39
	for <linux-dvb@linuxtv.org>; Wed, 23 Jun 2010 09:18:53 -0700 (PDT)
Date: Wed, 23 Jun 2010 18:18:51 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: shacky <shacky83@gmail.com>
In-Reply-To: <AANLkTinks_MHz5R7DzcR712IuZlLe54NXbvlvIfk2DJI@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006231814120.6056@localhost.localdomain>
References: <AANLkTinks_MHz5R7DzcR712IuZlLe54NXbvlvIfk2DJI@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Record from DVB tuner
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Wed (Wednesday) 23.Jun (June) 2010, 18:02,  shacky wrote:

> I need to record some DVB channels from the command line using a
> supported DVB tuner PCI card on Linux Debian.
> I know I can tune the DVB adapter using dvbtools and record the raw
> input using cat from /dev/dvb/adapter0, but what about recording two
> or more different channels from the same multiplex?
> How I can do this from the command line?

Use `dvbstream', if the channels retain pretty consistent PIDs.
Give the PIDs of all channels you want to record, perhaps 
including the PMT PIDs and PID 0 in order to allow automatic
selection later of the particular audio and video PIDs.  The
psuedo-PID value of 8192 will feed the entire transport stream to
the specified file if you want most or all available channels.


barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
