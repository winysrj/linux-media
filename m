Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KENcW-00043T-5V
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 14:09:05 +0200
Message-ID: <486CC15B.5050902@iki.fi>
Date: Thu, 03 Jul 2008 15:08:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Peter Parkkali <peter.parkkali@iki.fi>
References: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>
In-Reply-To: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 driver fails on ubuntu 8.04 / alink dtu-m
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

terve Peter,

Peter Parkkali wrote:
> Hi,
> 
> Since upgrading to Ubuntu 8.04 (Linux 2.6.24-19), I haven't been able  
> to get Antti's af9015 driver to work with the a-link's "DTU(m)" dongle  
> (USB 15a4:9016). I'm using the latest version from http://linuxtv.org/hg/ 
> ~anttip/af9015/ . An older version of the driver did work earlier this  
> year on Ubuntu 7.10 with the same stick, however.

 From the logs I see that you have USB1.1. Could you comment out USB1.1 
stuff from af9015_read_config -function and test if it resolves issue 
you have. Function is inside of the af9015.c -file.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
