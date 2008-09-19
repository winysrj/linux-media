Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KggaG-0003VE-9n
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 16:03:45 +0200
Message-ID: <1115.87.93.154.167.1221833018.squirrel@webmail.kapsi.fi>
In-Reply-To: <48D2290D.7000808@gmail.com>
References: <48D2290D.7000808@gmail.com>
Date: Fri, 19 Sep 2008 17:03:38 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "kless" <wunderkless@gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb-t receiver sturm ns-06
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

to 18.9.2008 13:10 kless kirjoitti:
> hi,
> I would like to use my dvb-t usb on linux, is a dvb-t receiver sturm ns-06
> .
> I can find nothing about it, no producer website nothing. I only know
> that is chines.
> if someone would like to guide me / to experiment is wellcome.
> Alberto

There is many ways to identify chips...

* lsusb -vv -d <usb:id>
* examine Windows drivers
 - driver file names
 - driver .inf-file
 - looks strings from driver (use strings command)
* open device and look prints top of the ICs
* sniff USB-traffic from Windows and try to determine chips from I2C-data

regards
Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
