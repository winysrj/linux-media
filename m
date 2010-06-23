Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <shacky83@gmail.com>) id 1ORU0o-0003Vf-Iv
	for linux-dvb@linuxtv.org; Wed, 23 Jun 2010 19:45:22 +0200
Received: from mail-fx0-f54.google.com ([209.85.161.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1ORU0n-0003vS-2u; Wed, 23 Jun 2010 19:45:22 +0200
Received: by fxm7 with SMTP id 7so3913128fxm.41
	for <linux-dvb@linuxtv.org>; Wed, 23 Jun 2010 10:45:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1006231814120.6056@localhost.localdomain>
References: <AANLkTinks_MHz5R7DzcR712IuZlLe54NXbvlvIfk2DJI@mail.gmail.com>
	<alpine.DEB.2.01.1006231814120.6056@localhost.localdomain>
Date: Wed, 23 Jun 2010 19:45:20 +0200
Message-ID: <AANLkTimkBmG_q901b758IQWDprRiVMfwbq7rwdZu6GSs@mail.gmail.com>
From: shacky <shacky83@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Use `dvbstream', if the channels retain pretty consistent PIDs.
> Give the PIDs of all channels you want to record, perhaps
> including the PMT PIDs and PID 0 in order to allow automatic
> selection later of the particular audio and video PIDs. =A0The
> psuedo-PID value of 8192 will feed the entire transport stream to
> the specified file if you want most or all available channels.

Thank you very much. I will use dvbstream.

I have another question for you. Do you have any idea about how to
show the live-TV on a web page using for example a Flash window?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
