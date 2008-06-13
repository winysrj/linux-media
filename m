Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp1.ethz.ch ([82.130.70.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cluck@student.ethz.ch>) id 1K7BkN-0005hs-0g
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 18:03:30 +0200
Message-ID: <48529A3E.9080407@ethz.ch>
Date: Fri, 13 Jun 2008 18:03:10 +0200
From: Claudio Luck <cluck@ethz.ch>
MIME-Version: 1.0
To: Alireza Torabi <alireza.torabi@gmail.com>
References: <cffd8c580806130739s6f23cc11mc96db647e522f072@mail.gmail.com>	<cffd8c580806130755t21f428e5qdb83daa47f4d6665@mail.gmail.com>	<cffd8c580806130817v35b813cay5440485baf55e526@mail.gmail.com>
	<cffd8c580806130829q8ea461fg57e040482ae8af7c@mail.gmail.com>
In-Reply-To: <cffd8c580806130829q8ea461fg57e040482ae8af7c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Mantis kernel modules and VP-1041/SP400 CI,
 HD2 card
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

Alireza Torabi wrote:
> Err! I can't load the module...
> HELP please...
> 
> Jun 13 17:24:26 alpha kernel: stv0299: Unknown symbol i2c_transfer
> Jun 13 17:24:26 alpha kernel: stb0899: Unknown symbol i2c_transfer
> Jun 13 17:24:26 alpha kernel: stb6100: Unknown symbol i2c_transfer
> Jun 13 17:24:26 alpha kernel: mb86a16: Unknown symbol i2c_transfer

i2c problems -> try older kernels, start with latest 2.6.24.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
