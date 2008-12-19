Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1LDnmx-0003dz-37
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 23:25:43 +0100
Message-ID: <494C1F62.2040901@iki.fi>
Date: Sat, 20 Dec 2008 00:25:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jos Hoekstra <joshoekstra@gmx.net>
References: <53501.62.178.208.71.1229623443.squirrel@webmail.dark-green.com>	<200812191943.00696.sinter.mann@gmx.de>	<d9def9db0812191129w7188489aq1a2d076ad5198d6a@mail.gmail.com>	<200812192058.58686.sinter.mann@gmx.de>	<d9def9db0812191211k4b6abf3fv80e489a286e8e3a6@mail.gmail.com>	<37219a840812191231i775a1769x8705b644cfb21bab@mail.gmail.com>	<412bdbff0812191247j60480e61wa3c1aea74f1e118@mail.gmail.com>	<1229720907.31427.18.camel@youkaida>
	<494C1B1F.40205@gmx.net>
In-Reply-To: <494C1B1F.40205@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Adding info to the wiki,
 Was: Re:  S2API drivers sync
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

Jos Hoekstra wrote:
> I would like to add some pointers on making the Avermedia Volar X DVB-T 
> device work to the wiki, but I'm not sure if this 'supported or unsupported?

It is supported. Anyhow, with this tuner driver performance is not 100%. 
Driver merged to the 2.6.28 Kernel.

> Case:
> Avermedia Volar X DVB-T with AF9015-NT* & MXL5003S
> Works with compiling the source from:
> http://linuxtv.org/hg/~anttip/af9015/

You can also use v4l-dvb-master or wait 2.6.28.

> and firmware from:
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/
> 
> Is it ok if I add it as a minor edit to:
> 
> http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices#Afatech_AF9013_and_AF9015
> ?

yes?

> Regards,
> 
> Jos Hoekstra

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
